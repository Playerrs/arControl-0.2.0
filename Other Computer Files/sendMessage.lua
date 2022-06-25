local args = {...}

rednet.open("right")

if #args < 1 then
    print("Sem informações para enviar")
    return
end

if #args == 1 then
    if fs.exists(args[1]) then
        textutils.slowPrint("Enviando arquivo "..args[1].."!")
        rednet.broadcast("RECEIVE")
        rednet.broadcast(args[1])
        file = fs.open(args[1], "r")
        rednet.broadcast(file.readAll())
        file.close()
    else
        print(args[1].." não existe")
        return
    end
else
    if fs.exists(args[2]) then
        textutils.slowPrint("Enviando arquivo "..args[2].." para "..args[1])
        F = fs.open(args[2], "r")
        id = tonumber(args[1])
        rednet.send(id, "RECEIVE")
        rednet.send(id, args[2])
        rednet.send(id, F.readAll())
        F.close()
    else
        print(args[2].." não existe!")
        return
    end

end