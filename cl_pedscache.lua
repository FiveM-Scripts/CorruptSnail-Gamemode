g_peds = {}
g_zombieAmount = 0

local function FetchPeds()
    local zombieAmount = 0

    local untilPause = 10

    for ped, pedData in pairs(g_peds) do
        if not DoesEntityExist(ped) or IsPedDeadOrDying(ped) then
            g_peds[ped] = nil
        elseif pedData.IsZombie then
            zombieAmount = zombieAmount + 1
        end
    end

    for ped in EntityEnum.EnumeratePeds() do
        local relationshipGroup = GetPedRelationshipGroupHash(ped)
        local isZombie = relationshipGroup == ZOMBIE_GROUP
        local isGuard = relationshipGroup == SAFEZONE_GUARD_GROUP
        local combatTarget

        if isZombie then
            zombieAmount = zombieAmount + 1

            for ped2 in EntityEnum.EnumeratePeds() do
                if IsPedInCombat(ped, ped2) then
                    combatTarget = ped2

                    break
                end
            end
        end

        g_peds[ped] = {IsZombie = isZombie, RelationshipGroup = relationshipGroup, ZombieCombatTarget = combatTarget,
            IsGuard = isGuard}

        untilPause = untilPause - 1
        if untilPause < 0 then
            untilPause = 10

            Wait(0)
        end
    end

    g_zombieAmount = zombieAmount
end

Utils.CreateLoadedInThread(function()
    while true do
        Wait(100)

        FetchPeds()
    end
end)