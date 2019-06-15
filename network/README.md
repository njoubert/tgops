# TechnoGecko Networking

Niels Joubert, Nate Wennyk, Randy Butera, Gil Shotan, Ken Wells

As TechnoGecko expands, the required networking infrastructure will need to grow in order to accommodate energy controllers, battery management systems, autonomy sensors and compute, audio-visual systems, etc, on each vehicle. Similarly, our communication infrastructure will have to support multiple vehicles interacting in complex ways. Here, we look ahead at our networking infrastructure in order to make smart decisions early that will support multiple vehicles with many diverse capabilities. 

## IP Network Schema [v2.6.1]

At TechnoGecko we:
* Use the `10.0.0.0/8` network.
* Assign IPs according to `10.[Module].[Function].[Device]`
* Strictly avoid duplicate IP addresses anywhere even on different LANs, to ease identification and avoid NAT requirements.
* Generally isolate networks on a per-function and per-module level, to minimize bridge traffic and avoid subtle timing and bandwidth interaction between functions.
* Generally limit routering between networks. Rather connect devices to all relevant networks using multiple ethernet interfaces.
* Generally connect devices with cross-module communication needs directly to bridge networks. 
* Sync timing across vehicles using GPS 1PPS when possible, or a local NTP server

Our network topology contains three types of LANs:
* **Module Networks** define each physical location.
* **Bridge Networks** provide inter-module communication, for example, the vehicle-to-vehicle wireless bridge.
* **Functional Networks** provide communication on a single module for a specific functional capability.

IP Networks:
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


ID   Functional Network*    Function Name      Description
--   -------------------    -------------      -----------
16   10.<module>.16.0/24    energy             Energy Management System
32   10.<module>.32.0/24    otto               Autonomy Capabilities
48   10.<module>.48.0/24    bms                Battery Management System
64   10.<module>.64.0/19    lights             Lighting network

* Note: Spaced to support /19 networks and leaving .0.0 blank for future routing options.
```

### Routers
Vehicle Controller and Energy Controller will provide software 
IP forwarding to connect autonomy switch, energy switch, 
and inter-vehicle switch. 

### Suggestions for device IP assignment:
```
.16-.64           Preferred for gateway to x.0 network where x is 16- 
.100-200          Preferred for Compute and Sensors
.200-250          Default range for DHCP assignments.
```

## Layout

tg::robot Robot network layout

[Draw.io Diagram](https://drive.google.com/file/d/1UimhuNxK7GUXQ43VrYicd7frDcxEkvqW/view?usp=sharing)
![tg::robot network](https://github.com/njoubert/tgops/raw/master/network/TechnoGecko%20Autonomy%20Networking%20Proposal%20v2.6.png)

## SSID Schema

```

    tg::<module>[::<function>]

```
Name each WiFi SSID is names according to the module and the functional LAN of the access point. 

Assigned Wireless SSIDs

```
    tg::robot::energy    - WiFi AP connected to Robot module Energy Switch, 10.1.16.0/24
    tg::robot::otto      - WiFi AP to access Robot module autonomy sensors and compute directly, 10.1.32.0/24
    tg::lightbridge      - WiFi AP connecting to the lighting bridge network 10.64.0.0/16
```

## Default Credentials

```
user: gecko
pass: techno
```

# Changelog

```
# CHANGELOG

## [v2.6.1] - 2019-06-15
- Split into Bridge and Module networks
- Add lights and lightbridge

## [v2.6.0] - 2019-06-14
- Initial import from https://docs.google.com/document/d/1cDzG_v06vcvpfKeqd4Cd5LlTE_7ObD4nFI7MDEt6ZM0/edit#