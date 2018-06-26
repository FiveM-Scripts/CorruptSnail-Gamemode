using CitizenFX.Core;
using CorruptSnail.Util;
using System.Threading.Tasks;

namespace CorruptSnail.Spawners
{
    class VehicleSpawner : BaseScript
    {
        private static VehicleHash[] VEH_LIST { get; } = { VehicleHash.Faggio, VehicleHash.Asterope, VehicleHash.Ingot,
            VehicleHash.Asea, VehicleHash.Sultan, VehicleHash.Technical };

        private Vehicle spawnedVeh;

        public VehicleSpawner()
        {
            Tick += OnTick;
        }

        private async Task OnTick()
        {
            await Delay(SpawnerHost.SPAWN_TICK_RATE);

            if (SpawnerHost.CanEventTrigger() && spawnedVeh == null)
                SpawnRandomVeh();
            else if (spawnedVeh != null)
                if (!Utils.IsPosShitSpawn(Players, spawnedVeh.Position, SpawnerHost.SPAWN_DESPAWN_DISTANCE)
                    || spawnedVeh.EngineHealth == 0f)
                {
                    spawnedVeh.SetDecor(SpawnerHost.SPAWN_DESPAWN_DECOR, true);
                    spawnedVeh = null;
                }
        }

        private async void SpawnRandomVeh()
        {
            Vector3 spawnPos = Utils.GetRandomSpawnPosFromPlayer(Game.Player, SpawnerHost.SPAWN_MIN_DISTANCE, SpawnerHost.SPAWN_DESPAWN_DISTANCE);

            if (!Utils.IsPosShitSpawn(Players, spawnPos, SpawnerHost.SPAWN_MIN_DISTANCE))
            {
                Vehicle veh = await EntityUtil.CreateVehicle(VEH_LIST[Utils.GetRandomInt(VEH_LIST.Length)], spawnPos);
                veh.Health = Utils.GetRandomInt(1000);
                veh.EngineHealth = Utils.GetRandomInt(1000);
                veh.PetrolTankHealth = Utils.GetRandomInt(1000);
                spawnedVeh = veh;
            }
        }
    }
}
