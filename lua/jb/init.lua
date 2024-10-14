local M = {}

local util = require("jb.util")

function M.dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. M.dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

function M.setup()
  local profile = vim.o.background -- 'dark' or 'light'
  local palette = util.read_palette()
  local colors = palette.colors
  local highlights = palette.highlights
  local hl_groups = {}

  for _, groups in pairs(highlights) do
    for group, attrs in pairs(groups) do
      local hl = {}
      if type(attrs) == "string" and attrs ~= "" then
        local props = util.get_hl_props(colors, attrs, profile)
        if group == props.name then
          hl = props.hl
        else
          if hl_groups[props.name] == nil then
            vim.api.nvim_set_hl(0, props.name, props.hl)
            hl_groups[props.name] = true
          end
          hl.link = props.name
        end
      elseif type(attrs) == "table" then
        for attr, value in pairs(attrs) do
          local props = util.get_hl_props(colors, value, profile)
          hl[attr] = props.prop or props.hl[attr]
        end
        vim.api.nvim_set_hl(0, group .. "_Custom", hl)
        hl.link = group .. "_Custom"
      end
      if attrs ~= nil and attrs ~= "" then
        local props = hl.link ~= nil and { link = hl.link } or hl
        vim.api.nvim_set_hl(0, group, props)
      end
    end
  end
end

return M
