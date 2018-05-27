using CitizenFX.Core;
using CitizenFX.Core.Native;
using CorruptSnail.CPlayer;
using CorruptSnail.Util;
using System.Threading.Tasks;

namespace CorruptSnail.Spawners
{
    class SpawnerHost : BaseScript
    {
        public const float SPAWN_MIN_DISTANCE = 100f;
        public const float SPAWN_DESPAWN_DISTANCE = 350f;
        public const double SPAWN_EVENT_CHANCE = 0.005;
        public const int SPAWN_TICK_RATE = 100;
        public const string SPAWN_DESPAWN_DECOR = "_MARKED_FOR_DESPAWN";
        private const float SPAWN_HOST_DECIDE_DISTANCE = 500f;

        public static bool IsHost { get; private set; }

        public SpawnerHost()
        {
            IsHost = false;

            EntityDecoration.RegisterProperty(SPAWN_DESPAWN_DECOR, DecorationType.Bool);
            Tick += OnTick;
        }

        private async Task OnTick()
        {
            await Delay(SPAWN_TICK_RATE);

            if (API.NetworkIsSessionStarted() && !API.GetIsLoadingScreenActive())
            {
                Ped playerPed = Game.PlayerPed;
                bool isNewHost = false;
                bool isNearSafezone = false;
                foreach (Safezones.Safezone safezone in Safezones.SAFEZONES)
                    if (World.GetDistance(playerPed.Position, safezone.Pos) < safezone.Range)
                    {
                        isNearSafezone = true;
                        break;
                    }

                if (!isNearSafezone)
                {
                    int lowestServerId = int.MaxValue;
                    foreach (Player player in Players)
                        if (player.Character != null && player.ServerId != Game.Player.ServerId
                            && World.GetDistance(playerPed.Position, player.Character.Position) < SPAWN_HOST_DECIDE_DISTANCE)
                            if (player.ServerId < lowestServerId)
                                lowestServerId = player.ServerId;

                    isNewHost = Game.Player.ServerId < lowestServerId;
                }

                if (isNewHost && !IsHost)
                    Debug.WriteLine("SPAWNER_HOST");
                else if (!isNewHost && IsHost)
                    Debug.WriteLine("SPAWNER_SLAVE");
                IsHost = isNewHost;
            }
        }

        public static bool CanEventTrigger()
        {
            return IsHost && Utils.GetRandomFloat(1f) <= SPAWN_EVENT_CHANCE;
        }
    }
}
