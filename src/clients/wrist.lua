client = os.require('/lib/client.lua')
client.command("status", function(args)
    if #args > 0 then
        local cmd = args[1]
        if cmd == "battery" then
            -- TODO: handle battery status
            term.write('Battery status: Unknown')
        elseif cmd == "logistics" then
            -- TODO: handle logisitics status
            term.write('Logistics network status: Unknown')
        else
            term.write("Error: Unknown subcommand '"..cmd.."'")
        end
    else
        term.write("Error: Missing subcommand")
    end
end, function(args) client.autoComplete(args, {"battery", "logistics"}) end, "Get the status of things")
client.start("wrist client 1.0")
