-- mostly based on repl.lua from Fengari itself:
-- https://github.com/fengari-lua/fengari.io/blob/master/static/lua/web-cli.lua
local js = require "js"
package.path = "./?.lua"
_G.fennel = require "fennel"

local eval = _G.fennel.eval
local welcome = "Welcome to Fennel, running on Fengari 0.1.1 (Lua 5.3.4)"

-- the hacks below are needed specifically to get the Fennel test suite to pass

-- just make a few things not blow up
_G.os.exit = function() end
_G.os.getenv = function() end

-- require-macros depends on io.open; we splice in a hacky replacement
io={open=function(filename)
       return {
          read = function(_, all)
             assert(all=="*all", "Can only read *all.")
             local xhr = js.new(js.global.XMLHttpRequest)
             xhr:open("GET", filename, false)
             xhr:send()
             assert(xhr.status == 200, xhr.status .. ": " .. xhr.statusText)
             return tostring(xhr.response)
          end,
          close = function() end,
       }
end}

package.preload.fennelview = assert(loadfile("fennelview.lua"))
package.preload.generate = assert(loadfile("generate.lua"))

local fennelview = require "fennelview"

-- Save references to lua baselib functions used
local _G = _G
local pack, unpack = table.pack, table.unpack
local tostring = tostring
local traceback = debug.traceback
local xpcall = xpcall

local document = js.global.document
-- local hljs = js.global.hljs

local output = document:getElementById("fengari-console")
local prompt = document:getElementById("fengari-prompt")
local input = document:getElementById("fengari-input")
assert(output and prompt and input)

local function triggerEvent(el, type)
    local e = document:createEvent("HTMLEvents")
    e:initEvent(type, false, true)
    el:dispatchEvent(e)
end

local history = {}
local historyIndex = nil
local historyLimit = 100

_G.print = function(...)
    local toprint = pack(...)

    local line = document:createElement("pre")
    line.style["white-space"] = "pre-wrap"
    output:appendChild(line)

    for i = 1, toprint.n do
        if i ~= 1 then
            line:appendChild(document:createTextNode("\t"))
        end
        line:appendChild(document:createTextNode(tostring(toprint[i])))
    end

    output.scrollTop = output.scrollHeight
end

local function doREPL()
    do
        local line = document:createElement("span")
        line:appendChild(document:createTextNode(prompt.textContent))
        local item = document:createElement("pre")
        item.className = "lua"
        item.style.padding = "0"
        item.style.display = "inline"
        item.style["white-space"] = "pre-wrap"
        item.textContent = input.value
        -- hljs:highlightBlock(item)
        line:appendChild(item)
        output:appendChild(line)
        output:appendChild(document:createElement("br"))
        output.scrollTop = output.scrollHeight
    end

    if input.value.length == 0 then
        return
    end

    local line = input.value
    if history[#history] ~= line then
        table.insert(history, line)
        if #history > historyLimit then
            table.remove(history, 1)
        end
    end

    local results = {xpcall(function() return eval(line) end, traceback)}
    if results[1] then
        if #results > 1 then
            for i=2,#results do results[i] = fennelview(results[i]) end
            _G.print(unpack(results, 2, #results))
        end
    else
        _G.print(results[2])
    end

    input.value = ""

    triggerEvent(output, "change")
end

function input:onkeydown(e)
    if not e then
        e = js.global.event
    end

    local key = e.key or e.which
    if key == "Enter" and not e.shiftKey then
        historyIndex = nil
        doREPL()
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

_G.print(welcome)
