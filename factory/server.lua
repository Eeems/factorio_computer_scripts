local server = os.require('/lib/server.lua')
server.start()
local client = os.require('/lib/client.lua')
client.start("factory client 1.0")
