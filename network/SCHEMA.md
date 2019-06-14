# TechnoGecko Network Schema

## IP Networks v2.6.1

At TechnoGecko we:
* Use the 10.x.x.x network.
* Assign IPs according to `10.[Module].[Function].[Device]`
* Strictly avoid duplicate IP addresses anywhere even on different LANs, to ease identification and avoid NAT requirements.

Our LAN topology contains three types of networks:
* **Module Networks** define each physical location.
* **Bridge Networks** provide inter-module communication, such as the vehicle-to-vehicle bridge.
* **Functional Networks** provide communication on a single module for a specific functional capability.

On principle, we:
* Generally use /24 subnets for each network and /16 subnets for each module.
* Generally isolate networks on a per-function and per-subnet level. This minimizes traffic between networks and isolates timing-sensitive and bandwidth-intensive sensors.
* Generally limit hardware routers between networks. Rather connect devices to all relevant networks using multiple ethernet interfaces, and optionally provide software routing.
* Generally connect devices with cross-module communication requirements directly to bridge networks. 
* Sync timing across vehicles using GPS 1PPS when available, fallback to local NTP server


```
ID   Module Network         Module Name        Description
--   --------------         -----------        -----------
0    10.0.0.0/16            whale              Camp/Whale
1    10.1.0.0/16            robot              Robot vehicle
2    10.2.0.0/16            dancefloor         Dancefloor vehicle


ID   Bridge Network         Bridge Name        Description
--   ---------------        -----------        -----------
64   10.64.0.0/16           lightbridge        Lighting-specific bridge including wearable access
254  10.254.0.0/16          bridge             High speed short range backbone

ID   Functional Network     Function Name      Description
--   -------------------    -------------      -----------
16   10.<module>.16.0/24    energy             Energy Management System
32   10.<module>.32.0/24    otto               Autonomy Capabilities
48   10.<module>.48.0/24    bms                Battery Management System
64   10.<module>.64.0/19    lights             Lighting network

** Note: Spaced to support /19 networks and leaving .0.0 blank.
```

### Routers
Vehicle Controller and Energy Controller will provide low-bandwidth 
IP forwarding to connect autonomy switch, energy switch, 
and inter-vehicle switch. 

### Suggestions for device IP assignment:
```
.16-.64           Preferred for gateway to x.0 network where x is 16- 
.100-200          Preferred for Compute and Sensors
.200-250          Default range for DHCP assignments.
```

## SSID Schema

```

    tg::<module>[::<function>]

```
Name each WiFi SSID is names according to the module and the functional LAN of the access point. 

eg:

```
    tg::robot::energy    - Wifi Access Point connected to Energy Switch, 10.1.16.0/24
    tg::robot::otto      - WiFi 
    tg::lightbridge      - WiFi AP connecting to the lighting bridge network
```

## Default Credentials

```

```

# Changelog

```
# CHANGELOG

## [2.6.1] - 2019-06-15
- Split into Bridge and Module networks
- Add lights and lightbridge

## [2.6.0] - 2019-06-14
- Initial import from https://docs.google.com/document/d/1cDzG_v06vcvpfKeqd4Cd5LlTE_7ObD4nFI7MDEt6ZM0/edit#