local server = {}
server.listeners = {}
function server.on(event, fn)
    if server.listeners[event] == nil then
        server.listeners[event] = {}
    end
    table.insert(server.listeners[event], fn)
end
function server.un(event, fn)
    if server.listeners[event] ~= nil then
        for k, v in pairs(server.listeners[event]) do
            if v == fn then
                table.remove(server.listeners[event], k)
            end
        end
    end
end
function server.start()
    if wlan ~= nil then
        wlan.on('event', function(from_label, event,...args)
            if server.listeners[event] ~= nil then
                for k, fn in pairs(server.listeners[event]) do
                    local success, err = os.pcall(fn, {
                        "name": event,
                        "from": from_label,
                        "to": os.getComputerLabel()
                    }, args)
                    if success == false then
                        if event == 'error' then
                            term.write('Error: '..err)
                        else
                            wlan.emit(os.getComputerLabel(), 'event', os.getComputerLabel(), 'error', err)
                        end
                    end
                end
            end
        end)
    end
end
return server
