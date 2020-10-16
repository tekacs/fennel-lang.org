package.path = "./?.lua"
local js = require("js")

-- minimal shims just to allow the compilers to load in Fengari
package.loaded.ffi = {typeof=function() end}
os = {getenv=function() end}
io = {open=function() end}
bit = {band = function() end, rshift=function() end}
unpack = table.unpack

function print(...) js.global.console.log(...) end

-- TODO: load asynchronously
local antifennel = dofile("antifennel")
local fennel = require("fennel")

local document = js.global.document
local compile_fennel = document:getElementById("compile-fennel")
local compile_lua = document:getElementById("compile-lua")
local out = document:getElementById("out")

local fennel_source = document:getElementById("fennel-source")
local lua_source = document:getElementById("lua-source")

compile_fennel.onclick = function()
   local ok, code = pcall(fennel.compileString, fennel_source.value)
   if ok then lua_source.value = code
   else out.innerHTML = "Fennel: " .. code end
end

compile_lua.onclick = function()
   -- for Lua that doesn't parse, antifennel gives crummy error messages
   local ok, msg = load(lua_source.value)
   if not ok then out.innerHTML = "Lua: " .. msg return end

   local ok, code = pcall(antifennel, lua_source.value)
   if ok then fennel_source.value = code
   else out.innerHTML = "Lua: " .. code end
end

out.innerHTML = "Loaded Fennel " .. fennel.version .. " in " .. _VERSION

-- TODO: keyboard shortcuts
-- TODO: multiple Fennel versions?
-- TODO: samples
