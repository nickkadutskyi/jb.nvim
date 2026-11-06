-- Run with: nvim --headless --clean -l tests/php_template_language.lua
-- Requires the PHP Tree-sitter parser (as does the theme's PHP query).
local root = vim.fs.dirname(vim.fs.dirname(vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p")))
vim.opt.runtimepath:prepend(root)
vim.opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/site")
require("jb")

local query =
    vim.treesitter.query.parse("php", table.concat(vim.fn.readfile(root .. "/after/queries/php/highlights.scm"), "\n"))

local function check(source, php, html, bufnr)
    local parser = bufnr and vim.treesitter.get_parser(bufnr, "php") or vim.treesitter.get_string_parser(source, "php")
    local ranges = {}
    for capture, node in query:iter_captures(parser:parse()[1]:root(), bufnr or source) do
        if query.captures[capture] == "template_language" then
            ranges[#ranges + 1] = { node:range() }
        end
    end

    local function covered(fragment)
        local start = assert(source:find(fragment, 1, true), fragment)
        local prefix = source:sub(1, start - 1)
        local _, row = prefix:gsub("\n", "")
        local col = #prefix:match("[^\n]*$")
        for _, range in ipairs(ranges) do
            if
                (row > range[1] or row == range[1] and col >= range[2])
                and (row < range[3] or row == range[3] and col < range[4])
            then
                return true
            end
        end
        return false
    end

    for _, fragment in ipairs(php) do
        assert(covered(fragment), "Missing PHP background: " .. fragment .. " in " .. source)
    end
    for _, fragment in ipairs(html) do
        assert(not covered(fragment), "Unexpected PHP background: " .. fragment .. " in " .. source)
    end
    if #php == 0 then
        assert(#ranges == 0, "Non-template PHP must not receive a template background")
    end
end

check('<?php echo "<b>not HTML</b>";', {}, { "<?php", "echo" })
check("<?php echo 1; ?>plain text", {}, { "<?php", "echo" })
check("<p><?= $value ?></p>", { "<?=", "$value", "?>" }, { "<p>", "</p>" })
check("<?php if ($ok) { ?><b><?= $value ?></b><?php } ?>", { "if", "$ok", "{", "$value", "}" }, { "<b>", "</b>" })
check(
    '<?php if ($ok): ?><b>yes</b><?php else: echo "no"; endif; ?>',
    { "if", "$ok", "else", "echo", "endif" },
    { "<b>", "yes", "</b>" }
)
check(
    "<style>body { color: <?= $color ?>; }</style>\n<script>f(<?= json_encode($data) ?>)</script>",
    { "$color", "json_encode", "$data" },
    { "<style>", "body", "<script>", "f(" }
)
check("<?php /** docs */\n$x = 1; ?>\n<p>HTML</p>", { "/** docs */", "$x" }, { "<p>", "HTML" })

-- Reparse one buffer in both directions to detect stale classifications.
local bufnr = vim.api.nvim_create_buf(false, true)
for _, text in ipairs({ "plain", "<b>HTML</b>", "plain" }) do
    local source = "<?php echo 1; ?>" .. text
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { source })
    check(source, text == "plain" and {} or { "<?php", "echo" }, { text }, bufnr)
end
vim.api.nvim_buf_delete(bufnr, { force = true })
print("PHP template captures: string previews, nested templates, and buffer edits passed")
