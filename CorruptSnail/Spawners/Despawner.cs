using CitizenFX.Core;
using CorruptSnail.Util;
using System.Threading.Tasks;

namespace CorruptSnail.Spawners
{
    class Despawner : BaseScript
    {
        public Despawner()
        {
            Tick += OnTick;
        }

        private async Task OnTick()
        {
            await Delay(SpawnerHost.SPAWN_TICK_RATE);

            foreach (Prop prop in World.GetAllProps())
                if (prop.HasDecor(SpawnerHost.SPAWN_DESPAWN_DECOR))
                    prop.MarkAsNoLongerNeeded();

            foreach (Ped ped in World.GetAllPeds())
                if (ped.HasDecor(SpawnerHost.SPAWN_DESPAWN_DECOR))
                    ped.MarkAsNoLongerNeeded();

            foreach (Vehicle veh in World.GetAllVehicles())
                if (veh.HasDecor(SpawnerHost.SPAWN_DESPAWN_DECOR))
                    veh.MarkAsNoLongerNeeded();
        }
    }
}
