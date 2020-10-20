package.loaded.ffi = {typeof=function() end}
os = {getenv=function() end}
io = {open=function() end}
bit = {band = function(a,b) return a & b end,
       rshift=function(a,b) return a >> b end}
unpack = table.unpack

local antifennel = dofile("antifennel.lua")
local fennel = require("fennel")
local js = require("js")

js.global.onmessage = function(_, e)
   local isFennel = e.data:match("^ ")
   local compiler = isFennel and fennel.compileString or antifennel
   local ok, result = pcall(compiler, e.data)
   if not ok then
      js.global:postMessage(result .. "\n")
   elseif isFennel then
      js.global:postMessage(result .. " ")
   else
      js.global:postMessage(result .. "\t")
   end
end

js.global:postMessage("Loaded Fennel " .. fennel.version .. " in " .. _VERSION)
