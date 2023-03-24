# SusiRoller - Snips/Rhasspy Skill

Simple skill to move roller shutters up and down with voice commands with a
Snips-like home assistant (i.e. Rhasspy).     
The skill is written in Julia with the HermesMQTT.jl framework.

### Julia

This skill is (like the entire HermesMQTT.jl framework) written in the
modern programming language Julia (because Julia is faster
then Python and coding is much much easier and much more straight forward).
However "Pythonians" often need some time to get familiar with Julia.

If you are ready for the step forward, start here: https://julialang.org/

Learn more about writing skills in Julia with HermesMQTT.jl here: 
 [![](https://img.shields.io/badge/docs-latest-blue.svg)](https://andreasdominik.github.io/HermesMQTT.jl/dev)



## Installation

The skill can be installed from within the Julia REPL with the following
commands, if the HermesMQTT.jl framework is already installed 
and configured:

```julia
using HermesMQTT

install("SusiRoller")
```

If the Rhasspy server is running (recommended) the installer will
install the skill on the local machine and upload intents and slots
to the Rhasspy server (locally or remote in a server-satellite setup).

## Usage

Basic idea is to configure roller shutters in different rooms of the house 
in the config.ini file. 
Then the skill can be used to move the rollers in a room by voice command.



## Device definitions

All available roller shutters are defined in the config.ini file 
in the line `devices`:
```ini
devices = roller_big, roller_living_1, roller_living_2, roller_kichen
```

For each `device` up to 3 lines define its properties:

```ini
<name>:driver = driver, param1, param2, ...
```
The number of params depend on the driver. For the *shelly2.5* driver
the additional parameter *ip-address* and optional username and password
are required.

```ini
<name>:positions = 100, 60, 0
```
This optional line defines the positions of the roller shutter in percent for
*open*, *half-open* and *closed*.
If missing, the default values are 100, 50 and 0.

```ini
<name>:room = site_ID
```

Intent and device definitions rely on the same room names, defined
as slot list `rooms` by the *HermesMQTT* framework.

Make sure, that room-names match with site-IDs in a server-satellite Rhasspy
setup. In this case the skill will firstly try to get a room name from the
voice command. If missing (e.g. *"close the roller"*), the site-ID of the
satellite on which the command is recorded will be used as room name with the
result that always the devices in the current room will be moved.


### Example config.ini file:

```ini
devices = roller_big, roller_small, roller_kitchen

roller_big:driver = shelly2.5, 192.168.0.100, rhasspy, my_passwd
roller_big:positions = 100, 48, 0
roller_big:room = livingroom

roller_small:driver = shelly2.5, 192.168.0.101, rhasspy, my_passwd
roller_small:positions = 80, 60, 10
roller_small:room = livingroom

roller_kitchen:driver = shelly2.5, 192.168.0.102, rhasspy, my_passwd
roller_kitchen:positions = 100, 50, 0
roller_kitchen:room = kitchen
```

## Drivers
### Shelly devices

Only Shelly 2.5 actors are supported at the moment.


### Other drivers

Other hardware drivers may be added easily as long as they can be 
controlled via http or MQTT requests. 

Because the shelly devices are are low-price, easy to use and 
cloud-free, the autor of this skill discontinued to use other hardware. But
if somebody has an installation with Hue, Ikea or other frameworks, please 
contact me and we can easily add a driver for your hardware 
(if you help with testing ;-).

## Slots

The skill uses slots of the *HermesMQTT* framework to define the rooms.
Devices are defined in the intent (located in the `profiles` subdirectory
of the repository).

## Intents

### Susi:RollerUpDown
Open or close a roller shutter in a specified room or in the current room
(i.e. *please close the roller in the kitchen* or *please close the roller*).

### Susi:RollerHalf
Set the roller to the half-opened position as defined in the config.ini file.

### Susi:RollerAll
Open or close all roller shutters in the house.

