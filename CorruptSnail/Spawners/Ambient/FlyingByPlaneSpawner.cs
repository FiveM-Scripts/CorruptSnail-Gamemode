using CitizenFX.Core;
using CorruptSnail.Util;
using System.Threading.Tasks;

namespace CorruptSnail.Spawners.Ambient
{
    class FlyingByPlaneSpawner : BaseScript
    {
        private const int PLANE_SPAWNHEIGHT_MIN_OFFSET = 100;
        private const int PLANE_SPAWNHEIGHT_MAX_OFFSET = 500;
        private static VehicleHash[] PLANE_LIST { get; } = { VehicleHash.Cuban800, VehicleHash.Hydra };

        private class FlyingByPlane
        {
            public Vehicle Plane { get; private set; }
            public Ped Pilot { get; private set; }

            public FlyingByPlane(Vehicle plane, Ped pilot)
            {
                Plane = plane;
                Pilot = pilot;
            }
        }

        private FlyingByPlane flyingByPlane;

        public FlyingByPlaneSpawner()
        {
            Tick += OnTick;
        }

        private async Task OnTick()
        {
            if (LocalPlayer.Character != null)
            {
                if (flyingByPlane == null && SpawnerHost.IsHost)
                    SpawnRandomFlyingByPlane();
                else if (flyingByPlane != null)
                    if (!Utils.IsPosInRadiusOfAPlayer(Players, flyingByPlane.Plane.Position, SpawnerHost.SPAWN_DESPAWN_DISTANCE * 3))
                    {
                        flyingByPlane.Plane.MarkAsNoLongerNeeded();
                        flyingByPlane.Pilot.MarkAsNoLongerNeeded();
                        flyingByPlane = null;
                    }
            }

            await Task.FromResult(0);
        }

        private async void SpawnRandomFlyingByPlane()
        {
            Vector3 spawnPos = Utils.GetRandomSpawnPosFromPlayer(LocalPlayer, SpawnerHost.SPAWN_DESPAWN_DISTANCE, SpawnerHost.SPAWN_DESPAWN_DISTANCE * 2);
            spawnPos.Z += Utils.GetRandomInt(PLANE_SPAWNHEIGHT_MIN_OFFSET, PLANE_SPAWNHEIGHT_MAX_OFFSET);

            if (!Utils.IsPosInRadiusOfAPlayer(Players, spawnPos, SpawnerHost.SPAWN_DESPAWN_DISTANCE))
            {
                Vehicle plane = await World.CreateVehicle(PLANE_LIST[Utils.GetRandomInt(PLANE_LIST.Length)], spawnPos,
                    Utils.GetRandomInt(360));
                plane.IsInvincible = true;
                plane.IsEngineRunning = true;

                Ped pilot = await World.CreatePed(PedHash.Pilot01SMM, spawnPos);
                pilot.IsInvincible = true;
                pilot.SetIntoVehicle(plane, VehicleSeat.Driver);
                pilot.AlwaysKeepTask = true;
                pilot.Task.FleeFrom(pilot.GetOffsetPosition(new Vector3(0f, -10f, 10f)));

                flyingByPlane = new FlyingByPlane(plane, pilot);
            }
        }
    }
}
