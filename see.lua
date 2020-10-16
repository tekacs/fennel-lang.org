package.path = "./?.lua"
local js = require("js")

package.loaded.ffi = {typeof=function() end}os = {getenv=function() end}
io = {open=function() end}
bit = {band = function() end, rshift=function() end}
unpack = table.unpack
arg={false}

function print(...) js.global.console.log(...) end

-- TODO: load asynchronously
local antifennel = dofile("antifennel")
local fennel = require("fennel")

local document = js.global.document
local compile_fennel = document:getElementById("compile-fennel")
local compile_lua = document:getElementById("compile-lua")

local fennel_source = document:getElementById("fennel-source")
local lua_source = document:getElementById("lua-source")

compile_fennel.onclick = function()
   lua_source.value = fennel.compileString(fennel_source.value)
end

compile_lua.onclick = function()
   fennel_source.value = table.concat(antifennel(lua_source.value), "\n")
end

-- TODO: keyboard shortcuts
-- TODO: error handling
-- TODO: multiple Fennel versions?
