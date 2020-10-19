package.loaded.ffi = {typeof=function() end}
os = {getenv=function() end}
io = {open=function() end}
bit = {band = function(a,b) return a & b end,
       rshift=function(a,b) return a >> b end}
unpack = table.unpack

local antifennel = dofile("antifennel.lua")
local fennel = require("fennel")
local js = require("js")

js.global.onmessage = function(e)
   local isFennel, code = unpack(e.data)
   local compiler = isFennel and fennel.compileString or antifennel
   local ok, result = pcall(compiler, code)
   js.global.console:log("worker", ok, result)
   js.global:postMessage({ok, result})
end
