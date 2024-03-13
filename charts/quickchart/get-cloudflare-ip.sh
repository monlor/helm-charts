#!/bin/sh

ip4=$(curl -s https://www.cloudflare.com/ips-v4 | tr '\n' ',')
ip6=$(curl -s https://www.cloudflare.com/ips-v6 | tr '\n' ',')

echo "${ip4}","${ip6}"