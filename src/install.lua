term.write("Install finished.")
local label = os.getComputerLabel()
if car ~= nil then
    term.write('Detected car server...')
    os.require('/car/server.lua')
elseif lan == nil then
    term.write('Detected wrist client...')
    os.require('/wrist/client.lua')
elseif label:sub(0, 4) == "mine" then
    term.write('Detected mine server...')
    os.require('/mine/server.lua')
elseif label:sub(0, 7) == "factory" then
    term.write('Detected factory server...')
    os.require('/factory/server.lua')
else
    term.write('Unknown computer type...')
end
