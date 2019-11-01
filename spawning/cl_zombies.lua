local PLAYER_GROUP = GetHashKey("PLAYER")

local ZOMBIE_GROUP = GetHashKey("_ZOMBIE")
AddRelationshipGroup("_ZOMBIE")

SetRelationshipBetweenGroups(5, PLAYER_GROUP, ZOMBIE_GROUP)
SetRelationshipBetweenGroups(5, ZOMBIE_GROUP, PLAYER_GROUP)

local ZOMBIE_IGNORE_COMBAT_TIMEOUT_DECOR = "_ZOMBIE_IGNORE_COMBAT_TIMEOUT"
DecorRegister(ZOMBIE_IGNORE_COMBAT_TIMEOUT_DECOR, 3)

local ZOMBIE_TARGET_DECOR = "_ZOMBIE_TARGET"
DecorRegister(ZOMBIE_TARGET_DECOR, 3)

local ZOMBIE_UPDATE_TASK_TIMEOUT_DECOR = "_ZOMBIE_UPDATE_TASK_TIMEOUT"
DecorRegister(ZOMBIE_UPDATE_TASK_TIMEOUT_DECOR, 3)

local ZOMBIE_MODEL = GetHashKey(Config.Spawning.Zombies.ZOMBIE_MODEL)

local m_peds = {}
local m_zombieAmount = 0

local function AttrRollTheDice()
    return math.random(100) <= Config.Spawning.Zombies.ATTR_CHANCE
end

local function ZombifyPed(ped)
    SetPedRelationshipGroupHash(ped, ZOMBIE_GROUP)

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
    SetPedCanRagdollFromPlayerImpact(handle, false)
    SetPedCanPlayAmbientAnims(ped, false)
    SetPedKeepTask(ped, true)
    TaskWanderStandard(ped, 10.0, 10)

    SetEntityHealth(ped, math.random(200, Config.Spawning.Zombies.MAX_HEALTH))
    SetPedArmour(ped, math.random(200, Config.Spawning.Zombies.MAX_ARMOR))
    
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

    local untilPause = 10
    for ped in EntityEnum.EnumeratePeds() do
        local relationshipGroup = GetPedRelationshipGroupHash(ped)
        local isZombie = relationshipGroup == ZOMBIE_GROUP
        local isInCombat = false

        if isZombie then
            zombieAmount = zombieAmount + 1

            for playerId in ipairs(GetActivePlayers()) do
                local playerPedId = GetPlayerPed(playerId)

                if IsPedInCombat(handle, playerPedId) then
                    isInCombat = true

                    break
                end
            end
        end

        table.insert(peds, {Handle = ped, IsZombie = isZombie, RelationshipGroup = relationshipGroup,
            ZombieIsInCombat = isInCombat})

        untilPause = untilPause - 1
        if untilPause < 0 then
            untilPause = 10
            Wait(50)
        end
    end

    m_peds = peds
    m_zombieAmount = zombieAmount
end

local function SpawnRandomZombieIfPossible()
    local spawnPos = Utils.FindGoodSpawnPos(Config.Spawning.Zombies.MIN_SPAWN_DISTANCE)

    if spawnPos then
        local newZ = Utils.ZToGround(spawnPos)

        if not newZ then
            newZ = spawnPos.z - 1000.0
        end

        local zombie = Utils.CreatePed(ZOMBIE_MODEL, 25, vector3(spawnPos.x, spawnPos.y, newZ), 0.0)
        ZombifyPed(zombie)

        DecorSetInt(zombie, ZOMBIE_IGNORE_COMBAT_TIMEOUT_DECOR, 0)
        DecorSetInt(zombie, ZOMBIE_TARGET_DECOR, 0)
        DecorSetInt(zombie, ZOMBIE_UPDATE_TASK_TIMEOUT_DECOR, 0)
    end
end

local function HandleExistingZombies()
    local mPlayerPed = PlayerPedId()
    local mPlayerPedPos = GetEntityCoords(mPlayerPed)
    local currentCloudTime = GetCloudTimeAsInt()

    for _, ped in ipairs(m_peds) do
        if ped.IsZombie then
            local handle = ped.Handle
            local zombieCoords = GetEntityCoords(handle)

            if IsPedDeadOrDying(handle) or not Utils.IsPosNearAPlayer(zombieCoords, Config.Spawning.Zombies.DESPAWN_DISTANCE) then
                SetPedAsNoLongerNeeded(handle)
            else
                local relationshipGroup = ped.RelationshipGroup

                for _, ped2 in ipairs(m_peds) do
                    if not ped2.IsZombie and IsPedAPlayer(ped2.Handle) then
                        local relationshipGroup2 = ped2.RelationshipGroup

                        SetRelationshipBetweenGroups(5, relationshipGroup, relationshipGroup2)
                        SetRelationshipBetweenGroups(5, relationshipGroup2, relationshipGroup)
                    end
                end

                SetAmbientVoiceName(handle, "ALIENS")

                DisablePedPainAudio(handle, true)

                RequestAnimSet("move_m@drunk@verydrunk")
                SetPedMovementClipset(handle, "move_m@drunk@verydrunk", 0.5)

                if Utils.GetDistanceBetweenCoords(mPlayerPedPos, zombieCoords) > 1.0 then
                    local zombieCombatTimeout = DecorGetInt(handle, ZOMBIE_IGNORE_COMBAT_TIMEOUT_DECOR)

                    if zombieCombatTimeout <= currentCloudTime then
                        SetBlockingOfNonTemporaryEvents(handle, false)

                        if IsPedInCombat(handle, mPlayerPed) then
                            DecorSetInt(handle, ZOMBIE_IGNORE_COMBAT_TIMEOUT_DECOR, currentCloudTime + 10)
                            DecorSetInt(handle, ZOMBIE_TARGET_DECOR, mPlayerPed)
                        end
                    else
                        SetBlockingOfNonTemporaryEvents(handle, true)

                        if DecorGetInt(handle, ZOMBIE_TARGET_DECOR) == mPlayerPed
                            and DecorGetInt(handle, ZOMBIE_UPDATE_TASK_TIMEOUT_DECOR) <= currentCloudTime then

                            TaskGoToEntity(handle, mPlayerPed, -1, 1.0, 1.0)
                            TaskGoStraightToCoord(handle, table.unpack(mPlayerPedPos), math.random(1, 2) + 0.0, -1, 0.0, 0.0)

                            DecorSetInt(handle, ZOMBIE_UPDATE_TASK_TIMEOUT_DECOR, currentCloudTime + 3)
                        end
                    end
                else
                    if not ped.ZombieIsInCombat then
                        TaskCombatPed(handle, mPlayerPed, 0, 16)
                    end
                end
            end
        end
    end
end

Citizen.CreateThread(function()
    while not NetworkIsSessionActive() do
        Wait(100)
    end

    while true do
        Wait(Config.Spawning.TICK_RATE)

        FetchPeds()

        if Player.IsSpawnHost() and m_zombieAmount <= Config.Spawning.Zombies.MAX_AMOUNT then
            SpawnRandomZombieIfPossible()
        end
    end
end)

Citizen.CreateThread(function()
    while not NetworkIsSessionActive() do
        Wait(100)
    end

    while true do
        Wait(100)

        HandleExistingZombies(m_peds)
    end
end)