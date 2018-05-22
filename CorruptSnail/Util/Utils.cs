using CitizenFX.Core;
using System;

namespace CorruptSnail.Util
{
    class Utils
    {
        public static Vector3 GetRandomSpawnPosFromPlayer(Player player, int minDist, int maxDist)
        {
            Random random = new Random();
            Vector3 spawnPos = player.Character.GetOffsetPosition(new Vector3(random.Next(-minDist, minDist),
                random.Next(minDist, maxDist), 0f));
            spawnPos.Z = World.GetGroundHeight(spawnPos);
            return spawnPos;
        }

        public static bool IsPosInRadiusOfAPlayer(PlayerList playerList, Vector3 pos, int radius)
        {
            foreach (Player player in playerList)
                if (player.Character != null && World.GetDistance(player.Character.Position, pos) < radius)
                    return true;

            return false;
        }
    }
}
