If you are happy owner of Mikrotik router and want to set up GRE tunnel:

```shell
cp compute/vpn/gre.env.example compute/vpn/gre.env
```

Fill in your router's remote address as `GRE_REMOTE_IP`, for a GRE tunnel you should have static white IP address on the
router.

```shell
(cd compute/vpn && ./configure generate && ./configure run gre)
```

After that you might need to reboot your Oracle linux machine.

SSH to Mikrotik and type:

```shell
/interface gre add name=gre-tunnel1 remote-address={{oracle-static-ip}} local-address={{your-static-ip}} keepalive=10s,10 clamp-tcp-mss=yes
/ip address add address=192.168.0.2/24 interface=gre-tunnel1
/ip route add dst-address=192.168.0.0/24 gateway=gre-tunnel1
```

Try to ping through the tunnel both ways IPs 192.168.0.1 and 192.168.0.2. If everything works then tunnel works as well.
Now it's time to set up BGP dynamic routing to pass through tunnel only blocked prefixes:

```shell
/ip route add dst-address=45.154.73.71/32 gateway=gre-tunnel1 comment=antifilter.download
/routing bgp instance set default as=64512 ignore-as-path-len=yes router-id=91.202.27.243
/routing bgp peer add hold-time=4m in-filter=bgp_in keepalive-time=1m multihop=yes name=antifilter remote-address=45.154.73.71 remote-as=65432 ttl=default
/routing filter add action=accept chain=bgp_in comment="Set nexthop to VPN" set-in-nexthop-direct=gre-tunnel1
```

Here are the posts for more info:
[Настройка BGP для обхода блокировок, или «Как я перестал бояться и полюбил РКН»](https://habr.com/ru/post/354282/)
[Настройка BGP для обхода блокировок, версия 2, «не думать»](https://habr.com/ru/post/359268/)
[Настройка BGP для обхода блокировок, версия 3, без VPS](https://habr.com/ru/post/413049/)
[Настройка BGP для обхода блокировок, версия 3.1. И немного Q&A](https://habr.com/ru/post/549282/)
