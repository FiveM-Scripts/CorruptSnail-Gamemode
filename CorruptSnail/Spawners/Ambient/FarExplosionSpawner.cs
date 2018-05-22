using CitizenFX.Core;
using CorruptSnail.Util;
using System;
using System.Threading.Tasks;

namespace CorruptSnail.Spawners.Ambient
{
    class FarExplosionSpawner : BaseScript
    {
        private const double EXPLOSION_CHANCE = 0.001;

        public FarExplosionSpawner()
        {
            Tick += OnTick;
        }

        private async Task OnTick()
        {
            if (LocalPlayer.Character != null)
            {
                if (SpawnerHost.IsHost)
                    if (new Random().NextDouble() <= EXPLOSION_CHANCE)
                        SpawnFarExplosion();
            }

            await Task.FromResult(0);
        }

        private void SpawnFarExplosion()
        {
            Vector3 spawnPos = Utils.GetRandomSpawnPosFromPlayer(LocalPlayer, SpawnerHost.SPAWN_DESPAWN_DISTANCE * 10, SpawnerHost.SPAWN_DESPAWN_DISTANCE * 50);

            if (!Utils.IsPosInRadiusOfAPlayer(Players, spawnPos, SpawnerHost.SPAWN_DESPAWN_DISTANCE * 5))
            {
                Array explosionTypes = Enum.GetValues(typeof(ExplosionType));
                World.AddExplosion(spawnPos, (ExplosionType) explosionTypes.GetValue(new Random().Next(explosionTypes.Length)),
                    0f, 0f, null, true, true);
            }
        }
    }
}
