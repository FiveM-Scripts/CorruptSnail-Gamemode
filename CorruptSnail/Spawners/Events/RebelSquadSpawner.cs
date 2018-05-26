using CitizenFX.Core;
using CitizenFX.Core.Native;
using CorruptSnail.Util;
using System.Threading.Tasks;

namespace CorruptSnail.Spawners.Events
{
    class RebelSquadSpawner : BaseScript
    {
        private const int REBELSQUAD_MAXMEMBERS = 8;
        private const float REBELSQUAD_FRIENDLY_CHANCE = 0.5f;
        private static WeaponHash[] WEAPON_LIST { get; } = { WeaponHash.Pistol, WeaponHash.AssaultRifle, WeaponHash.PumpShotgun,
            WeaponHash.Bat };

        private class RebelSquad
        {
            public Ped[] Rebels;

            public RebelSquad(Ped[] rebels)
            {
                Rebels = rebels;
            }
        }

        private RebelSquad rebelSquad;
        public static RelationshipGroup RebelSquadGroup { get; private set; }

        public RebelSquadSpawner()
        {
            RebelSquadGroup = World.AddRelationshipGroup("rebelSquad");

            Tick += OnTick;
        }

        private async Task OnTick()
        {
            await Delay(SpawnerHost.SPAWN_TICK_RATE);

            if (SpawnerHost.CanEventTrigger() && rebelSquad == null)
                SpawnRandomRebelSquad();
            else if (rebelSquad != null)
            {
                bool allObsolete = true;
                for (int i = 0; i < rebelSquad.Rebels.Length; i++)
                {
                    Ped rebel = rebelSquad.Rebels[i];
                    if (rebel.Exists())
                    {
                        if (!Utils.IsPosShitSpawn(Players, rebel.Position, SpawnerHost.SPAWN_DESPAWN_DISTANCE)
                            || rebel.IsDead)
                            rebel.MarkAsNoLongerNeeded();
                        else
                            allObsolete = false;
                    }
                }

                if (allObsolete)
                    rebelSquad = null;
            }
        }

        private async void SpawnRandomRebelSquad()
        {
            Vector3 spawnPos = Utils.GetRandomSpawnPosFromPlayer(Game.Player, SpawnerHost.SPAWN_MIN_DISTANCE, SpawnerHost.SPAWN_DESPAWN_DISTANCE);

            if (!Utils.IsPosShitSpawn(Players, spawnPos, SpawnerHost.SPAWN_MIN_DISTANCE))
            {
                int rebelAmount = Utils.GetRandomInt(1, REBELSQUAD_MAXMEMBERS);
                Ped[] rebels = new Ped[rebelAmount];
                for (int i = 0; i < rebelAmount; i++)
                {
                    spawnPos.X += 5;
                    spawnPos.Y += 5;

                    Ped rebel = await World.CreatePed(PedHash.Hillbilly01AMM, spawnPos);
                    API.SetPedCombatRange(rebel.Handle, 2);
                    API.SetPedHearingRange(rebel.Handle, float.MaxValue);
                    rebel.RelationshipGroup = RebelSquadGroup;
                    rebel.Weapons.Give(WEAPON_LIST[Utils.GetRandomInt(WEAPON_LIST.Length)], int.MaxValue, true, true);
                    rebel.Accuracy = 100;
                    rebel.Armor = 100;
                    rebel.Task.WanderAround();
                    rebels[i] = rebel;
                }
                if (Utils.GetRandomFloat(1f) > REBELSQUAD_FRIENDLY_CHANCE)
                    RebelSquadGroup.SetRelationshipBetweenGroups(Game.PlayerPed.RelationshipGroup, Relationship.Hate, true);
                else
                    RebelSquadGroup.SetRelationshipBetweenGroups(Game.PlayerPed.RelationshipGroup, Relationship.Respect, true);
                RebelSquadGroup.SetRelationshipBetweenGroups(ZombieSpawner.ZombieGroup, Relationship.Hate, true);
                RebelSquadGroup.SetRelationshipBetweenGroups(ArmyHeliSquadSpawner.ArmyHeliSquadGroup, Relationship.Hate, true);

                rebelSquad = new RebelSquad(rebels);
            }
        }
    }
}
