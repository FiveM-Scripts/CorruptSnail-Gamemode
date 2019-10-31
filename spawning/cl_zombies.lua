local DECOR = "_ARRRGHHHH!!!!"
DecorRegister(DECOR, 2)

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

local function FetchPeds()
    local peds = {}
    local zombieAmount = 0

    for ped in EntityEnum.EnumeratePeds() do
        local isZombie = DecorExistOn(ped, DECOR)

        if isZombie then
            zombieAmount = zombieAmount + 1
        end

        table.insert(peds, {Handle = ped, IsZombie = isZombie, RelationshipGroup = GetPedRelationshipGroupHash(ped)})

        Wait(0)
    end

    return peds, zombieAmount
end

local function SpawnRandomZombieIfPossible()
    local spawnPos = Utils.FindGoodSpawnPos(Config.Spawning.Zombies.MIN_SPAWN_DISTANCE)

    if spawnPos then
        local newZ = Utils.ZToGround(spawnPos)

        if newZ then
            local zombie = Utils.CreatePed(ZOMBIE_MODEL, 25, vector3(spawnPos.x, spawnPos.y, newZ), 0.0)
            ZombifyPed(zombie)

            DecorSetBool(zombie, DECOR, true)
        end
    end
end

local function HandleExistingZombies(peds)
    for _, ped in ipairs(peds) do
        if ped.IsZombie then
            local handle = ped.Handle

            if IsPedDeadOrDying(handle) or not Utils.IsPosNearAPlayer(GetEntityCoords(handle), Config.Spawning.Zombies.DESPAWN_DISTANCE) then
                DeletePed(handle)
            else
                local relaionshipGroup = ped.RelationshipGroup

                for _, ped2 in ipairs(peds) do
                    local relationship = ped2.IsZombie and 0 or 5
                    local relaionshipGroup2 = ped2.RelationshipGroup

                    SetRelationshipBetweenGroups(relationship, relaionshipGroup, relaionshipGroup2)
                    SetRelationshipBetweenGroups(relationship, relaionshipGroup2, relaionshipGroup)
                end

                SetAmbientVoiceName(handle, "ALIENS")

                DisablePedPainAudio(handle, true)

                RequestAnimSet("move_m@drunk@verydrunk")
                SetPedMovementClipset(handle, "move_m@drunk@verydrunk", 1.0)
            end

            Wait(0)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(Config.Spawning.TICK_RATE)

        if NetworkIsSessionActive() then
            local peds, zombieAmount = FetchPeds()

            if Player.IsSpawnHost() and zombieAmount < Config.Spawning.Zombies.MAX_AMOUNT then
                SpawnRandomZombieIfPossible()
            end
    
            HandleExistingZombies(peds)
        end
    end
end)