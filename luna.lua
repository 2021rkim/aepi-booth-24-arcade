--------------------------------------------------
-- Episode code for every level
-- Created 16:57 2023-12-22
--------------------------------------------------
require("playerphysicspatch")
canFlyAddress = 0x16C
flightTimeAddress = 0x170
isSpinJumpingAddress = 0x50
playerSpawnPositions = {{x = 1, y = 1}, {x = 2, y = 2}}
enemyID = 177
eggID = 186
respawnTime = 100
speedCap = 120

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
            player.x = playerSpawnPositions[1].x
            player.y = playerSpawnPositions[1].y
        end
    end

    if playerTwoDead then 
        playerTwoRespawnTimer = playerTwoRespawnTimer - 1
        if playerTwoRespawnTimer == 0 then
            player2.x = playerSpawnPositions[2].x
            player2.y = playerSpawnPositions[2].y
        end
    end
    
end

function onNPCHarm(eventName, harmedNPC, harmType, culprit)
    if harmedNPC.id == enemyID then
        Text.showMessageBox(string.format("CULPRIT %d", culprit.character))
        local egg = NPC.spawn(eggID, harmedNPC.x, harmedNPC.y, 0)
    end
    culprit:mem(0x138, FIELD_FLOAT, culprit.speedX) 
end

-- Run code when internal event of the SMBX Engine has been triggered
-- eventName - name of triggered event
function onEvent(eventName)
    --Your code here
end

function initPlayers()
    Defines.player_walkspeed = 8
    Defines.player_grav = 0.45
    Defines.gravity = 100
    playerSpawnPositions[1].x = player.x
    playerSpawnPositions[1].y = player.y
    if Player.count() < 2 then 
        return
    end
    playerSpawnPositions[2].x = player2.x
    playerSpawnPositions[2].y = player2.y
end

function onPlayerKill(eventToken, harmedPlayer)
    eventToken.cancelled = true
    Text.showMessageBox(string.format("harmedPlayer %d", harmedPlayer.character))
    pIndx = harmedPlayer.idx
    harmedPlayer.dropItemKeyPressing = true
    harmedPlayer.speedX = 0
    harmedPlayer.speedY = 0
    harmedPlayer:mem(0x140, FIELD_WORD, 200)
    --harmedPlayer:teleport(-199616, -200000, false)
    harmedPlayer.x = -199680 --arbitrary block position above the visible screen
    harmedPlayer.y = -200672
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
