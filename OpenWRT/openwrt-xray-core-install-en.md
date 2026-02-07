# Install xray-core on OpenWrt

Goal: install `xray-core` from a prebuilt `ipk` and run it with `procd`.

> Check the architecture and package version before installing.

## 1) Install the package
```sh
VER="26.1.23"
ARCH="aarch64_generic"   # <-- change for your target

wget -O /tmp/openwrt-xray.ipk "https://github.com/yichya/openwrt-xray/releases/download/v${VER}/openwrt-xray_${VER}-1_${ARCH}.ipk"
opkg install /tmp/openwrt-xray.ipk
```

## 2) Create init script
```sh
cat > /etc/init.d/xray <<'SH'
#!/bin/sh /etc/rc.common
START=99
USE_PROCD=1

start_service() {
  procd_open_instance
  procd_set_param command /usr/bin/xray run -c /etc/xray/config.json
  procd_set_param respawn
  procd_set_param stdout 1
  procd_set_param stderr 1
  procd_close_instance
}
SH
```

## 3) Enable and start
```sh
chmod +x /etc/init.d/xray
/etc/init.d/xray enable
/etc/init.d/xray start
logread -e xray
```
