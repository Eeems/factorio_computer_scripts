os.require('/lib/events.lua')
events = EventManager()
ServerEvent = class(Event, function(me, name, from_label, to_label, args)
    me.name = name
    me.from = from_label
    me.to = to_label
    me.args = args
end)
function ServerEvent:emit(to, event, ...)
    if wlan ~= nil then
        wlan.emit(to, 'event', event, ...)
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
        wlan.on('event', function(from_label, event, ...)
            events.emit(event, ServerEvent(event, from_label, os.getComputerLabel(), {...}))
        end)
    end
end
function server.broadcast(event, ...)
    if wlan ~= nil then
        wlan.broadcast('event', event, ...)
    end
end
return server
