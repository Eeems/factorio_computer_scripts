os.require('/lib/events.lua')
events = EventManager()
function ServerEvent(name, from_label, args)
    local _ServerEvent = Event(name, args)
    _ServerEvent.from = from_label
    function _ServerEvent:reply(event, ...)
        if wlan ~= nil then
            wlan.emit(_ServerEvent.from, 'event', ServerEvent(event, os.getComputerLabel(), {...}))
        end
    end
end
local server = {}
function server.on(event, fn)
    events:on(event, fn)
end
function server.un(event, fn)
    events:un(event, fn)
end
function server.start()
    if wlan ~= nil then
        wlan.on('event', function(event, e)
            events:emit(event, e)
        end)
    end
end
function server.emit(to, event, ...)
    if wlan ~= nil then
        wlan.emit(to, 'event', ServerEvent(event, os.getComputerLabel(), {...}))
    end
end
function server.broadcast(event, ...)
    if wlan ~= nil then
        wlan.broadcast('event', ServerEvent(event, os.getComputerLabel(), {...}))
    end
end
return server
