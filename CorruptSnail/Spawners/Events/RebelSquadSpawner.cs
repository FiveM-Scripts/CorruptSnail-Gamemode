using CitizenFX.Core;
using CitizenFX.Core.Native;
using CorruptSnail.Util;
using System;
using System.Threading.Tasks;

namespace CorruptSnail.Spawners.Events
{
    class RebelSquadSpawner : BaseScript
    {
        private const double REBELSQUAD_CHANCE = 0.001;
        private const int REBELSQUAD_MAXMEMBERS = 8;
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
            if (LocalPlayer.Character != null)
            {
                if (SpawnerHost.IsHost)
                    if (rebelSquad == null && new Random().NextDouble() <= REBELSQUAD_CHANCE)
                        SpawnRandomRebelSquad();

                if (rebelSquad != null)
                {
                    bool allObsolete = true;
                    for (int i = 0; i < rebelSquad.Rebels.Length; i++)
                    {
                        Ped rebel = rebelSquad.Rebels[i];
                        if (rebel.Exists())
                        {
                            if (!Utils.IsPosInRadiusOfAPlayer(Players, rebel.Position, SpawnerHost.SPAWN_DESPAWN_DISTANCE)
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

            await Task.FromResult(0);
        }

        private async void SpawnRandomRebelSquad()
        {
            Vector3 spawnPos = Utils.GetRandomSpawnPosFromPlayer(LocalPlayer, SpawnerHost.SPAWN_MIN_DISTANCE, SpawnerHost.SPAWN_DESPAWN_DISTANCE);
            spawnPos.Z++;

            if (!Utils.IsPosInRadiusOfAPlayer(Players, spawnPos, SpawnerHost.SPAWN_MIN_DISTANCE))
            {
                Ped[] rebels = new Ped[new Random().Next(1, REBELSQUAD_MAXMEMBERS)];
                for (int i = 0; i < rebels.Length; i++)
                {
                    Ped rebel = await World.CreatePed(PedHash.Hillbilly01AMM, spawnPos);
                    API.SetPedSeeingRange(rebel.Handle, float.MaxValue);
                    API.SetPedCombatRange(rebel.Handle, 2);
                    API.SetPedHearingRange(rebel.Handle, float.MaxValue);
                    rebel.RelationshipGroup = RebelSquadGroup;
                    rebel.Weapons.Give(WEAPON_LIST[new Random().Next(0, WEAPON_LIST.Length)], int.MaxValue, true, true);
                    rebel.Accuracy = 100;
                    rebel.Armor = 100;
                    rebel.Task.WanderAround();
                    rebels[i] = rebel;
                }
                RebelSquadGroup.SetRelationshipBetweenGroups(LocalPlayer.Character.RelationshipGroup, Relationship.Hate, true);
                RebelSquadGroup.SetRelationshipBetweenGroups(ZombieSpawner.ZombieGroup, Relationship.Hate, true);
                RebelSquadGroup.SetRelationshipBetweenGroups(ArmyHeliSquadSpawner.ArmyHeliSquadGroup, Relationship.Hate, true);

                rebelSquad = new RebelSquad(rebels);
            }
        }
    }
}
