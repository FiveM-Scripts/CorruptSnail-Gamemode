using CitizenFX.Core;
using CitizenFX.Core.Native;
using System;

namespace CorruptSnail
{
    class TimeSync : BaseScript
    {
        public TimeSync()
        {
            EventHandlers["playerSpawned"] += new Action(delegate {
                int h = 0; int m = 0; int s = 0;
                API.NetworkGetServerTime(ref h, ref m, ref s);
                API.NetworkOverrideClockTime(h, m, s);
            });
        }
    }
}
