package.path = "./?.lua"
local js = require("js")

-- minimal shims just to allow the compilers to load in Fengari
package.loaded.ffi = {typeof=function() end}
os = {getenv=function() end}
io = {open=function() end}
bit = {band = function(a,b) return a & b end,
       rshift=function(a,b) return a >> b end}
unpack = table.unpack

function print(...) js.global.console:log(...) end

local document = js.global.document
local compile_fennel = document:getElementById("compile-fennel")
local compile_lua = document:getElementById("compile-lua")
local out = document:getElementById("out")

local fennel_source = document:getElementById("fennel-source")
local lua_source = document:getElementById("lua-source")

local status = function(msg, success)
   out.innerHTML = msg
   out.style.color = success and "black" or "#dd1111"
end

local done = function(fennel_compile, antifennel)
   compile_fennel.onclick = function()
      local ok, code = pcall(fennel_compile, fennel_source.value)
      if ok then
         lua_source.value = code
         status("Compiled Fennel to Lua.", true)
      else
         status("Fennel: " .. tostring(code), false)
      end
   end

   compile_lua.onclick = function()
      -- for Lua that doesn't parse, antifennel gives crummy error messages
      local ok, msg = load(lua_source.value)
      if not ok then return status("Lua: " .. msg, false) end

      local ok, code = pcall(antifennel, lua_source.value)
      if ok then
         fennel_source.value = code
         status("Compiled Lua to Fennel.\n\n"..
                   "Note that compiling Lua to Fennel can result in some" ..
                   " strange-looking code when\nusing constructs that Fennel" ..
                   " does not support natively, like early returns.", true)
      else
         status("Lua: " .. tostring(code), false)
      end
   end

   out.innerHTML = "Loaded Fennel and Antifennel."
end

local started = false

local init_worker = function()
   local worker = js.new(js.global.Worker, "/see-worker.js")
   local send = function(isFennel, code)
      worker:postMessage({isFennel, code})
      return assert(coroutine.yield())
   end
   local fennel = function(code) return send(true, code) end
   local antifennel = function(code) return send(false, code) end

   done(fennel, antifennel)
   local orig_f, orig_l = compile_fennel.onclick, compile_lua.onclick
   compile_fennel.onclick = function () coroutine.wrap(orig_f)() end
   compile_lua.onclick = function () coroutine.wrap(orig_l)() end

   worker.onmessage = function(_, e)
      local isFennel, ok, result = unpack(e.data)
      local coro = isFennel and compile_fennel.onclick or compile_lua.onclick
      js.global.console.log("result", result)
      coroutine.resume(coro, ok, result)
   end
end

local load_direct = function()
   local antifennel = dofile("antifennel.lua")
   return done(require("fennel").compileString, antifennel)
end

local init = function()
   if started then return end
   started = true
   out.innerHTML = "Loading..."

   if js.global.Worker then
      init_worker()
   elseif js.global.setTimeout then
      js.global:setTimeout(load_direct)
   else
      return load_direct()
   end
end

compile_fennel.onclick = init
compile_lua.onclick = init
fennel_source.onfocus = init
lua_source.onfocus = init

-- TODO: keyboard shortcuts
-- TODO: multiple Fennel versions?
-- TODO: samples
