using CitizenFX.Core;
using CitizenFX.Core.Native;
using System.Collections.Generic;

namespace CorruptSnail.Util
{
    class EntityEnum
    {
        public static List<Prop> GetProps()
        {
            List<Prop> props = new List<Prop>();
            int entHandle = 0;

            int handle = API.FindFirstObject(ref entHandle);
            Prop prop = (Prop) Entity.FromHandle(entHandle);
            if (prop != null)
                props.Add(prop);

            while (API.FindNextObject(handle, ref entHandle))
            {
                prop = (Prop) Entity.FromHandle(entHandle);
                if (prop != null)
                    props.Add(prop);
            }

            API.EndFindObject(handle);
            return props;
        }

        public static List<Ped> GetPeds()
        {
            List<Ped> peds = new List<Ped>();
            int entHandle = 0;

            int handle = API.FindFirstPed(ref entHandle);
            Ped ped = (Ped) Entity.FromHandle(entHandle);
            if (ped != null)
                peds.Add(ped);

            while (API.FindNextPed(handle, ref entHandle))
            {
                ped = (Ped) Entity.FromHandle(entHandle);
                if (ped != null)
                    peds.Add(ped);
            }

            API.EndFindPed(handle);
            return peds;
        }

        public static List<Vehicle> GetVehicles()
        {
            List<Vehicle> vehs = new List<Vehicle>();
            int entHandle = 0;

            int handle = API.FindFirstVehicle(ref entHandle);
            Vehicle veh = (Vehicle) Entity.FromHandle(entHandle);
            if (veh != null)
                vehs.Add(veh);

            while (API.FindNextVehicle(handle, ref entHandle))
            {
                veh = (Vehicle) Entity.FromHandle(entHandle);
                if (veh != null)
                    vehs.Add(veh);
            }

            API.EndFindVehicle(handle);
            return vehs;
        }

        public static List<Pickup> GetPickups()
        {
            List<Pickup> pickups = new List<Pickup>();
            int entHandle = 0;

            int handle = API.FindFirstPickup(ref entHandle);
            Pickup pickup = new Pickup(entHandle);
            if (pickup != null && pickup.Exists())
                pickups.Add(pickup);

            while (API.FindNextPickup(handle, ref entHandle))
            {
                pickup = new Pickup(entHandle);
                if (pickup != null && pickup.Exists())
                    pickups.Add(pickup);
            }

            API.EndFindPickup(handle);
            return pickups;
        }
    }
}
