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

-- Ctrl-enter to compile
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

local anti_msg = "Compiled Lua to Fennel.\n\n"..
   "Note that compiling Lua to Fennel can result in some" ..
   " strange-looking code when\nusing constructs that Fennel" ..
   " does not support natively, like early returns."

local init_worker = function()
   -- TODO: multiple Fennel versions?
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
end

local load_direct = function()
   local antifennel = dofile("antifennel.lua")
   local fennel = require("fennel")
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

local started = false

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

--- Sample snippets

local fennel_samples = {["pong movement"]=
      ";; Read the keyboard, move player accordingly\
(local dirs {:up [0 -1] :down [0 1]\
            :left [-1 0] :right [1 0]})\
\
(each [key delta (pairs dirs)]\
  (when (love.keyboard.isDown key)\
    (let [[dx dy] delta\
          [px py] player\
          x (+ px (* dx player.speed dt))\
          y (+ py (* dy player.speed dt))]\
      (world:move player x y))))",
   fibonacci="(fn fibonacci [n]\
 (if (< n 2)\
  n\
  (+ (fibonacci (- n 1)) (fibonacci (- n 2)))))\
\
(print (fibonacci 10))",
   walk="(fn walk-tree [root f custom-iterator]\
  (fn walk [iterfn parent idx node]\
    (when (f idx node parent)\
      (each [k v (iterfn node)]\
        (walk iterfn node k v))))\
  (walk (or custom-iterator pairs) nil nil root)\
  root)"}

local lua_samples = {["sample select"]=
   "local sample_lua = document:getElementById(\"samples\")\
local lua_samples = {}\
\
for name, sample in pairs(lua_samples) do\
   local option = document:createElement(\"option\")\
   option.innerHTML = name\
   sample_lua:appendChild(option)\
end\
\
function sample_lua.onchange(self, e)\
   init()\
   local code = lua_samples[self.value]\
   if code then lua_source.value = code end\
end",
   antifennel=
   "local function uncamelize(name)\
   local function splicedash(pre, cap)\
     return pre .. \"-\" .. cap:lower()\
   end\
   return name:gsub(\"([a-z0-9])([A-Z])\", splicedash)\
end\
\
local function mangle(name, field)\
   if not field and reservedFennel[name] then\
     name = \"___\" .. name .. \"___\"\
   end\
   return field and name or\
      uncamelize(name):gsub(\"([a-z0-9])_\", \"%1-\")\
end\
\
local function compile(rdr, filename)\
   local ls = lex_setup(rdr, filename)\
   local ast_builder = lua_ast.New(mangle)\
   local ast_tree = parse(ast_builder, ls)\
   return letter(compiler(nil, ast_tree))\
end",
   ["love.run"]="function love.run()\
   love.load()\
   while true do\
      love.event.pump()\
      local needs_refresh = false\
      for name, a,b,c,d,e,f in love.event.poll() do\
         if(type(love[name]) == \"function\") then\
            love[name](a,b,c,d,e,f)\
            needs_refresh = true\
         elseif(name == \"quit\") then\
            os.exit()\
         end\
      end\
      for _,c in pairs(internal.coroutines) do\
         local ok, val = coroutine.resume(c)\
         if(ok and val) then needs_refresh = true\
         elseif(not ok) then print(val) end\
      end\
      for i,c in lume.ripairs(internal.coroutines) do\
         if(coroutine.status(c) == \"dead\") then\
            table.remove(internal.coroutines, i)\
         end\
      end\
      if(needs_refresh) then refresh() end\
      love.timer.sleep(0.05)\
   end\
end"}

local init_samples = function(id, samples, target)
   local select = document:getElementById(id)
   for name, sample in pairs(samples) do
      local option = document:createElement("option")
      option.innerHTML = name
      select:appendChild(option)
   end

   select.onchange = function(self, e)
      init()
      local code = samples[self.value]
      if code then target.value = code end
   end
end

init_samples("sample-fennel", fennel_samples, fennel_source)
init_samples("sample-lua", lua_samples, lua_source)
