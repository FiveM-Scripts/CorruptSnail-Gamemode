using CitizenFX.Core;
using CitizenFX.Core.Native;
using CitizenFX.Core.UI;
using System.Threading.Tasks;

namespace CorruptSnail
{
    public class Atmosphere : BaseScript
    {
        public Atmosphere()
        {
            Tick += OnTick;
        }

        private async Task OnTick()
        {
            API.SetWeatherTypeNowPersist("FOGGY");
            World.WeatherTransition = 0f;
            World.Blackout = true;
            LocalPlayer.WantedLevel = 0;

            API.SetVehicleDensityMultiplierThisFrame(0f);
            API.SetParkedVehicleDensityMultiplierThisFrame(0f);
            API.SetRandomVehicleDensityMultiplierThisFrame(0f);
            API.SetPedDensityMultiplierThisFrame(0f);
            API.SetScenarioPedDensityMultiplierThisFrame(0f, 0f);
            //Game.DisableControlThisFrame(0, Control.NextCamera);
            //API.SetFollowPedCamViewMode(4);
            //API.SetFollowVehicleCamViewMode(4);
            Screen.Hud.IsRadarVisible = false;

            await Task.FromResult(0);
        }
    }
}
