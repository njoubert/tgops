# TechnoGecko IP Address Network Schema

* Use the 10.x.x.x Class A IP address range. 
* Assign IPs according to 10.[Module].[Function].[Device].
* Strictly avoid reusing IP addresses anywhere: avoid future network address translation nightmares.
* Generally, use /24 subnets for each network and /16 subnets for each location.
* Generally, isolate networks on a per-function and per-subnet level.
* Generally, limit hardware routers between networks. Rather connect devices to all relevant networks using multiple ethernet interfaces, and optionally provide software routing.
* Provide a vehicle-to-vehicle high speed short range wireless backbone. 
* Sync timing across vehicles using GPS 1PPS when available, fallback to local NTP server

```
# Modules (Vehicles):

   10.0.0.0/16        Camp/Whale
   10.1.0.0/16        Robot vehicle
   10.2.0.0/16        Dancefloor vehicle
   ...                <future vehicles>
   10.254.0.0/16      Vehicle-to-Vehicle highest speed backbone

# Networks for each Vehicle Function:

Spaced to support future /19 networks and leaving .0.0 blank.
   10.<module>.16.0/24    Energy Management System
   10.<module>.32.0/24    Autonomy Capabilities
   10.<module>.48.0/24    Battery Management System
   ...                    <future functionality>
   10.254.<module>.0/16   Vehicle-to-Vehicle backbone

# Routers

Vehicle Controller and Energy Controller will provide low-bandwidth IP forwarding to connect autonomy switch, energy switch, and inter-vehicle switch. 

Suggestions for device IP assignment:
   .16-.64           Preferred for gateway to x.0 network where x is 16- 
   .100-200          Preferred for Compute and Sensors
   .200-250          Default range for DHCP assignments.
```
