# Proxy V6 Creator Project

## Requirements

:white_check_mark: Centos 7 Without Selinux
:white_check_mark: Enable Ipv6 \64

:point_right:  [Working on Vultr VPS, get $100 free here :gift: ](https://www.vultr.com/?ref=9001246-8H)

## Installation

:one: `sudo yum -y install epel-release`

:two: `sudo yum -y update`

:three: `sudo bash <(curl -s "https://raw.githubusercontent.com/linucat/proxyv6/main/install.sh")`

> [!TIP] 
> :question: "How many proxy do you want to create? Example 500" <br>
> :white_check_mark: **500** (depends on you)

> [!WARNING]
> Port starts from **10001**, if you create **500** proxies, the range will be **10001 - 10500**

:four:  `sudo reboot`

## Add Proxies

:one: `sudo bash <(curl -s "https://raw.githubusercontent.com/linucat/proxyv6/main/addproxy.sh")`

> [!TIP] 
> :question: "Which port do you want to start from?: Example 10501"
> :white_check_mark: **10501**
> :question: "How many proxy do you want to create? Example 100"
> :white_check_mark: **100**

:two: `sudo reboot`

## Change Proxy Password

:one: Change password in the file **`/home/proxy-installer/data.txt`**
:two: `sudo bash <(curl -s "https://raw.githubusercontent.com/linucat/proxyv6/main/update.sh")`
:three: `sudo reboot`

## Delete a Proxy

:one: Delete line belong to the proxy in the file **`/home/proxy-installer/data.txt`**
:two: `sudo bash <(curl -s "https://raw.githubusercontent.com/linucat/proxyv6/main/update.sh")`
:three: `sudo reboot`

## Download Proxy List

:white_check_mark: Proxy list is stored in **`/home/proxy-installer/proxy.txt`**
:white_check_mark: File structure: **`IP4:PORT:LOGIN:PASS`**

:point_right: If you need support, contact me @[Telegram](https://t.me/+aWqfCqk9VL41MDBl)

<br>
The source : 3proxy
