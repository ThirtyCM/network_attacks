dns touch dos_np.pcap
dns touch dos_p.pcap

ws2 tshark -w dos_np.pcap &
ws2 python3 attacks/DoS_attack.py 10.1.0.3 -c 50 -s 64000
ws3 pkill tshark

ws3 nft -f protections/dos.nft

ws3 tshark -w dos_p.pcap &
ws2 python3 attacks/DoS_attack.py 10.1.0.3 -c 50 -s 64000
ws2 ping -c 5 ws3
ws3 pkill tshark