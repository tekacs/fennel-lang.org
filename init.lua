-- mostly based on repl.lua from Fengari itself:
-- https://github.com/fengari-lua/fengari.io/blob/master/static/lua/web-cli.lua
package.path = "./?.lua"
local js = require "js"

local welcome = nil

-- the hacks below are needed specifically to get the Fennel test suite to pass

-- just make a few things not blow up
_G.os.exit = function() end
_G.os.getenv = function() return nil end

package.preload.fennelview = assert(loadfile("fennelview.lua"))

-- Save references to lua baselib functions used
local _G = _G
local pack = table.pack
local tostring = tostring

local document = js.global.document
local output = document:getElementById("fengari-console")
local prompt = document:getElementById("fengari-prompt")
local input = document:getElementById("fengari-input")
local luacode = document:getElementById("compiled-lua")
local luapane = document:getElementById("lua-pane")
local togglebtn = document:getElementById("toggle-compiled-code")
assert(output and prompt and input and luacode and luapane and togglebtn)

local function triggerEvent(el, type)
    local e = document:createEvent("HTMLEvents")
    e:initEvent(type, false, true)
    el:dispatchEvent(e)
end

local history = {}
local historyIndex = nil
local historyLimit = 100

local function highlightLines(target, elements)
   for i = 0, #elements-1 do
      if tonumber(elements[i]:getAttribute("history")) == target then
	 elements[i].style.backgroundColor = (elements[i].style.backgroundColor == "") and "pink" or ""
      else
	 elements[i].style.backgroundColor = ""
      end
   end
end

local function makeLine(...)
    local toprint = pack(...)

    local line = document:createElement("pre")
    line.style["white-space"] = "pre-wrap"

    line:setAttribute("history", #history)

    line.onclick = function()
       local n = tonumber(line:getAttribute("history"))

       highlightLines(n, output.children)
       highlightLines(n, luacode.children)
    end

    for i = 1, toprint.n do
        if i ~= 1 then
            line:appendChild(document:createTextNode("\t"))
        end
        line:appendChild(document:createTextNode(tostring(toprint[i])))
    end

    return line
end

_G.printLuacode = function(...)
   local line = makeLine(...)

   luacode:appendChild(line)
   luacode.scrollTop = luacode.scrollHeight
   triggerEvent(luacode, "change")
end

_G.print = function(...)
   local line = makeLine(...)

   output:appendChild(line)
   output.scrollTop = output.scrollHeight
   triggerEvent(output, "change")
end

_G.narrate = function(...)
    local line = makeLine(...)
    line.style.color = "blue"

    output:appendChild(line)

    output.scrollTop = output.scrollHeight
    triggerEvent(output, "change")
end

_G.printError = function(...)
   local line = makeLine(...)
   line.style.color = "red"

   output:appendChild(line)

   output.scrollTop = output.scrollHeight
   triggerEvent(output, "change")
end

local replWorker = { webWorkerNotStarted = true }
local replWorkerLoaded = false
local replStack = {}

function replWorker.loadReplWithoutWebWorker()
    local fennel = require("fennel/fennel")
    package.loaded.fennel = fennel
    return coroutine.create(fennel.dofile("repl.fnl"))
end

-- loading Fennel at the top level breaks scrolling because browsers
-- are terrible; so we load when the input element gets focus

function initReplWorker()
    if input == nil then
      js.global.console:log('input not exists...')
      -- not running in a real web browser
      return
    end

    input:setAttribute("disabled", "disabled")
    input:setAttribute("placeholder", "0%")

    _G.print("Loading...")

    local percentage = 0

    local loader = js.global:setInterval(function()
      if not replWorkerLoaded and percentage < 99 then
        percentage = percentage + 1
        input:setAttribute("placeholder", percentage .. "%")
      else
        js.global:clearInterval(loader);
      end
    end, (10 * (1000)) / 100) -- Maximum expected time on a slow computer: 10s

    replWorker = js.new(js.global.Worker, '/repl-worker.js')

    replWorker.onmessage = function(_, message)
        local content = message.data

        local pipePosition = content:find('|')
        local functionName = content:sub(1, pipePosition-1)

        content = content:sub(pipePosition+1, #content)

        pipePosition = content:find('|')

        local command = content:sub(1, pipePosition-1)

        content = content:sub(pipePosition+1, #content)

        if command == 'append' then
            if replStack[functionName] == nil then
                replStack[functionName] = {}
            end

          table.insert(replStack[functionName], content)
        elseif command == 'dispatch' then
            _G[functionName](table.unpack(replStack[functionName]))

            replStack[functionName] = {}
        elseif command == 'loaded' then
          js.global:clearInterval(loader);
          replWorkerLoaded = true
          input:removeAttribute("disabled")
          input:setAttribute("placeholder", "Type code here...")
          input:focus()
        end
    end
end

function input.onfocus()
    if replWorker.webWorkerNotStarted then
        replWorker.webWorkerNotStarted = false
        initReplWorker()
    end
end

togglebtn.onclick = function()
    if luapane.style.display == 'flex' then
        luapane.style.display = 'none'
    else
        luapane.style.display = 'flex'
    end
end

function input.onkeydown(_, e)
    if not e then
        e = js.global.event
    end

    local key = e.key or e.which
    if key == "Enter" and not e.shiftKey then
        historyIndex = nil
        if #input.value > 0 then
           if history[#history] ~= input.value then
              table.insert(history, input.value)
              if #history > historyLimit then
                 table.remove(history, 1)
              end
           end

           replWorker:postMessage(input.value)

           input.value = ""
        end
        return false
    elseif key == "ArrowUp" or key == "Up" then
        if historyIndex then
            if historyIndex > 1 then
                historyIndex = historyIndex - 1
            end
        else -- start with more recent history item
            local hist_len = #history
            if hist_len > 0 then
                historyIndex = hist_len
            end
        end
        input.value = history[historyIndex]
        return false
    elseif key == "ArrowDown" or key == "Down" then
        local newvalue = ""
        if historyIndex then
            if historyIndex < #history then
                historyIndex = historyIndex + 1
                newvalue = history[historyIndex]
            else -- no longer in history
                historyIndex = nil
            end
        end
        input.value = newvalue
        return false
    elseif key == "l"
        and e.ctrlKey
        and not e.shiftKey
        and not e.altKey
        and not e.metaKey
        and not e.isComposing then
        -- Ctrl+L clears screen like you would expect in a terminal
        output.innerHTML = ""
        _G.print(welcome)
        return false
    end
end

return replWorker
