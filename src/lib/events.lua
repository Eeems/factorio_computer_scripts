os.require('/lib/class.lua')
EventManager = class(function(me)
    me._handles = {}
end)
Event = class(function(me, name, args)
    me.name = name
    me.args = args
end)

function EventManager:on(event, fn)
    if me._handles[event] == nil then
        me._handles[event] = {}
    end
    table.insert(me._handles[event], fn)
end
function EventManager:un(event, fn)
    if me._handles[event] ~= nil then
        for k, v in pairs(me._handles[event]) do
            if v == fn then
                table.remove(me._handles[event], k)
            end
        end
    end
end
function EventManager:emit(event, ...)
    local args = {...}
    if me._handles[event] ~= nil then
        for k, fn in pairs(me._handles[event]) do
            local success, err = os.pcall(fn, Event(event, args))
            if success == false then
                if event == "error" then
                    term.write('Error: '..err)
                else
                    self:emit('error', err)
                end
            end
        end
    end
end
