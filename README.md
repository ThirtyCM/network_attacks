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
* They come from another DMZ server
* It is a ping (ICMP echo-request)
* The packet is part of an already established connection or asking to create a new one
#### Output hook
DMZ servers will only send these packets :
* Packets destinated towards other DMZ servers
* ICMP echo-reply (to respond to pings)
* Packets that are part of an established connection (such that DMZ servers cannot create new ones)

## Attacks
### Port scanning
Discover which ports are open.
> host python3 attacks/port_scan.py <target_ip> -p <port_range> -m syn --banner

Where:
 * <mode>: scan type (syn, null, fin, ack, xmas, etc.)
 * <port_range>: comma separated values (list) / 2 values separated by an hyphen (range)

### DoS Attack
It throws giant fragmented ICMP packets to cause crashes or flooding.
 > host python3 attacks/DoS_attack.py <target_ip> -c <ping_count>

### SYN Flood
Saturate a server's port 80 with SYN requests.
> host python3 attacks/SYN_flood.py <target_ip> -t <thread_number> -r <rate/thread>

 ### DDoS attack
 Send a burst of UDP or TCP packets from fake addresses.

 > host python3 attacks/DDoS_attack.py --proto <protocol> <target_ip> <target_port> -s <packet_size> -d <duration (seconds)> 

 ## Attack protections
 Protections can be deployed on an host by executing this command: 
 
 > host nft -f protections/script

 Where script is:
* ddos.nft -> protects the host against the DDoS attack
* dos.nft -> protects the host against the DoS attack
* flood.nft -> protects the host against the SYN flood attack
* scan.nft -> protects the host again the scan
