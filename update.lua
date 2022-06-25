-- CONTINUOUSLY RECIEVE REDNET MESSAGES
--while true do
--    signal = {rednet.receive()}
--    if signal[2].action == 'shutdown' then
--        os.shutdown()
--    elseif signal[2].action == 'reboot' then
--        os.reboot()
--    elseif signal[2].action == 'update' then
--        os.run({}, '/update')
--    else
--        table.insert(state.requests, signal)
--    end
--end


local id, msg = rednet.receive()
if msg == "RECEIVE" then
    local idI, msgI = rednet.receive()
    print("Abrindo arquivo: ", msgI)
    local f = fs.open(msgI, "w")
    idII, msgII = rednet.receive()
    f.write(msgII)
    f.close()
end

