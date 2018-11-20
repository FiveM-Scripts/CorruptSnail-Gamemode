local _DECOR = "_ARRRGHHHH!!!!"
DecorRegister(_DECOR, 2)
local _ZombieModel = GetHashKey(Config.Spawning.Zombies.ZOMBIE_MODEL)

local function _AttrRollTheDice()
    return math.random(100) <= Config.Spawning.Zombies.ATTR_CHANCE
end

local function _ZombifyPed(ped)
    SetPedHearingRange(ped, 9999.0)
    SetPedSeeingRange(ped, 50.0)

    SetPedCombatAttributes(ped, 46, true)
    SetPedCombatAttributes(ped, 5, true)
    SetPedCombatAttributes(ped, 1, false)
    SetPedCombatAttributes(ped, 0, false)
    SetPedCombatAbility(ped, 2)
    SetPedCombatRange(ped, 2)
    SetPedCombatMovement(ped, 3)

    SetAiMeleeWeaponDamageModifier(9999.0)
    SetPedRagdollBlockingFlags(ped, 4)
    SetPedCanPlayAmbientAnims(ped, false)
    TaskWanderStandard(ped, 10.0, 10)

    SetEntityHealth(ped, math.random(1, Config.Spawning.Zombies.MAX_HEALTH))
    SetPedArmour(ped, math.random(1, Config.Spawning.Zombies.MAX_ARMOR))
    
    if _AttrRollTheDice() then
        SetPedRagdollOnCollision(ped, true)
    end
    if _AttrRollTheDice() then
        SetPedHelmet(ped, true)
    end
    if _AttrRollTheDice() then
        SetPedRagdollBlockingFlags(ped, 1)
    end
    if _AttrRollTheDice() then
        SetPedSuffersCriticalHits(ped, false)
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(Config.Spawning.TICK_RATE)
        if NetworkIsSessionActive() then
            local peds = {}
            local zombieAmount = 0
            for ped in EntityEnum.EnumeratePeds() do
                local isZombie = DecorExistOn(ped, _DECOR)
                if isZombie then
                    zombieAmount = zombieAmount + 1
                end
                table.insert(peds, {handle = ped, isZombie = isZombie, relationshipGroup = GetPedRelationshipGroupHash(ped)})
            end

            if Player.IsHost() and zombieAmount < Config.Spawning.Zombies.MAX_AMOUNT then
                local spawnPos = Utils.FindGoodSpawnPos(Config.Spawning.Zombies.MIN_SPAWN_DISTANCE + 0.0)
                if spawnPos then
                    local newZ = Utils.ZToGround(spawnPos)
                    if newZ then
                        local zombie = Utils.CreatePed(_ZombieModel, 25, vector3(spawnPos.x, spawnPos.y, newZ), 0.0)
                        _ZombifyPed(zombie)
                        DecorSetBool(zombie, _DECOR, true)
                    end
                end
            end
    
            for _, ped in ipairs(peds) do
                if ped.isZombie then
                    for _, ped2 in ipairs(peds) do
                        SetRelationshipBetweenGroups(ped2.isZombie and 0 or 5, ped.relationshipGroup, ped2.relationshipGroup)
                        SetRelationshipBetweenGroups(ped2.isZombie and 0 or 5, ped2.relationshipGroup, ped.relationshipGroup)
                    end
                    SetAmbientVoiceName(ped.Handle, "ALIENS")
                    DisablePedPainAudio(ped.Handle, true)
                    RequestAnimSet("move_m@drunk@verydrunk")
                    SetPedMovementClipset(ped.Handle, "move_m@drunk@verydrunk", 1.0)
                    if IsPedDeadOrDying(ped.Handle) or not Utils.IsPosNearAPlayer(GetEntityCoords(ped.Handle), Config.Spawning.Zombies.DESPAWN_DISTANCE) then
                        DeletePed(ped.Handle)
                    end
                end
            end
        end
    end
end)