fuzzel = os.require('/lib/fuzzel.lua')
registration = {}
screenText = ""
local client = {}
function client.command(cmd, fn, autoCompleteFn, help)
    registration[cmd] = {
        cmd=cmd,
        fn=fn,
        autoCompleteFn=autoCompleteFn,
        help=help
    }
end
function client.autoComplete(args, opt)
    strargs = table.concat(args, " ")
    --Remove spaces and quotes, since we don't want to match them
    strargs = string.gsub(strargs,"[\" ]","")
    --Find the options that most closely resemble our command so far
    local results = fuzzel.FuzzyAutocompleteDistance(strargs, opt)
    local values = {}
    for k, v in pairs(results) do
        if v:sub(0, #strargs) == strargs then
            table.insert(values, v)
        end
    end
    if #values == 1 then
        input = getCmd(input).." "..values[1]
    elseif #values > 0 then
        client.write("  "..table.concat(values, ", "))
    end
end
function client.resetDisplay()
    -- Remove trailing newline
    screenText = string.sub(screenText, 0, -2)
    term.clear()
    term.setOutput(screenText)
    term.setInput(input)
end
function client.start(name)
    inputEnable = true
    input = "> "
    screenText = "Welcome to "..name.." "
    function getUserInput(input)
        return string.sub(input, 3, -2)
    end
    function splitInput(input)
        local res = {}
        for word in input:gmatch("%w+") do
            table.insert(res, word)
        end
        return res
    end
    function getCmd(input)
        return table.remove(splitInput(input), 1)
    end
    function getArgs(input)
        local args = splitInput(input)
        table.remove(args, 1)
        return args
    end
    function getArgsAndCmd(input)
        local args = splitInput(input)
        local cmd = table.remove(args, 1)
        if cmd == nil then
            cmd = ""
        end
        return {cmd, args}
    end
    term.addInputListener(function(event)
        if not inputEnable then
            return term.setInput(input)
        end
        input = event.userInput
        if #input < 2 then
            input = "> "
            term.setInput(input)
        end
        if #term.getOutput() < #screenText then
            inputEnable = false
            client.resetDisplay()
            inputEnable = true
            return
        end
        client.saveScreen()
        character = input:sub(#input)
        if character == "\n" then
            -- Remove the newline from the input
            input = getUserInput(input)
            term.write("> "..input)
            local info = getArgsAndCmd(input)
            if registration[info[1]] ~= nil then
                local reg = registration[info[1]]
                local success, err = os.pcall(reg["fn"], info[2])
                if success == false then
                    term.write('Error: '..err)
                end
            else
                if #info[1] > 0 then
                    term.write("Error: Unknown command '"..info[1].."'")
                end
            end
            client.saveScreen()
            -- Reset the input
            input = "> "
            client.resetDisplay()
        elseif character == "`" then
            -- Autocomplete input
            inputEnable = false
            input = getUserInput(input)
            local info = getArgsAndCmd(input)
            if registration[info[1]] == nil then
                local function keys(tab)
                    local keyset = {}
                    local n = 0
                    for k,v in pairs(tab) do
                        n=n+1
                        keyset[n]=k
                    end
                    return keyset
                end
                local results = fuzzel.FuzzyAutocompleteDistance(info[1], keys(registration))
                local values = {}
                for k, v in pairs(results) do
                    if v:sub(0, #info[1]) == info[1] then
                        table.insert(values, v)
                    end
                end
                if #values == 1 then
                    input = values[1].." "
                elseif #values > 0 then
                    client.write("  "..table.concat(values, ", "))
                end
            elseif registration[info[1]] ~= nil then
                local reg = registration[info[1]]
                local success, err = os.pcall(reg["autoCompleteFn"], info[2])
                if success == false then
                    term.write('Error: '..err)
                end
            end
            client.saveScreen()
            input = "> "..input
            client.resetDisplay()
            inputEnable = true
        end
    end)
    wlan.on('event', function(from_label, event, ...)
        if event == "term.write" then
            for k, v in pairs({...}) do
                client.write('['..from_label..'] '..v)
            end
        end
    end)
    term.clear()
    os.wait(client.resetDisplay, 0.1)
end
function client.write(text)
    term.write(text)
    client.saveScreen()
end
function client.emit(to, event, ...)
    if wlan ~= nil then
        wlan.emit(to, 'event', event, ...)
    end
end
function client.broadcast(event, ...)
    if wlan ~= nil then
        wlan.broadcast('event', event, ...)
    end
end
function client.saveScreen()
    screenText = term.getOutput()
end
function client.clearScreen()
    term.clear()
    client.saveScreen()
end
client.command("help", function(args)
    for k,v in pairs(registration) do
        term.write(k..": "..v["help"])
    end
end, function(args)
    input = "help"
end, "display this help message")
return client
