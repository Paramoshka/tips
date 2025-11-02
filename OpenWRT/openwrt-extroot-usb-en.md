# Expanding OpenWrt Storage with **Extroot** (USB/SD)

This guide shows how to move the `/overlay` partition to a USB flash drive or SD card (extroot) so you have plenty of free space for `opkg` packages and configs.

> ⚠️ **Warning**: partitioning and formatting **erases all data** on the chosen device. Run commands one by one and double‑check the device path (e.g., `/dev/sda`).

---

## 0) Prerequisites
- A router with USB/SD.
- A blank flash drive (4–32 GB is more than enough).
- SSH access.
- Packages: `kmod-usb-storage`, `kmod-fs-ext4`, `block-mount`, `e2fsprogs`.  
  (Sometimes also `kmod-usb2` and/or `kmod-usb3` depending on your hardware.)

If you’re short on space, temporarily remove something small (e.g., an extra LuCI theme/locale):
```sh
opkg remove --autoremove luci-theme-argon luci-i18n-*-*
```

Install the required packages:
```sh
opkg update
opkg install kmod-usb-storage kmod-fs-ext4 block-mount e2fsprogs
# if needed (your controller):
opkg install kmod-usb2 kmod-usb3
```

Verify that the flash drive is detected:
```sh
dmesg | tail -n 50
block info
```

---

## 1) Backup your configs (recommended)
```sh
sysupgrade -b /tmp/backup-$(date +%F).tar.gz
# download the archive from the router (scp/LuCI)
```

---

## 2) Partition the flash drive (MBR/DOS)
We’ll use the classic MBR partition table (most compatible). **Replace `/dev/sda` with your disk!**
```sh
fdisk /dev/sda
# inside fdisk:
#   o    (create a new MBR/DOS partition table)
#   n    (new partition)
#   p    (primary)
#   1    (number 1)
#   Enter (default start)
#   Enter (use the rest of the disk)
#   w    (write changes)
```

If fdisk complains about leftover GPT/MBR, wipe the beginning and retry:
```sh
dd if=/dev/zero of=/dev/sda bs=1M count=4
```

---

## 3) Format (ext4) and mount temporarily
```sh
mkfs.ext4 -L overlay /dev/sda1

mkdir -p /mnt/usb
mount /dev/sda1 /mnt/usb
```

> 💡 You can use **f2fs** for flash media (requires `kmod-fs-f2fs` and `mkfs.f2fs`). This guide uses ext4 for simplicity.

---

## 4) Copy the current `/overlay` to the flash drive
```sh
tar -C /overlay -cpf - . | tar -C /mnt/usb -xpf -
sync
```

Confirm the files are present on the flash drive (e.g., list `/mnt/usb/etc`).

---

## 5) Configure auto‑mount as `/overlay`
Generate `fstab` and get the device UUID:
```sh
block detect > /etc/config/fstab
block info | grep /dev/sda1

# robust one-liner to extract UUID:
UUID="$(block info | awk -F 'UUID=\"|\"' '/\/dev\/sda1/ {print $2}')"
echo "$UUID"
```

Add a mount section for `/overlay` using UCI:
```sh
uci add fstab mount
uci set fstab.@mount[-1].target='/overlay'
uci set fstab.@mount[-1].uuid="$UUID"
uci set fstab.@mount[-1].fstype='ext4'
uci set fstab.@mount[-1].options='rw,noatime,nodiratime'
uci set fstab.@mount[-1].enabled='1'
uci commit fstab

# optional: enable filesystem check on boot
uci set fstab.global.check_fs='1'
uci commit fstab
```

> Note: after `block detect` you may see a section with `target '/mnt/usb'` and `enabled '0'` — that’s fine. We **add** a new section for `/overlay`.

---

## 6) Reboot and verify
```sh
reboot
```

After boot:
```sh
mount | grep overlay
df -hT
```
You should see something like:
```
/dev/sda1 on /overlay type ext4 (...)
overlayfs:/overlay on / type overlay (...)
```
and **gigabytes** of free space.

---

## 7) Use it: install packages (example: sing-box)
```sh
opkg update
opkg install sing-box-tiny

# optional:
/etc/init.d/sing-box enable
/etc/init.d/sing-box start
sing-box version
```

If `opkg` drops new configs alongside yours (with `-opkg` suffix):
```text
/etc/config/sing-box-opkg
/etc/sing-box/config.json-opkg
```
decide whether to keep your current configs, switch to the new defaults, or merge changes (`diff -u ...`).

---

## 8) Tuning & maintenance (optional)
- Improve reliability / reduce wear:
  ```sh
  # remove 'sync' and add error protection:
  idx="$(uci show fstab | awk -F'[][]' '/@mount\\[[0-9]+\\]\\.target='\''\\/overlay'\''/ {print $2; exit}')"
  uci set fstab.@mount[$idx].options='rw,noatime,nodiratime,errors=remount-ro'
  uci set fstab.global.check_fs='1'
  uci commit fstab
  reboot
  ```

- Periodic TRIM (if `fstrim` is installed):
  ```sh
  opkg install fstrim
  echo '0 4 * * 1 fstrim -v /overlay' >> /etc/crontabs/root
  /etc/init.d/cron restart
  ```

- Swap file (if low on RAM):
  ```sh
  dd if=/dev/zero of=/overlay/swapfile bs=1M count=256
  chmod 600 /overlay/swapfile
  mkswap /overlay/swapfile
  swapon /overlay/swapfile
  # auto‑enable on boot:
  uci add fstab swap
  uci set fstab.@swap[-1].enabled='1'
  uci set fstab.@swap[-1].device='/overlay/swapfile'
  uci commit fstab
  ```

---

## 9) Troubleshooting
- **After reboot `/overlay` is small again**: missing early‑boot modules. Ensure `kmod-usb-storage`, `kmod-fs-ext4`, `block-mount`, and appropriate `kmod-usb2/usb3` are installed. Check `logread` and `dmesg`.
- **Flash drive underpowered**: try another port/shorter cable/powered USB hub.
- **Rollback needed**: power off, remove the flash drive, boot without it — the system falls back to the internal overlay. Then adjust `/etc/config/fstab` or re‑do extroot.

---

## 10) Notes
- **MBR (DOS)** partition table is the most compatible choice for USB sticks. GPT also works but is rarely necessary here.
- Many prefer **f2fs** for flash media; it requires different modules and tools.
- Execute **one** command at a time and observe the output — that’s the safest approach.

Good luck! With extroot, `/overlay` finally has gigabytes of free space 🚀
