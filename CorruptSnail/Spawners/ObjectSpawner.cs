using CitizenFX.Core;
using CitizenFX.Core.Native;
using CorruptSnail.Util;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CorruptSnail.Spawners
{
    class ObjectSpawner : BaseScript
    {
        private const int OBJECT_AMOUNT = 5;
        private static string[] OBSTACLE_LIST { get; } = { "prop_rub_buswreck_01", "prop_rub_buswreck_03", "prop_rub_buswreck_06", "prop_rub_railwreck_1",
            "prop_rub_railwreck_2", "prop_rub_railwreck_3", "prop_rub_trukwreck_1", "prop_rub_trukwreck_2", "prop_rub_wreckage_3", "prop_rub_wreckage_4",
            "prop_rub_wreckage_5", "prop_rub_wreckage_6", "prop_rub_wreckage_7", "prop_rub_wreckage_8", "prop_rub_wreckage_9" };

        private List<Prop> obstacles;

        public ObjectSpawner()
        {
            obstacles = new List<Prop>();

            Tick += OnTick;
        }

        private async Task OnTick()
        {
            await Delay(SpawnerHost.SPAWN_TICK_RATE);

            if (SpawnerHost.IsHost && obstacles.Count < OBJECT_AMOUNT)
                SpawnRandomObstacle();
            else if (obstacles.Count > 0)
                foreach (Prop obstacle in obstacles.ToArray())
                    if (!Utils.IsPosShitSpawn(Players, obstacle.Position, SpawnerHost.SPAWN_DESPAWN_DISTANCE))
                    {
                        obstacle.SetDecor(SpawnerHost.SPAWN_DESPAWN_DECOR, true);
                        obstacles.Remove(obstacle);
                    }
        }

        private async void SpawnRandomObstacle()
        {
            Vector3 spawnPos = Utils.GetRandomSpawnPosFromPlayer(Game.Player, SpawnerHost.SPAWN_MIN_DISTANCE, SpawnerHost.SPAWN_DESPAWN_DISTANCE);
            spawnPos.Z -= 3;

            if (!Utils.IsPosShitSpawn(Players, spawnPos, SpawnerHost.SPAWN_MIN_DISTANCE))
            {
                Prop obstacle = await EntityUtil.CreateProp(API.GetHashKey(OBSTACLE_LIST[Utils.GetRandomInt(OBSTACLE_LIST.Length)]), spawnPos, false, true);
                obstacle.IsPositionFrozen = true;

                obstacles.Add(obstacle);
            }
        }
    }
}
