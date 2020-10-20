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

local anti_msg = "Compiled Lua to Fennel.\n\n"..
   "Note that compiling Lua to Fennel can result in some" ..
   " strange-looking code when\nusing constructs that Fennel" ..
   " does not support natively, like early returns."

local done = function(fennel, antifennel)
   compile_fennel.onclick = function()
      local ok, code = pcall(fennel.compileString, fennel_source.value)
      if ok then
         lua_source.value = code
         status("Compiled Fennel to Lua.", true)
      else
         status(tostring(code), false)
      end
   end

   compile_lua.onclick = function()
      -- for Lua that doesn't parse, antifennel gives crummy error messages
      local ok, msg = load(lua_source.value)
      if not ok then return status("Lua: " .. msg, false) end

      local ok, code = pcall(antifennel, lua_source.value)
      if ok then
         fennel_source.value = code
         status(anti_msg, true)
      else
         status(tostring(code), false)
      end
   end

   out.innerHTML = "Loaded Fennel " .. fennel.version .. " in " .. _VERSION
end

fennel_source.onkeydown = function(_, e)
   if not e then e = js.global.event end
   if (e.key or e.which) == "Enter" and e.ctrlKey then
      compile_fennel.onclick()
      return false
   end
end

lua_source.onkeydown = function(_,e)
   if not e then e = js.global.event end
   if (e.key or e.which) == "Enter" and e.ctrlKey then
      compile_lua.onclick()
      return false
   end
end

local started = false

local init_worker = function()
   local worker = js.new(js.global.Worker, "/see-worker.js")
   local send = function(isFennel, code)
      -- we can't send tables to workers, so we have to encode everything in
      -- strings. use an initial space for Fennel and initial tab for Lua code.
      local prefix = isFennel and " " or "\t"
      worker:postMessage(prefix .. code)
   end

   worker.onmessage = function(_, e)
      out.innerHTML = e.data -- loaded message
      -- don't set up handlers until we've loaded
      compile_fennel.onclick = function() send(true, fennel_source.value) end
      compile_lua.onclick = function() send(false, lua_source.value) end

      worker.onmessage = function(_, event)
         -- because we can't send tables as events, we encode the type of the
         -- message in the last character of the string.
         if event.data:match(" $") then
            lua_source.value = event.data
            status("Compiled Fennel to Lua.", true)
         elseif event.data:match("\t$") then
            fennel_source.value = event.data
            status(anti_msg, true)
         else
            status(event.data, false)
         end
      end
   end

   worker.onerror = function(_, event) status(event.data, false) end
end

local load_direct = function()
   local antifennel = dofile("antifennel.lua")
   return done(require("fennel"), antifennel)
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

-- TODO: multiple Fennel versions?
-- TODO: samples
