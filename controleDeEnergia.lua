local integrator = peripheral.find("redstoneIntegrator")
if integrator == nil then error("redstoneIntegrator not Found") end

--integrator.getAnalogInput("back")
rednet.open("right")
local reactor_stats

function sendIntel()
    if fs.exists("/reactorStats") then
        fs.delete("/reactorStats")

        --if reactor_stats == 1 and integrator.getAnalogInput("left") < 5 then
        --    local f = fs.open("/reactorStats", "w")
        --    f.write("R. Ligado <90% ")
        --    f.close()
        --    textutils.slowPrint("Arquivo Salvo")
        --    shell.run("sendMessage", "2", "/reactorStats")
            --integrator.setAnalogOutput("bottom", 15)
            --sleep(1)
            --integrator.setAnalogOutput("bottom", 0)
            --integrator.setAnalogOutput("front", 0)
            --sleep(1)
            --integrator.setAnalogOutput("front", 15)

        if reactor_stats == 1 then
            local f = fs.open("/reactorStats", "w")
            f.write("Reator Ligado")
            f.close()
            textutils.slowPrint("Arquivo Salvo")
            shell.run("sendMessage", "2", "/reactorStats")

        elseif reactor_stats == 0 then
            local f = fs.open("/reactorStats", "w")
            f.write("Reator Desligado")
            f.close()
            textutils.slowPrint("Arquivo Salvo")
            shell.run("sendMessage", "2", "/reactorStats")
        end

    end
end

function checkEnergy()
    if integrator.getAnalogInput("back") < 14 then
        integrator.setAnalogOutput("front", 15)
        textutils.slowPrint("Reator Ligado")
        sleep(15)
        reactor_stats = 1
    else
        integrator.setAnalogOutput("front", 0)
        textutils.slowPrint("Reator Desligado")
        sleep(5)
        reactor_stats = 0
    end
end

--while true do
    checkEnergy()
    sendIntel()
    --sleep(25)
    os.reboot()
--end
