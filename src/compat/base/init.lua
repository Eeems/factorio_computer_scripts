if error == nil then
    function error(msg)
        assert(false, msg)
    end
end
