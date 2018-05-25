using CitizenFX.Core;
using CitizenFX.Core.Native;
using CorruptSnail.Util;
using System.Threading.Tasks;

namespace CorruptSnail.Spawners
{
    class SpawnerHost : BaseScript
    {
        public const int SPAWN_MIN_DISTANCE = 100;
        public const int SPAWN_DESPAWN_DISTANCE = 500;
        public const double SPAWN_EVENT_CHANCE = 0.0005;
        private const int SPAWN_HOST_DECIDE_DISTANCE = 500;

        public static bool IsHost { get; private set; }

        public SpawnerHost()
        {
            IsHost = false;

            Tick += OnTick;
        }

        private async Task OnTick()
        {
            if (API.NetworkIsSessionStarted() && !API.GetIsLoadingScreenActive())
            {
                Ped playerPed = LocalPlayer.Character;
                int lowestServerId = int.MaxValue;
                foreach (Player player in Players)
                    if (player.Character != null && player.ServerId != LocalPlayer.ServerId
                        && World.GetDistance(playerPed.Position, player.Character.Position) < SPAWN_HOST_DECIDE_DISTANCE)
                        if (player.ServerId < lowestServerId)
                            lowestServerId = player.ServerId;

                bool IsNewHost = LocalPlayer.ServerId < lowestServerId;
                if (IsNewHost && !IsHost)
                    Debug.WriteLine("SPAWNER_HOST");
                else if (!IsNewHost && IsHost)
                    Debug.WriteLine("SPAWNER_SLAVE");
                IsHost = IsNewHost;
            }

            await Task.FromResult(0);
        }

        public static bool CanEventTrigger()
        {
            return IsHost && Utils.GetRandomFloat(1f) <= SPAWN_EVENT_CHANCE;
        }
    }
}
