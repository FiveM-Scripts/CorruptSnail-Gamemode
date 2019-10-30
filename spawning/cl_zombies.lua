local DECOR = "_ARRRGHHHH!!!!"
DecorRegister(_DECOR, 2)

local ZOMBIE_MODEL = GetHashKey(Config.Spawning.Zombies.ZOMBIE_MODEL)

local function AttrRollTheDice()
    return math.random(100) <= Config.Spawning.Zombies.ATTR_CHANCE
end

local function ZombifyPed(ped)
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
    
    if AttrRollTheDice() then
        SetPedRagdollOnCollision(ped, true)
    end

    if AttrRollTheDice() then
        SetPedHelmet(ped, true)
    end

    if AttrRollTheDice() then
        SetPedRagdollBlockingFlags(ped, 1)
    end

    if AttrRollTheDice() then
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
                local isZombie = DecorExistOn(ped, DECOR)

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
                        local zombie = Utils.CreatePed(ZOMBIE_MODEL, 25, vector3(spawnPos.x, spawnPos.y, newZ), 0.0)
                        ZombifyPed(zombie)

                        DecorSetBool(zombie, DECOR, true)
                    end
                end
            end
    
            for _, ped in ipairs(peds) do
                if ped.isZombie then
                    for _, ped2 in ipairs(peds) do
                        SetRelationshipBetweenGroups(ped2.isZombie and 0 or 5, ped.relationshipGroup, ped2.relationshipGroup)
                        SetRelationshipBetweenGroups(ped2.isZombie and 0 or 5, ped2.relationshipGroup, ped.relationshipGroup)
                    end

                    SetAmbientVoiceName(ped.handle, "ALIENS")

                    DisablePedPainAudio(ped.handle, true)

                    RequestAnimSet("move_m@drunk@verydrunk")
                    SetPedMovementClipset(ped.handle, "move_m@drunk@verydrunk", 1.0)
                    
                    if IsPedDeadOrDying(ped.handle) or not Utils.IsPosNearAPlayer(GetEntityCoords(ped.handle), Config.Spawning.Zombies.DESPAWN_DISTANCE) then
                        DeletePed(ped.handle)
                    end
                end
            end
        end
    end
end)