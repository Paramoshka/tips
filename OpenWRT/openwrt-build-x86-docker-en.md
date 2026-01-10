# Build OpenWrt (x86_64) and packages in Docker

Goal: build your own OpenWrt image for `x86_64` (mini‑PC) and build `ipk` packages (for example `dnsmasq`) if prebuilt repos for your architecture are missing/broken.

Files:
- `images/Dockerfile.OpenWRT` — builder image.
- `images/openwrt-x86_64.config` — minimal `.config` for `x86/64 (generic)` + `dnsmasq`.

## 1) Build the docker builder image
From the repo root:
```sh
docker build -f images/Dockerfile.OpenWRT -t openwrt-builder \
  --build-arg UID="$(id -u)" --build-arg GID="$(id -g)" \
  --build-arg OPENWRT_REF="openwrt-23.05" \
  --build-arg PACKAGES_REF="openwrt-23.05" \
  .
```

## 2) Run container with persistent `dl/` and `bin/` on host
```sh
mkdir -p ./openwrt-dl ./openwrt-bin
docker run --rm -it \
  -v "$PWD/openwrt-dl:/home/builder/openwrt/dl" \
  -v "$PWD/openwrt-bin:/home/builder/openwrt/bin" \
  openwrt-builder
```

## 3) Build OpenWrt firmware for x86_64
Inside the container:
```sh
make -j"$(nproc)" V=s
```

Artifacts will be in `./openwrt-bin/targets/x86/64/`.

## 4) Build packages only (example: dnsmasq)
Inside the container:
```sh
make -j"$(nproc)" toolchain/install
make -j"$(nproc)" package/dnsmasq/clean
make -j"$(nproc)" package/dnsmasq/compile V=s
```

> [!TIP]
> [build single package](https://openwrt.org/docs/guide-developer/toolchain/single.package)

`ipk` files will show up under `./openwrt-bin/packages/x86_64/` (subdirs like `base/`, `packages/`, etc.).

## 5) How to use a custom config
By default the build uses `images/openwrt-x86_64.config`.

To build with your own `.config`:
```sh
docker run --rm -it \
  -v "$PWD/openwrt-dl:/home/builder/openwrt/dl" \
  -v "$PWD/openwrt-bin:/home/builder/openwrt/bin" \
  -v "$PWD/.config:/home/builder/openwrt/.config" \
  openwrt-builder bash -lc 'make defconfig'
```
