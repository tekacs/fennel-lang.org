-- We tricked the Fennel repl into running inside a browser using Fengari and
-- init.lua+repl.fnl. Now we must trick our trick into running back inside
-- a normal shell, because debugging in the browser is kinda miserable.

local noop = function() return {} end

local createElement = function()
   return {
      style={},
      appendChild=table.insert,
      getAttribute=noop,
      setAttribute=noop,
      dispatchEvent=noop,
   }
end

local p = print
local open = io.open
local console = createElement()

-- print gets replaced with some DOM stuff, so make fake DOM stuff that actually
-- prints instead of inserting child elements:
function console.appendChild(_, line)
   p(table.concat(line, " "))
end

-- io.open gets replaced with XHR stuff, so create a fake XHR that knows how
-- to secretly io.open:
local open = function(x, _, filename)
   local f = assert(open(filename))
   x.response = f:read("*all")
   f:close()
end

package.loaded.js = {
   new = function(x) return x end,
   global = {
      XMLHttpRequest = {open=open, send=noop, status=200, statusText=""},
      document = {
         createTextNode=function(_, x) return x end,
         getElementById=function(_, id)
            return id == "fengari-console" and console or createElement()
         end,
         createElement=createElement,
         createEvent=function() return {initEvent=noop} end,
      },
   }
}

local coro = require("init")

coroutine.resume(coro, "(print :abc)")
coroutine.resume(coro, "(var x 1)")
coroutine.resume(coro, "(set x 2)")
coroutine.resume(coro, "(print x :better-equal 2)")
