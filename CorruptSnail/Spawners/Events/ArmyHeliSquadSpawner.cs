using CitizenFX.Core;
using CitizenFX.Core.Native;
using CorruptSnail.Util;
using System;
using System.Threading.Tasks;

namespace CorruptSnail.Spawners.Events
{
    class ArmyHeliSquadSpawner : BaseScript
    {
        private const float ARMYHELI_SPAWNHEIGHT_OFFSET = 500f;
        private const int ARMYHELI_MIN_SPEED = 10;
        private static VehicleHash[] HELI_LIST { get; } = { VehicleHash.Buzzard, VehicleHash.Savage, VehicleHash.Cargobob };

        private class ArmyHeliSquad
        {
            public Vehicle HELI { get; private set; }
            public Ped PILOT { get; private set; }
            public Ped GUNMAN1 { get; private set; }
            public Ped GUNMAN2 { get; private set; }

            public ArmyHeliSquad(Vehicle heli, Ped pilot, Ped gunman1, Ped gunman2)
            {
                HELI = heli;
                PILOT = pilot;
                GUNMAN1 = gunman1;
                GUNMAN2 = gunman2;
            }
        }

        private ArmyHeliSquad armyHeliSquad;
        public static RelationshipGroup ArmyHeliSquadGroup { get; private set; }

        public ArmyHeliSquadSpawner()
        {
            ArmyHeliSquadGroup = World.AddRelationshipGroup("armyHeliSquad");

            Tick += OnTick;
        }

        private async Task OnTick()
        {
            if (LocalPlayer.Character != null)
            {
                if (SpawnerHost.IsHost)
                    if (armyHeliSquad == null && new Random().NextDouble() <= SpawnerHost.SPAWN_EVENT_CHANCE)
                        SpawnRandomArmyHeli();

                if (armyHeliSquad != null)
                {
                    if (!Utils.IsPosInRadiusOfAPlayer(Players, armyHeliSquad.HELI.Position, SpawnerHost.SPAWN_DESPAWN_DISTANCE * 3))
                    {
                        armyHeliSquad.HELI.MarkAsNoLongerNeeded();
                        armyHeliSquad.PILOT.MarkAsNoLongerNeeded();
                        armyHeliSquad.GUNMAN1.MarkAsNoLongerNeeded();
                        armyHeliSquad.GUNMAN2.MarkAsNoLongerNeeded();
                        armyHeliSquad = null;
                    }
                }
            }

            await Task.FromResult(0);
        }

        private async void SpawnRandomArmyHeli()
        {
            Vector3 spawnPos = Utils.GetRandomSpawnPosFromPlayer(LocalPlayer, SpawnerHost.SPAWN_DESPAWN_DISTANCE, SpawnerHost.SPAWN_DESPAWN_DISTANCE * 2);
            spawnPos.Z += ARMYHELI_SPAWNHEIGHT_OFFSET;

            if (!Utils.IsPosInRadiusOfAPlayer(Players, spawnPos, SpawnerHost.SPAWN_DESPAWN_DISTANCE))
            {
                Vehicle heli = await World.CreateVehicle(HELI_LIST[new Random().Next(HELI_LIST.Length)], spawnPos);
                heli.IsInvincible = true;
                heli.IsEngineRunning = true;

                Ped pilot = await World.CreatePed(PedHash.Blackops01SMY, spawnPos);
                pilot.IsInvincible = true;
                pilot.RelationshipGroup = ArmyHeliSquadGroup;
                pilot.SetIntoVehicle(heli, VehicleSeat.Driver);
                pilot.AlwaysKeepTask = true;
                Vector3 targetPos = LocalPlayer.Character
                    .GetPositionOffset(new Vector3(0f, -SpawnerHost.SPAWN_DESPAWN_DISTANCE, 0f));
                API.TaskHeliMission(pilot.Handle, heli.Handle, 0, 0, targetPos.X, targetPos.Y, targetPos.Z,
                    4, new Random().Next(ARMYHELI_MIN_SPEED, int.MaxValue), 0f, -1f, -1, -1, 0, 0);

                Ped[] gunmans = new Ped[2];
                for (int i = 0; i < gunmans.Length; i++)
                {
                    Ped gunman = await World.CreatePed(PedHash.Blackops01SMY, spawnPos);
                    gunman.IsInvincible = true;
                    gunman.RelationshipGroup = ArmyHeliSquadGroup;
                    gunman.Weapons.Give(WeaponHash.CarbineRifleMk2, int.MaxValue, true, true);
                    gunman.Accuracy = 100;
                    gunman.AlwaysKeepTask = true;
                    gunman.Task.FightAgainstHatedTargets(float.MaxValue);
                    gunmans[i] = gunman;
                }
                gunmans[0].SetIntoVehicle(heli, VehicleSeat.LeftRear);
                gunmans[1].SetIntoVehicle(heli, VehicleSeat.RightRear);
                ArmyHeliSquadGroup.SetRelationshipBetweenGroups(LocalPlayer.Character.RelationshipGroup, Relationship.Respect, true);
                ArmyHeliSquadGroup.SetRelationshipBetweenGroups(ZombieSpawner.ZombieGroup, Relationship.Hate);

                armyHeliSquad = new ArmyHeliSquad(heli, pilot, gunmans[0], gunmans[1]);
            }
        }
    }
}
