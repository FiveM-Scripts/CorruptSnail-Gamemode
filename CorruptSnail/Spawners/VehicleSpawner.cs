using CitizenFX.Core;
using CorruptSnail.Util;
using System;
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
            if (LocalPlayer.Character != null)
            {
                if (SpawnerHost.IsHost)
                    if (spawnedVeh == null && new Random().NextDouble() < SpawnerHost.SPAWN_EVENT_CHANCE)
                        SpawnRandomVeh();

                if (spawnedVeh != null)
                    if (!Utils.IsPosInRadiusOfAPlayer(Players, spawnedVeh.Position, SpawnerHost.SPAWN_DESPAWN_DISTANCE)
                        || spawnedVeh.EngineHealth == 0f)
                    {
                        spawnedVeh.MarkAsNoLongerNeeded();
                        spawnedVeh = null;
                    }
            }

            await Task.FromResult(0);
        }

        private async void SpawnRandomVeh()
        {
            Vector3 spawnPos = Utils.GetRandomSpawnPosFromPlayer(LocalPlayer, SpawnerHost.SPAWN_MIN_DISTANCE, SpawnerHost.SPAWN_DESPAWN_DISTANCE);

            if (!Utils.IsPosInRadiusOfAPlayer(Players, spawnPos, SpawnerHost.SPAWN_MIN_DISTANCE))
            {
                Vehicle veh = await World
                    .CreateVehicle(VEH_LIST[new Random().Next(VEH_LIST.Length)], spawnPos);
                Random random = new Random();
                veh.EngineHealth = random.Next(0, 1000);
                spawnedVeh = veh;
            }
        }
    }
}
