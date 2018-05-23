using CitizenFX.Core;
using CitizenFX.Core.Native;

namespace CorruptSnail.Util
{
    class Utils
    {
        public static Vector3 GetRandomSpawnPosFromPlayer(Player player, int minDist, int maxDist)
        {
            Vector3 spawnPos = player.Character.GetOffsetPosition(new Vector3(GetRandomInt(-minDist, minDist),
                GetRandomInt(minDist, maxDist), 0f));
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

        public static int GetRandomInt(int end)
        {
            return API.GetRandomIntInRange(0, end);
        }

        public static int GetRandomInt(int start, int end)
        {
            return API.GetRandomIntInRange(start, end);
        }

        public static float GetRandomFloat(float end)
        {
            return API.GetRandomFloatInRange(0, end);
        }

        public static float GetRandomFloat(float start, float end)
        {
            return API.GetRandomFloatInRange(start, end);
        }
    }
}
