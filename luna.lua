--------------------------------------------------
-- Episode code for every level
-- Created 16:57 2023-12-22
--------------------------------------------------

canFlyAddress = 0x16C
flightTimeAddress = 0x170
playerSpawnPositions = {{x = 1, y = 1}, {x = 2, y = 2}}

-- Run code on the first frame (first point when entities like players have been loaded)
function onStart()
    --Your code here
    Timer.hurryTime = 0
    initPlayers()
    Text.showMessageBox(string.format("Level Start %d %d", playerSpawnPositions[1].x, playerSpawnPositions[1].y))
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
    playerSpawnPositions[1].x = player.x
    playerSpawnPositions[1].y = player.y
    if Player.count() < 2 then 
        return
    end
    playerSpawnPositions[2].x = player2.x
    playerSpawnPositions[2].y = player2.y
--    enable players to fly via blue kuribo shoe
--    player.mount = MOUNT_BOOT
--    player2.mount = MOUNT_BOOT
--    player.mountColor = 3
--    player2.mountColor = 3
end

--function onPostPlayerKill(harmedPlayer)
    -- revive player
    --eventToken.cancelled = true
    --pIndx = harmedPlayer.idx
    --harmedPlayer.dropItemKeyPressing = true
    --harmedPlayer:teleport(playerSpawnPositions[pIndx].x, playerSpawnPositions[pIndx].y, false)
--end

function revivePlayer(p)
    
end

function Timer.onEnd()
    Text.showMessageBox("Game Over!")
    Level.load(nil, nil, nil)
end
