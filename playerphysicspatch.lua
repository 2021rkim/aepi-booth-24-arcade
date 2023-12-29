--https://www.smbxgame.com/forums/viewtopic.php?t=25854
--modified to allow for flight accel changes
local lastXSpeed = {}
local lastYSpeed = {}
local ppp = {}

ppp.speedXDecelerationModifier = 0
ppp.groundTouchingDecelerationMultiplier = 8
ppp.groundNotTouchingDecelerationMultiplier = 0

ppp.accelerationMaxSpeedThereshold = 8
ppp.accelerationMinSpeedThereshold = 0 --default 0.1
ppp.accelerationSpeedDifferenceThereshold = 50
ppp.accelerationMultiplier = 3 --default 1.5

ppp.accelerationYMultiplier = 10
ppp.accelerationMaxYSpeedThreshold = 8

ppp.aerialIdleDeceleration = 1.001

ppp.enabled = true

function ppp.onInitAPI()
    registerEvent(ppp, "onTick")
end

function ppp.onTick()-- (deceleration tightness)
    if ppp.enabled then
        for k,p in ipairs(Player.get()) do
            lastXSpeed[k] = lastXSpeed[k] or 0
            lastYSpeed[k] = lastYSpeed[k] or 0
            if not player:mem(0x3C, FIELD_BOOL) then
                if (not (p:isGroundTouching() and p:mem(0x12E, FIELD_BOOL))) then
                    local mod = ppp.groundTouchingDecelerationMultiplier
                    if (not p:isGroundTouching()) then
                        mod = ppp.groundNotTouchingDecelerationMultiplier
                    end
                    if p.rightKeyPressing then
                        if p.speedX < 0 then
                            p.speedX = p.speedX + ppp.speedXDecelerationModifier * mod;
                        end
                    elseif p.leftKeyPressing then
                        if  p.speedX > 0 then
                            p.speedX = p.speedX - ppp.speedXDecelerationModifier * mod;
                        end
                    else
                        p.speedX = p.speedX * ppp.aerialIdleDeceleration;	
                    end
                end
            
            -- (acceleration tightness)
                local xspeeddiff = p.speedX - lastXSpeed[k]

                if math.abs(p.speedX) < ppp.accelerationMaxSpeedThereshold and math.abs(p.speedX) > ppp.accelerationMinSpeedThereshold and math.sign(p.speedX * xspeeddiff) == 1 and math.abs(xspeeddiff) <= ppp.accelerationSpeedDifferenceThereshold then
                    p.speedX = p.speedX - xspeeddiff
                    p.speedX = p.speedX + xspeeddiff * ppp.accelerationMultiplier
                end
                local yspeeddiff = p.speedY - lastYSpeed[k]

                if math.abs(p.speedY) < ppp. accelerationMaxYSpeedThreshold and math.sign(p.speedY * yspeeddiff) == 1 and p.keys.jump then
                    p.speedY = p.speedY - yspeeddiff
                    p.speedY = p.speedY + yspeeddiff * ppp.accelerationYMultiplier
                end

            end
            lastXSpeed[k] = p.speedX
            lastYSpeed[k] = p.speedY
        end
    end
end

return ppp