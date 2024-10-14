local M = {}

local util = require("jb.util")

local function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

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
        local last_hl_name = nil
        local last_attr = nil
        for attr, value in pairs(attrs) do
          last_attr = attr
          local props = util.get_hl_props(colors, value, profile)
          last_hl_name = string.gsub(value, "|", "_")
          hl[attr] = props.prop or props.hl[attr]
        end
        local group_name = tablelength(attrs) == 1
            and last_hl_name .. "-" .. last_attr
            or group .. "_Custom"
        vim.api.nvim_set_hl(0, group_name, hl)
        hl.link = group_name
      end
      if attrs ~= nil and attrs ~= "" then
        local props = hl.link ~= nil and { link = hl.link } or hl
        vim.api.nvim_set_hl(0, group, props)
      end
    end
  end
end

return M
