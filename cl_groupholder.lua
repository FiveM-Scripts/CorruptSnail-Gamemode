PLAYER_GROUP = GetHashKey("PLAYER")

ZOMBIE_GROUP = GetHashKey("_ZOMBIE")
AddRelationshipGroup("_ZOMBIE")
SetRelationshipBetweenGroups(5, PLAYER_GROUP, ZOMBIE_GROUP)
SetRelationshipBetweenGroups(5, ZOMBIE_GROUP, PLAYER_GROUP)

SAFEZONE_GUARD_GROUP = GetHashKey("_SAFEZONE_GUARD")
AddRelationshipGroup("_SAFEZONE_GUARD")
SetRelationshipBetweenGroups(1, PLAYER_GROUP, SAFEZONE_GUARD_GROUP)
SetRelationshipBetweenGroups(1, SAFEZONE_GUARD_GROUP, PLAYER_GROUP)