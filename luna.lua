--------------------------------------------------
-- Episode code for every level
-- Created 16:57 2023-12-22
--------------------------------------------------

canFlyAddress = 0x16C
flightTimeAddress = 0x170

-- Run code on the first frame
function onStart()
    --Your code here
    Text.showMessageBox("Level Start")
    initPlayers()
end

-- Run code every frame (~1/65 second)
-- (code will be executed before game logic will be processed)
function onTick()
    --Your code here
    player:mem(canFlyAddress, FIELD_BOOL, true)
    player:mem(flightTimeAddress, FIELD_WORD, 0xFF)
    if Player.count() == 2 then
        player2:mem(canFlyAddress, FIELD_BOOL, true)
        player2:mem(flightTimeAddress, FIELD_WORD, 0xFF)
    end
end

--function onNPCHarm(eventName, killedNPC, harmType, culprit)
--    Text.showMessageBox(string.format("CULPRIT %d", culprit.character))
--end

-- Run code when internal event of the SMBX Engine has been triggered
-- eventName - name of triggered event
function onEvent(eventName)
    --Your code here
end

function initPlayers()
    if Player.count() < 2 then 
        return
    end
--    enable players to fly via blue kuribo shoe
--    player.mount = MOUNT_BOOT
--    player2.mount = MOUNT_BOOT
--    player.mountColor = 3
--    player2.mountColor = 3
end


