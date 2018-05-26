using CitizenFX.Core;
using CitizenFX.Core.Native;
using CorruptSnail.Util;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CorruptSnail.Spawners
{
    class WeaponSpawner : BaseScript
    {
        private const int WEAPON_AMOUNT = 10;
        private const int WEAPON_MAXAMMO = 100;
        private static PickupType[] WEAPON_LIST { get; } = { PickupType.WeaponBat, PickupType.WeaponCrowbar,
            PickupType.WeaponKnife, PickupType.WeaponSNSPistol, PickupType.WeaponMicroSMG, PickupType.WeaponPistol,
            PickupType.WeaponAssaultRifle, PickupType.WeaponSMG,  PickupType.WeaponCarbineRifle, PickupType.WeaponRPG,
            PickupType.WeaponGrenade, PickupType.WeaponGrenadeLauncher };

        private List<int> weapons;

        public WeaponSpawner()
        {
            weapons = new List<int>();

            //Tick += OnTick;
        }

        private async Task OnTick()
        {
            await Delay(SpawnerHost.SPAWN_TICK_RATE);

            if (SpawnerHost.IsHost && weapons.Count < WEAPON_AMOUNT)
                SpawnRandomWeapon();
            else if (weapons.Count > 0)
                for (int i = weapons.Count - 1; i > 0; i--)
                {
                    int obj = weapons[i];
                    if (!Utils.IsPosShitSpawn(Players, API.GetEntityCoords(obj, false), SpawnerHost.SPAWN_DESPAWN_DISTANCE))
                    {
                        API.DeleteObject(ref obj);
                        weapons.Remove(obj);
                    }
                }
        }

        private void SpawnRandomWeapon()
        {
            Vector3 spawnPos = Utils.GetRandomSpawnPosFromPlayer(Game.Player, SpawnerHost.SPAWN_MIN_DISTANCE, SpawnerHost.SPAWN_DESPAWN_DISTANCE);

            if (!Utils.IsPosShitSpawn(Players, spawnPos, SpawnerHost.SPAWN_MIN_DISTANCE))
            {
                uint modelHash = (uint) WEAPON_LIST[Utils.GetRandomInt(WEAPON_LIST.Length)];
               /* while (!API.HasWeaponAssetLoaded(modelHash))
                {
                    await Delay(1);
                    API.RequestWeaponAsset(modelHash, 31, 0);
                }*/
                int obj = API.CreateWeaponObject(modelHash, Utils.GetRandomInt(WEAPON_MAXAMMO),
                    spawnPos.X, spawnPos.Y, spawnPos.Z, true, Utils.GetRandomFloat(360f), 1);
                weapons.Add(obj);
            }
        }
    }
}
