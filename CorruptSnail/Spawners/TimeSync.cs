using CitizenFX.Core;
using System;

namespace CorruptSnail.Spawners
{
    class TimeSync : BaseScript
    {
        private bool synced = false;

        public TimeSync()
        {
            EventHandlers["playerSpawned"] += new Action(delegate {
                if (!synced)
                    TriggerServerEvent("corruptsnail:timeSync");
                else
                {
                    TimeSpan currentTime = World.CurrentDayTime;
                    TriggerServerEvent("corruptsnail:updateTime", currentTime.Hours, currentTime.Minutes, currentTime.Seconds);
                }
            });

            EventHandlers["corruptsnail:client:timeSync"] += new Action<int, int, int>((timeH, timeM, timeS) =>
            {
                World.CurrentDayTime = new TimeSpan(timeH, timeM, timeS);
                synced = true;
            });
        }
    }
}
