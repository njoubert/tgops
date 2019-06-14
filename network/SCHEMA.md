# TechnoGecko Network Schema

## IP Networks

```
# IP Networks

* Use the 10.x.x.x network.
* Assign IPs according to 10.[Module].[Function].[Device] 
* Isolate devices and networks by function, then by module.
* Cross-module devices use the special vehicle-to-vehicle “bridge” 10.254.0.0/16 wireless backbone network.
* Strictly avoid reusing IP addresses anywhere: avoid future network address translation nightmares.
* Generally, use /24 subnets for each network and /16 subnets for each location.
* Generally, isolate networks on a per-function and per-subnet level.
* Generally, limit hardware routers between networks. Rather connect devices to all relevant networks using multiple ethernet interfaces, and optionally provide software routing.
* Sync timing across vehicles using GPS 1PPS when available, fallback to local NTP server

Module Networks        Module Name        Description
---------------        -----------        -----------
10.0.0.0/16            whale              Camp/Whale
10.1.0.0/16            robot              Robot vehicle
10.2.0.0/16            dancefloor         Dancefloor vehicle

Bridge Networks        Bridge Name        Description
---------------        -----------        -----------
10.64.0.0/16           lightbridge        Vehicle-to-Vehicle lighting-specific bridge
10.254.0.0/16          bridge             Vehicle-to-Vehicle highest speed backbone

Functional Networks    Function Name      Description
-------------------    -------------      -----------
** Note: These are isolated and identical networks that appear on (mostly) every module
** Note: Spaced to support /19 networks and leaving .0.0 blank.
10.<module>.16.0/24    energy             Energy Management System
10.<module>.32.0/24    otto               Autonomy Capabilities
10.<module>.48.0/24    bms                Battery Management System
10.<module>.64.0/19    lights             Lighting network
 
Routers
-------
Vehicle Controller and Energy Controller will provide low-bandwidth 
IP forwarding to connect autonomy switch, energy switch, 
and inter-vehicle switch. 

Suggestions for device IP assignment:
------------------------------------
.16-.64           Preferred for gateway to x.0 network where x is 16- 
.100-200          Preferred for Compute and Sensors
.200-250          Default range for DHCP assignments.
```

## SSID Schema

```
# SSID Schema

    tg::<module>::<function>

Name each WiFi SSID is names according to the module and the functional LAN 
of the access point. 

eg:

    tg::robot::energy    - Wifi Access Point connected to Energy Switch, 10.1.16.0/24
    tg::robot::otto      - WiFi 
    tg::lightbridge      - WiFi AP connecting to the lighting bridge network

```


# Changelog

```
# CHANGELOG

## [1.0.1] - 2019-06-15
- Split into Bridge and Module networks
- Add light

## [1.0.0] - 2019-06-14
- Initial layout