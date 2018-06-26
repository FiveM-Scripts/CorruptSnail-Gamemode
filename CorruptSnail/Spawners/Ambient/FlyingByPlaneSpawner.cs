using CitizenFX.Core;
using CitizenFX.Core.Native;
using CorruptSnail.Util;
using System.Threading.Tasks;

namespace CorruptSnail.Spawners.Ambient
{
    class FlyingByPlaneSpawner : BaseScript
    {
        private const int PLANE_SPAWNHEIGHT_MIN_OFFSET = 100;
        private const int PLANE_SPAWNHEIGHT_MAX_OFFSET = 500;
        private static VehicleHash[] PLANE_LIST { get; } = { VehicleHash.Cuban800, VehicleHash.Lazer, VehicleHash.Hydra,
            VehicleHash.Dodo };

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
            await Delay(SpawnerHost.SPAWN_TICK_RATE);

            if (SpawnerHost.CanEventTrigger() && flyingByPlane == null)
                SpawnRandomFlyingByPlane();
            else if (flyingByPlane != null)
                if (!Utils.IsPosShitSpawn(Players, flyingByPlane.Plane.Position, SpawnerHost.SPAWN_DESPAWN_DISTANCE * 3))
                {
                    flyingByPlane.Plane.SetDecor(SpawnerHost.SPAWN_DESPAWN_DECOR, true);
                    flyingByPlane.Pilot.SetDecor(SpawnerHost.SPAWN_DESPAWN_DECOR, true);
                    flyingByPlane = null;
                }
        }

        private async void SpawnRandomFlyingByPlane()
        {
            Vector3 spawnPos = Utils.GetRandomSpawnPosFromPlayer(Game.Player, SpawnerHost.SPAWN_DESPAWN_DISTANCE, SpawnerHost.SPAWN_DESPAWN_DISTANCE * 2);
            spawnPos.Z += Utils.GetRandomInt(PLANE_SPAWNHEIGHT_MIN_OFFSET, PLANE_SPAWNHEIGHT_MAX_OFFSET);

            if (!Utils.IsPosShitSpawn(Players, spawnPos, SpawnerHost.SPAWN_DESPAWN_DISTANCE))
            {
                Vehicle plane = await EntityUtil.CreateVehicle(PLANE_LIST[Utils.GetRandomInt(PLANE_LIST.Length)], spawnPos,
                    Utils.GetRandomInt(360));
                plane.IsInvincible = true;
                plane.IsEngineRunning = true;

                Ped pilot = await EntityUtil.CreatePed(PedHash.Pilot01SMM, PedType.PED_TYPE_MISSION, spawnPos);
                pilot.IsInvincible = true;
                pilot.SetIntoVehicle(plane, VehicleSeat.Driver);
                pilot.AlwaysKeepTask = true;
                pilot.Task.FleeFrom(pilot.GetOffsetPosition(new Vector3(0f, -10f, 10f)));

                flyingByPlane = new FlyingByPlane(plane, pilot);
            }
        }
    }
}
