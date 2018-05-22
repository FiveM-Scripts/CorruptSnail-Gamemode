using CitizenFX.Core;
using CitizenFX.Core.Native;
using CorruptSnail.Spawners.Events;
using CorruptSnail.Util;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CorruptSnail.Spawners
{
    class ZombieSpawner : BaseScript
    {
        private const int ZOMBIE_AMOUNT = 35;
        private const double ZOMBIE_ATTR_CHANCE = 0.5;
        private const int ZOMBIE_MAX_ARMOR = 1000; 

        private List<Ped> zombies;
        public static RelationshipGroup ZombieGroup { get; private set; }

        public ZombieSpawner()
        {
            zombies = new List<Ped>();
            ZombieGroup = World.AddRelationshipGroup("zombies");

            EventHandlers["corruptsnail:client:newZombie"] += new Action<int>(OnNewZombie);
            Tick += OnTick;
        }

        private async Task OnTick()
        {
            if (LocalPlayer.Character != null)
            {
                if (SpawnerHost.IsHost)
                    if (zombies.Count < ZOMBIE_AMOUNT)
                        SpawnRandomZombie();

                if (zombies.Count > 0)
                    foreach (Ped zombie in zombies.ToArray())
                        if (!Utils.IsPosInRadiusOfAPlayer(Players, zombie.Position, SpawnerHost.SPAWN_DESPAWN_DISTANCE)
                            || zombie.IsDead)
                        {
                            zombie.MarkAsNoLongerNeeded();
                            zombies.Remove(zombie);
                        }
            }

            await Task.FromResult(0);
        }

        private async void SpawnRandomZombie()
        {
            Vector3 spawnPos = Utils.GetRandomSpawnPosFromPlayer(LocalPlayer, SpawnerHost.SPAWN_MIN_DISTANCE, SpawnerHost.SPAWN_DESPAWN_DISTANCE);
            spawnPos.Z++;

            if (!Utils.IsPosInRadiusOfAPlayer(Players, spawnPos, SpawnerHost.SPAWN_MIN_DISTANCE))
            {
                Ped zombie = await World.CreatePed(PedHash.Zombie01, spawnPos);
                int zombieHandle = zombie.Handle;
                API.SetPedSeeingRange(zombieHandle, float.MaxValue);
                API.SetPedCombatRange(zombieHandle, 2);
                API.SetPedHearingRange(zombieHandle, float.MaxValue);
                API.SetPedCombatAttributes(zombieHandle, 46, true);
                API.SetPedCombatAttributes(zombieHandle, 5, true);
                API.SetPedCombatAttributes(zombieHandle, 1, false);
                API.SetPedCombatAttributes(zombieHandle, 0, false);
                API.SetPedCombatAbility(zombieHandle, 2);
                API.SetAiMeleeWeaponDamageModifier(float.MaxValue);
                API.SetPedRagdollBlockingFlags(zombieHandle, 4);
                API.SetPedCanPlayAmbientAnims(zombieHandle, false);
                zombie.Armor = new Random().Next(0, ZOMBIE_MAX_ARMOR);
                zombie.RelationshipGroup = ZombieGroup;
                ZombieGroup.SetRelationshipBetweenGroups(LocalPlayer.Character.RelationshipGroup, Relationship.Hate, true);
                ZombieGroup.SetRelationshipBetweenGroups(RebelSquadSpawner.RebelSquadGroup, Relationship.Hate, true);
                ZombieAttrChances(zombie);

                zombie.Task.WanderAround();
                TriggerServerEvent("corruptsnail:newZombie", API.NetworkGetNetworkIdFromEntity(zombieHandle));

                zombies.Add(zombie);
            }
        }

        private void OnNewZombie(int zombieNetHandle)
        {
            int zombieHandle = API.NetworkGetEntityFromNetworkId(zombieNetHandle);
            Ped zombie = new Ped(zombieHandle);

            zombie.Voice = "ALIENS";
            zombie.IsPainAudioEnabled = false;

            API.RequestAnimSet("move_m@drunk@verydrunk");
            API.SetPedMovementClipset(zombieHandle, "move_m@drunk@verydrunk", 1f);
        }

        private void ZombieAttrChances(Ped zombie)
        {
            if (AttrChance())
                API.SetPedRagdollOnCollision(zombie.Handle, true);
            if (AttrChance())
                API.SetPedHelmet(zombie.Handle, true);
            if (AttrChance())
                API.SetPedRagdollBlockingFlags(zombie.Handle, 1);
        }

        private bool AttrChance()
        {
            return new Random().NextDouble() <= ZOMBIE_ATTR_CHANCE;
        }
    }
}
