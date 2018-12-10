os.require('events.lua')
events = EventManager()
local server = {}
function server.on(event, fn)
    events:on(event, fn)
end
function server.un(event, fn)
    events:un(event, fn)
end
function server.start()
    if wlan ~= nil then
        wlan.on('event', function(from_label, event,...args)
            events.emit(event, {
                "name": event,
                "from": from_label,
                "to": os.getComputerLabel(),
                "args": args
            })
        end)
    end
end
return server
