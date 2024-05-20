# eltexrus
**IP**  
isp 1.1.1.1/30 (2001:1::1/64) 2.2.2.1/30 (2001:2::1/64) 3.3.3.1/30 (2001:3::1/64)
cli 3.3.3.2/30 (2001:3::2/64)  
hq-r gi1/0/1 1.1.1.2/30 (2001:1::2/64) gi1/0/2 192.168.100.1/26 (2000:192::1/122) tun1 10.10.10.1/30 (2001:10::1/64)  
hq-srv dhcp  
br-r 2.2.2.2/30 (2001:2::2/64) 172.16.100.1/28 (2000:172::1/124) tun1 10.10.10.2/30 (2001:10::2/64)   
br-srv 172.16.100.2/28 (2000:172::2/124)  
hq-cli dhcp - hq-ad 192.168.100.3/28 (2000:192::3/122)  
**BR-SRV**  
hostnamectl set-hostname BR-SRV  
exec bash .echo 172.16.100.2/28 > /etc/net/ifaces/ens192/ipv4address  
echo default via 172.16.100.1 > /etc/net/ifaces/ens192/ipv4route  
echo nameserver 192.168.100.2 > /etc/net/ifaces/ens192/resolf.conf  
systemctl restart network  
ip a - ping 172.16.100.1   
**NAT**   
hq-r - object-group network LOCAL_NET  
ip address-range 192.168.100.1-192.168.100.62 (172.16.100.1-14)  
exit  
object-group network PUBLIC_POOL  
ip address-range 1.1.1.2 (2.2.2.2)  
exit  
nat source  
pool TRANSLATE_ADDRESS  
ip address-range 1.1.1.2 (2.2.2.2)  
exit  
ruleset SNAT   
to interface gi1/0/1   
rule 1  
match source-address LOCAL_NET  
action source-nat pool TRANSLATE_ADDRESS  
enable - exit - exit - commit - confirm - ip route 0.0.0.0/0 1.1.1.1 (2.2.2.1) - check ping 8.8.8.8 source ip 192.168.100.1  
**DHCP**    
hq-srv - vim /etc/ifaces/ens192/options (dhcp) -esc-:wq .
dhcp hq-r   
ip dhcp-server    
ip dhcp-server pool SIMPLE  
network 192.168.100.0/26   
address-range 192.168.100.1-192.168.100.62  
excluded-address-range 192.168.100.1  
