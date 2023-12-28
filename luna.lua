--------------------------------------------------
-- Episode code for every level
-- Created 16:57 2023-12-22
--------------------------------------------------

canFlyAddress = 0x16C
flightTimeAddress = 0x170
isSpinJumpingAddress = 0x50
playerSpawnPositions = {{x = 1, y = 1}, {x = 2, y = 2}}
enemyID = 177
eggID = 186
respawnTime = 200

playerOneDead = false
playerTwoDead = false
playerOneRespawnTimer = 0
playerTwoRespawnTimer = 0

-- Run code on the first frame (first point when entities like players have been loaded)
function onStart()
    --Your code here
    Timer.hurryTime = 0
    initPlayers()
    spawnEnemy(-199304, -200380)
    Text.showMessageBox(string.format("Level Start %d %d", playerSpawnPositions[1].x, playerSpawnPositions[1].y))
end

-- Run code every frame (~1/65 second)
-- (code will be executed before game logic will be processed)
function onTick()
    --Your code here
    player:mem(canFlyAddress, FIELD_BOOL, true)
    player:mem(flightTimeAddress, FIELD_WORD, 0xFF)
    player:mem(isSpinJumpingAddress, FIELD_BOOL, true)
    
    if Player.count() == 2 then
        player2:mem(canFlyAddress, FIELD_BOOL, true)
        player2:mem(flightTimeAddress, FIELD_WORD, 0xFF)
        player2:mem(isSpinJumpingAddress, FIELD_BOOL, true)
    end
    
    if playerOneDead then 
        playerOneRespawnTimer = playerOneRespawnTimer - 1
        if playerOneRespawnTimer == 0 then
            playerOneDead = false
            player:teleport(playerSpawnPositions[1].x, playerSpawnPositions[1].y, false)
        end
    end

    if playerTwoDead then 
        playerTwoRespawnTimer = playerTwoRespawnTimer - 1
        if playerTwoRespawnTimer == 0 then
            playerTwoDead = false
            player2:teleport(playerSpawnPositions[2].x, playerSpawnPositions[2].y, false)
        end
    end
end

function onNPCHarm(eventName, harmedNPC, harmType, culprit)
    if harmedNPC.id == enemyID then
        Text.showMessageBox(string.format("CULPRIT %d", culprit.character))
        local egg = NPC.spawn(eggID, harmedNPC.x, harmedNPC.y, 0)
    end
end

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

function onPlayerKill(eventToken, harmedPlayer)
    eventToken.cancelled = true
    Text.showMessageBox(string.format("harmedPlayer %d", harmedPlayer.character))
    pIndx = harmedPlayer.idx
    harmedPlayer.dropItemKeyPressing = true
    harmedPlayer:teleport(-199616, -200000, false)
    if pIndx == 1 then 
        playerOneDead = true
        playerOneRespawnTimer = respawnTime
    end
    if pIndx == 2 then
        playerTwoDead = true
        playerTwoRespawnTimer = respawnTime
    end
end

function Timer.onEnd()
    Text.showMessageBox("Game Over!")
    Level.load(nil, nil, nil)
end

function spawnEnemy(x, y)
    local enemy = NPC.spawn(enemyID, x, y)
    enemy.ai1 = 6
end
