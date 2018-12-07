term.write("Install finished.")
if lan == nil then
    term.write('Detected wrist client...')
    os.require('/wrist/client.lua')
else
    local label = os.getComputerLabel()
    if label:sub(0, 4) == "mine" then
        term.write('Detected mine server...')
        os.require('/mine/server.lua')
    elseif label:sub(0, 7) == "factory" then
        term.write('Detected factory server...')
        os.require('/factory/server.lua')
    else
        term.write('Unknown computer...')
    end
end
