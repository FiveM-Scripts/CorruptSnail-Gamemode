using CitizenFX.Core;
using CitizenFX.Core.Native;
using System.Threading.Tasks;

namespace CorruptSnail.CPlayer
{
    class Safezones : BaseScript
    {
        private bool inSafezone = false;

        public class Safezone
        {
            public Vector3 Pos { get; private set; }
            public float Range { get; private set; }

            public Safezone(Vector3 pos, float range)
            {
                Pos = pos;
                Range = range;
            }
        }

        public static Safezone[] SAFEZONES { get; } =
        {
            new Safezone(new Vector3(3474, 3681, 34), 250f)
        };

        public Safezones()
        {
            Tick += OnTick;
        }

        private async Task OnTick()
        {
            await Delay(500);

            if (API.NetworkIsSessionStarted() && !API.GetIsLoadingScreenActive())
            {
                Ped playerPed = Game.PlayerPed;
                bool inSafezoneNow = false;

                foreach (Safezone safezone in SAFEZONES)
                    if (World.GetDistance(playerPed.Position, safezone.Pos) < safezone.Range)
                    {
                        inSafezoneNow = true;
                        break;
                    }

                if (inSafezoneNow && !inSafezone)
                {
                    inSafezone = true;
                    TriggerEvent("corruptsnail:inZone", true);
                    TriggerEvent("chatMessage", "", new int[] { 0, 255, 0 }, "\nYou are in a safezone now!\n"
                        + "Zombies will not spawn and you can spawn stuff in the F6 menu.\n");
                }
                else if (!inSafezoneNow && inSafezone)
                {
                    inSafezone = false;
                    TriggerEvent("corruptsnail:inZone", false);
                    TriggerEvent("chatMessage", "", new int[] { 255, 0, 0 }, "\nYou left the safezone!\n"
                        + "Zombies will spawn now and you are unable to spawn stuff.\n");
                }
            }

            await Task.FromResult(0);
        }
    }
}
