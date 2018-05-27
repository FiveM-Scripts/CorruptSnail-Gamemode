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

            foreach (Prop prop in EntityEnum.GetProps())
                if (prop.HasDecor(SpawnerHost.SPAWN_DESPAWN_DECOR))
                    prop.MarkAsNoLongerNeeded();

            foreach (Ped ped in EntityEnum.GetPeds())
                if (ped.HasDecor(SpawnerHost.SPAWN_DESPAWN_DECOR))
                    ped.MarkAsNoLongerNeeded();

            foreach (Vehicle veh in EntityEnum.GetVehicles())
                if (veh.HasDecor(SpawnerHost.SPAWN_DESPAWN_DECOR))
                    veh.MarkAsNoLongerNeeded();
        }
    }
}
