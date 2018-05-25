using CitizenFX.Core;
using CorruptSnail.Util;
using System;
using System.Threading.Tasks;

namespace CorruptSnail.Spawners.Ambient
{
    class AmbientWarNoiseSpawner : BaseScript
    {
        public AmbientWarNoiseSpawner()
        {
            Tick += OnTick;
        }

        private async Task OnTick()
        {
            if (SpawnerHost.CanEventTrigger())
                SpawnFarExplosion();

            await Task.FromResult(0);
        }

        private void SpawnFarExplosion()
        {
            Vector3 spawnPos = Utils.GetRandomSpawnPosFromPlayer(LocalPlayer, SpawnerHost.SPAWN_DESPAWN_DISTANCE * 10, SpawnerHost.SPAWN_DESPAWN_DISTANCE * 50);

            if (!Utils.IsPosInRadiusOfAPlayer(Players, spawnPos, SpawnerHost.SPAWN_DESPAWN_DISTANCE * 5))
            {
                Array explosionTypes = Enum.GetValues(typeof(ExplosionType));
                World.AddExplosion(spawnPos, (ExplosionType) explosionTypes.GetValue(Utils.GetRandomInt(explosionTypes.Length)),
                    0f, 0f, null, true, true);
            }
        }
    }
}
