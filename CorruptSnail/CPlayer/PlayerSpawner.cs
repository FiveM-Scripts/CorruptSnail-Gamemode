using CitizenFX.Core;
using System;

namespace CorruptSnail.CPlayer
{
    class PlayerSpawner : BaseScript
    {
        public PlayerSpawner()
        {
            EventHandlers["playerSpawned"] += new Action(SpawnPlayer);
        }

        private void SpawnPlayer()
        {
            Game.PlayerPed.Position = Safezones.SAFEZONES[0].Pos;
        }
    }
}
