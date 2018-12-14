term.write("Install finished.")
local json = os.require('/lib/json.lua')
os.require('/compat/base/init.lua')
local label = os.getComputerLabel()
if car ~= nil then
    term.write('Detected car server...')
    os.require('/servers/car.lua')
elseif lan == nil then
    term.write('Detected wrist client...')
    os.require('/clients/wrist.lua')
elseif label:sub(0, 4) == "mine" then
    term.write('Detected mine server...')
    os.require('/servers/mine.lua')
elseif label:sub(0, 7) == "factory" then
    term.write('Detected factory server...')
    os.require('/servers/factory.lua')
else
    term.write('Unknown computer type...')
end
