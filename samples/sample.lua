---@class Emmy
local var = {} -- a short comment
local a, b, c = true, false, nil
--region my class members region

---@alias MyType Emmy

--- doc comment
---@param par1 Par1Type @comments
function var:fun(par1, par2)
   print('hello')
   local test = par1
   return self.len + 2 + self.get()
end

---@overload fun(name:string):Emmy
function var.staticFun()
end
--endregion end my class members region
local hey = function() end
local function hey4() end
---@return Emmy
function findEmmy()
   local hey0 = ""
   local hey2 = function() end
   function hey3() end
   local function hey5() end
   return "string" .. var .. hey() .. hey2() .. hey3() .. hey4() .. hey5() .. hey0
end

local value = ""

globalVar = {
   property = value,
   property1 = value1
}


---@alias LazyPluginKind "normal"|"clean"|"disabled"

---@class LazyPluginState
---@field cache? table<string,any>
---@field cloned? boolean
---@field cond? boolean
---@field dep? boolean True if this plugin is only in the spec as a dependency
---@field dir? string Explicit dir or dev set for this plugin
---@field dirty? boolean
---@field build? boolean
---@field frags? number[]
---@field handlers? LazyPluginHandlers
---@field installed? boolean
---@field is_local? boolean
---@field kind? LazyPluginKind
---@field loaded? {[string]:string}|{time:number}
---@field outdated? boolean
---@field rtp_loaded? boolean
---@field tasks? LazyTask[]
---@field updated? {from:string, to:string}
---@field updates? {from:GitInfo, to:GitInfo}
---@field last_check? number
---@field working? boolean
---@field pkg? LazyPkg

---@alias PluginOpts table|fun(self:LazyPlugin, opts:table):table?

---@class LazyPluginHooks
---@field init? fun(self:LazyPlugin) Will always be run
---@field deactivate? fun(self:LazyPlugin) Unload/Stop a plugin
---@field config? fun(self:LazyPlugin, opts:table)|true Will be executed when loading the plugin
---@field build? false|string|async fun(self:LazyPlugin)|(string|async fun(self:LazyPlugin))[]
---@field opts? PluginOpts

---@class LazyPluginHandlers
---@field event? table<string,LazyEvent>
---@field ft? table<string,LazyEvent>
---@field keys? table<string,LazyKeys>
---@field cmd? table<string,string>

---@class LazyPluginRef
---@field branch? string
---@field tag? string
---@field commit? string
---@field version? string|boolean
---@field pin? boolean
---@field submodules? boolean Defaults to true

---@class LazyPluginBase
---@field [1] string?
---@field name string display name and name used for plugin config files
---@field main? string Entry module that has setup & deactivate
---@field url string?
---@field dir string
---@field enabled? boolean|(fun():boolean)
---@field cond? boolean|(fun():boolean)
---@field optional? boolean If set, then this plugin will not be added unless it is added somewhere else
---@field lazy? boolean
---@field priority? number Only useful for lazy=false plugins to force loading certain plugins first. Default priority is 50
---@field dev? boolean If set, then link to the respective folder under your ~/projects
---@field rocks? string[]
---@field virtual? boolean virtual plugins won't be installed or added to the rtp.

---@class LazyPlugin: LazyPluginBase,LazyPluginHandlers,LazyPluginHooks,LazyPluginRef
---@field dependencies? string[]
---@field specs? string|string[]|LazyPluginSpec[]
---@field _ LazyPluginState

---@class LazyPluginSpecHandlers
---@field event? string[]|string|LazyEventSpec[]|fun(self:LazyPlugin, event:string[]):string[]
---@field cmd? string[]|string|fun(self:LazyPlugin, cmd:string[]):string[]
---@field ft? string[]|string|fun(self:LazyPlugin, ft:string[]):string[]
---@field keys? string|string[]|LazyKeysSpec[]|fun(self:LazyPlugin, keys:string[]):((string|LazyKeys)[])
---@field module? false

---@class LazyPluginSpec: LazyPluginBase,LazyPluginSpecHandlers,LazyPluginHooks,LazyPluginRef
---@field name? string display name and name used for plugin config files
---@field dir? string
---@field dependencies? string|string[]|LazyPluginSpec[]
---@field specs? string|string[]|LazyPluginSpec[]

---@alias LazySpec string|LazyPluginSpec|LazySpecImport|LazySpec[]

---@class LazySpecImport
---@field import string|(fun():LazyPluginSpec) spec module to import
---@field name? string
---@field enabled? boolean|(fun():boolean)
---@field cond? boolean|(fun():boolean)

---@class LazyFragment
---@field id number
---@field pkg? boolean
---@field pid? number
---@field deps? number[]
---@field frags? number[]
---@field dep? boolean
---@field name string
---@field url? string
---@field dir? string
---@field spec LazyPlugin

