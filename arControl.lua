SCREEN_X = 1600
SCREEN_Y = 900
COLORDRAW = 0x00ffff
center_X = SCREEN_X/4
center_Y = SCREEN_Y/4

local reds = peripheral.wrap("right")
ar = peripheral.wrap("left")
rednet.open("back")

if ar == nil then error("AR Controller not Found") end
if reds == nil then error("Redstone Integrator not Found") end

local verticalLineX = 670
local verticalLineMinY = 310
local verticalLineMaxY = 430


function hub()
    ar.verticalLine(verticalLineX, verticalLineMinY, verticalLineMaxY, COLORDRAW)
    ar.horizontalLine(verticalLineX, 700, verticalLineMinY, COLORDRAW)
    ar.drawString('UPDATES', 705, 305, COLORDRAW)
    ar.horizontalLine(750, 785, verticalLineMinY, COLORDRAW)

    ar.verticalLine(305, 15, 5, COLORDRAW)
    ar.verticalLine(510, 15, 5, COLORDRAW)
    ar.horizontalLine(305, 385, 15, COLORDRAW)
    ar.horizontalLine(420, 510, 15, COLORDRAW)
    ar.drawString('INFOS', 390, 15, COLORDRAW)
end

function drawLoadCircle()
    ar.horizontalLine(center_X-30, center_X+30, center_Y-120, COLORDRAW)
    sleep(0,8)
    ar.verticalLine(center_X+30, center_Y-120, center_Y-60, COLORDRAW)
    sleep(0,8)
    ar.horizontalLine(center_X+30, center_X-30, center_Y-60, COLORDRAW)
    sleep(0,8)
    ar.verticalLine(center_X-30, center_Y-60, center_Y-120, COLORDRAW)
    sleep(0,8)
end

function startingSystem()
    local startTable = {"Iniciando Sistema ", ".", ".", "."}
    local xStarting = 365
    for i=1,#startTable do
        ar.drawString( startTable[i], xStarting, 80, COLORDRAW )
        xStarting = xStarting + 75
        if xStarting > 440 then
            xStarting = xStarting-70
            sleep(1)
        end
    end
    --ar.drawItemIcon('minecraft:clock', center_X, center_Y)
    sleep(1)
    ar.clear()
end

function configSystem()
    local configTable = {"Configurando ", ".", ".", "."}
    local xConfig = 370
    for i=1,#configTable do
        ar.drawString( configTable[i], xConfig, 80, COLORDRAW )
        xConfig = xConfig + 60
        if xConfig > 440 then
            xConfig = xConfig-55
            sleep(1)
        end
    end
    drawLoadCircle()
    --ar.drawItemIcon('minecraft:clock', center_X, center_Y)
end

local ids = 0
local reactor_stats
function receiveIntel()
    if fs.exists("/reactorStats") then
        local f = fs.open("/reactorStats", "r")
        local content = f.readAll()
        if ids <= 7 then
            local time = os.date('*t')
            if content == "Reator Ligado" then
                --if not reactor_stats then
                    reactor_stats = true
                    ar.drawStringWithId(tostring(ids), time.hour..":"..time.min..":"..time.sec.." | "..content, verticalLineX + 10, 430 - ids * 15, COLORDRAW )
                    ids = ids+1
                    print("Mensagem Recebida ".. content)
                --else
                --    print("Informação redundante")
                --end

            elseif content == "Reator Desligado" then
                --if reactor_stats then
                    reactor_stats = false
                    ar.drawStringWithId(tostring(ids), time.hour..":"..time.min..":"..time.sec.." | "..content, verticalLineX + 10, 430 - ids * 15, COLORDRAW )
                    ids = ids+1
                    print("Mensagem Recebida ".. content)
                --else
                --    print("Informação redundante")
                --end
            elseif content == "R. Ligado <90% " then
                --if not reactor_stats then
                    reactor_stats = true
                    ar.drawStringWithId(tostring(ids), time.hour..":"..time.min..":"..time.sec.." | "..content, verticalLineX + 10, 430 - ids * 15, COLORDRAW )
                    ids = ids+1
                    print("Mensagem Recebida ".. content)
                --else
                --    print("Informação redundante")
                --end
            end
            f.close()
            fs.delete("/reactorStats")
            print("Apagando arquivo utilizado")
        else
            for i=1, ids do
                ar.clearElement(tostring(i))
                ids = 1
            end

        end
    else
        error("Arquivo não encontrado")
    end
end


ar.setRelativeMode(true, SCREEN_X, SCREEN_Y)
ar.clear()
startingSystem()
configSystem()
hub()
sleep(2)
ar.clear()
hub()
while true do
    local timer = os.startTimer(5)
    local event, id
    repeat
        event, id = os.pullEvent("timer")
    until id == timer
    local time = os.date('*t')
    textutils.slowPrint(time.hour..":"..time.min.." | ".."Iniciando Loop")
    hub()
    shell.run("update")
    receiveIntel()
end
