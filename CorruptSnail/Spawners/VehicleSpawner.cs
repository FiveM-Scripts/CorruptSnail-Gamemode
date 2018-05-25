using CitizenFX.Core;
using CorruptSnail.Util;
using System.Threading.Tasks;

namespace CorruptSnail.Spawners
{
    class VehicleSpawner : BaseScript
    {
        private static VehicleHash[] VEH_LIST { get; } = { VehicleHash.Faggio, VehicleHash.Asterope, VehicleHash.Ingot,
            VehicleHash.Asea };

        private Vehicle spawnedVeh;

        public VehicleSpawner()
        {
            Tick += OnTick;
        }

        private async Task OnTick()
        {
            if (SpawnerHost.CanEventTrigger() && spawnedVeh == null)
                SpawnRandomVeh();
            else if (spawnedVeh != null)
                if (!Utils.IsPosInRadiusOfAPlayer(Players, spawnedVeh.Position, SpawnerHost.SPAWN_DESPAWN_DISTANCE)
                    || spawnedVeh.EngineHealth == 0f)
                {
                    spawnedVeh.MarkAsNoLongerNeeded();
                    spawnedVeh = null;
                }

            await Task.FromResult(0);
        }

        private async void SpawnRandomVeh()
        {
            Vector3 spawnPos = Utils.GetRandomSpawnPosFromPlayer(LocalPlayer, SpawnerHost.SPAWN_MIN_DISTANCE, SpawnerHost.SPAWN_DESPAWN_DISTANCE);

            if (!Utils.IsPosInRadiusOfAPlayer(Players, spawnPos, SpawnerHost.SPAWN_MIN_DISTANCE))
            {
                Vehicle veh = await World
                    .CreateVehicle(VEH_LIST[Utils.GetRandomInt(VEH_LIST.Length)], spawnPos);
                veh.Health = Utils.GetRandomInt(1000);
                veh.EngineHealth = Utils.GetRandomInt(1000);
                veh.PetrolTankHealth = Utils.GetRandomInt(1000);
                spawnedVeh = veh;
            }
        }
    }
}
