# Network attacks report

## Initialization
Once mininet is running, you can setup the basic network protection by running the script **basic_setup.sh** with the command :
> source basic_setup.sh

To remove all protection rules, simply run **flush.sh** :
> source flush.sh

## Basic network protection
This protection works by setting up a firewall on each workstations and DMZ servers.
### Workstation protection
#### Input hook
Worksations will drop every packet they receives and only accepts the followings :
* Packets from inside the workstation subnetwork (ie:10.1.0.0/24)
* Packets from established connections (such that nobody from outside the workstation subnetwork can establish new connections)
* ICMP packets of type echo-reply (to receive ping responses from outside the workstation subnetwork)

#### Output hook
Workstations will send packets if :
* The destination is inside the workstation subnetwork
* Packets to establish new connections or from already established connections (to create new connections or use established one outside the workstation subnetwork)
* ICMP packets of type echo-request (to send pings outside the workstation subnetwork)
### DMZ servers protection
#### Input hook
DMZ servers will only receive packets if :
* It is a ping (ICMP echo-request)
* The packet is part of an already established connection or asking to create a new one
#### Output hook
DMZ servers will only send these packets :
* ICMP echo-reply (to respond to pings)
* Packets that are part of an established connection (such that DMZ servers cannot create new ones)
