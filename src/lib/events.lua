function Event(name, args)
    local _Event = {}
    _Event.name = name
    _Event.args = args
    return _Event
end
function EventManager()
    local _EventManager = {}
    _EventManager._handles = {}
    function _EventManager:on(event, fn)
        if _EventManager._handles[event] == nil then
            _EventManager._handles[event] = {}
        end
        table.insert(_EventManager._handles[event], fn)
    end
    function _EventManager:un(me, event, fn)
        if _EventManager._handles[event] ~= nil then
            for k, v in pairs(_EventManager._handles[event]) do
                if v == fn then
                    table.remove(_EventManager._handles[event], k)
                end
            end
        end
    end
    function _EventManager:emit(me, event, ...)
        local args = {...}
        if _EventManager._handles[event] ~= nil then
            for k, fn in pairs(_EventManager._handles[event]) do
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
    return _EventManager
end
