using CitizenFX.Core;
using CitizenFX.Core.Native;
using CorruptSnail.Util;
using System.Threading.Tasks;

namespace CorruptSnail.Spawners.Events
{
    class ArmyHeliSquadSpawner : BaseScript
    {
        private const int ARMYHELI_SPAWNHEIGHT_MIN_OFFSET = 100;
        private const int ARMYHELI_SPAWNHEIGHT_MAX_OFFSET = 500;
        private const int ARMYHELI_MIN_SPEED = 10;
        private const string ARMYHELI_DECOR = "_TOUGH_AF_FRIENDS";
        private static VehicleHash[] HELI_LIST { get; } = { VehicleHash.Buzzard, VehicleHash.Buzzard2,
            VehicleHash.Savage, VehicleHash.Cargobob };

        private class ArmyHeliSquad
        {
            public Vehicle Heli { get; private set; }
            public Ped Pilot { get; private set; }
            public Ped Gunman1 { get; private set; }
            public Ped Gunman2 { get; private set; }

            public ArmyHeliSquad(Vehicle heli, Ped pilot, Ped gunman1, Ped gunman2)
            {
                Heli = heli;
                Pilot = pilot;
                Gunman1 = gunman1;
                Gunman2 = gunman2;
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
            await Delay(SpawnerHost.SPAWN_TICK_RATE);

            if (SpawnerHost.CanEventTrigger() && armyHeliSquad == null)
                SpawnRandomArmyHeli();
            else if (armyHeliSquad != null)
                if (!Utils.IsPosShitSpawn(Players, armyHeliSquad.Heli.Position, SpawnerHost.SPAWN_DESPAWN_DISTANCE * 3))
                {
                    armyHeliSquad.Heli.SetDecor(SpawnerHost.SPAWN_DESPAWN_DECOR, true);
                    armyHeliSquad.Pilot.SetDecor(SpawnerHost.SPAWN_DESPAWN_DECOR, true);
                    armyHeliSquad.Gunman1.SetDecor(SpawnerHost.SPAWN_DESPAWN_DECOR, true);
                    armyHeliSquad.Gunman2.SetDecor(SpawnerHost.SPAWN_DESPAWN_DECOR, true);
                    armyHeliSquad = null;
                }

            HandleArmyHeliSquads();
        }

        private async void SpawnRandomArmyHeli()
        {
            Vector3 spawnPos = Utils.GetRandomSpawnPosFromPlayer(Game.Player, SpawnerHost.SPAWN_DESPAWN_DISTANCE, SpawnerHost.SPAWN_DESPAWN_DISTANCE * 2);
            spawnPos.Z += Utils.GetRandomInt(ARMYHELI_SPAWNHEIGHT_MIN_OFFSET, ARMYHELI_SPAWNHEIGHT_MAX_OFFSET);

            if (!Utils.IsPosShitSpawn(Players, spawnPos, SpawnerHost.SPAWN_DESPAWN_DISTANCE))
            {
                Vehicle heli = await EntityUtil.CreateVehicle(HELI_LIST[Utils.GetRandomInt(HELI_LIST.Length)], spawnPos,
                    Utils.GetRandomInt(360));
                heli.IsInvincible = true;
                heli.IsEngineRunning = true;

                Ped pilot = await EntityUtil.CreatePed(PedHash.Blackops01SMY, PedType.PED_TYPE_MISSION, spawnPos);
                pilot.IsInvincible = true;
                pilot.RelationshipGroup = ArmyHeliSquadGroup;
                pilot.SetIntoVehicle(heli, VehicleSeat.Driver);
                pilot.AlwaysKeepTask = true;
                pilot.SetDecor(ARMYHELI_DECOR, true);
                Vector3 targetPos = Game.PlayerPed
                    .GetOffsetPosition(new Vector3(0f, -SpawnerHost.SPAWN_DESPAWN_DISTANCE * 100f, 0f));
                API.TaskHeliMission(pilot.Handle, heli.Handle, 0, 0, targetPos.X, targetPos.Y, targetPos.Z,
                    4, Utils.GetRandomInt(ARMYHELI_MIN_SPEED, int.MaxValue), 0f, -1f, -1, -1, 0, 0);

                Ped[] gunmans = new Ped[2];
                for (int i = 0; i < gunmans.Length; i++)
                {
                    Ped gunman = await World.CreatePed(PedHash.Blackops01SMY, spawnPos);
                    gunman.IsInvincible = true;
                    gunman.RelationshipGroup = ArmyHeliSquadGroup;
                    gunman.Weapons.Give(WeaponHash.CombatMGMk2, int.MaxValue, true, true);
                    gunman.Accuracy = 100;
                    gunman.AlwaysKeepTask = true;
                    gunman.Task.FightAgainstHatedTargets(float.MaxValue);
                    gunman.SetDecor(ARMYHELI_DECOR, true);
                    gunmans[i] = gunman;
                }
                gunmans[0].SetIntoVehicle(heli, VehicleSeat.LeftRear);
                gunmans[1].SetIntoVehicle(heli, VehicleSeat.RightRear);
                ArmyHeliSquadGroup.SetRelationshipBetweenGroups(ZombieSpawner.ZombieGroup, Relationship.Hate);

                armyHeliSquad = new ArmyHeliSquad(heli, pilot, gunmans[0], gunmans[1]);
            }
        }

        private void HandleArmyHeliSquads()
        {
            foreach (Ped ped in World.GetAllPeds())
                if (ped.HasDecor(ARMYHELI_DECOR))
                    ped.RelationshipGroup.SetRelationshipBetweenGroups(Game.PlayerPed.RelationshipGroup, Relationship.Like, true);
        }
    }
}
