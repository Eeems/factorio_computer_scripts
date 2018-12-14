local server = os.require('/lib/server.lua')
server.start()
local client = os.require('/lib/client.lua')
client.start("mine client 1.0")
