# Сборка OpenWrt (x86_64) и пакетов в Docker

Цель: собрать свой образ OpenWrt для x86_64 (mini‑PC) и собрать `ipk` пакеты (например `dnsmasq`), если в репозиториях под вашу архитектуру их нет/они битые.

Файлы:
- `images/Dockerfile.OpenWRT` — образ билдера.
- `images/openwrt-x86_64.config` — минимальная `.config` под `x86/64 (generic)` + `dnsmasq`.

## 1) Собрать docker-образ билдера
Из корня репозитория:
```sh
docker build -f images/Dockerfile.OpenWRT -t openwrt-builder \
  --build-arg UID="$(id -u)" --build-arg GID="$(id -g)" \
  --build-arg OPENWRT_REF="openwrt-23.05" \
  --build-arg PACKAGES_REF="openwrt-23.05" \
  .
```

## 2) Запустить контейнер с сохранением `dl/` и `bin/` на хост
```sh
mkdir -p ./openwrt-dl ./openwrt-bin
docker run --rm -it \
  -v "$PWD/openwrt-dl:/home/builder/openwrt/dl" \
  -v "$PWD/openwrt-bin:/home/builder/openwrt/bin" \
  openwrt-builder
```

## 3) Собрать образ (firmware) OpenWrt для x86_64
Внутри контейнера:
```sh
make -j"$(nproc)" V=s
```

Артефакты будут в `./openwrt-bin/targets/x86/64/`.

## 4) Собрать только пакеты (пример: dnsmasq)
Внутри контейнера:
```sh
make -j"$(nproc)" toolchain/install
make -j"$(nproc)" package/dnsmasq/clean
make -j"$(nproc)" package/dnsmasq/compile V=s
```

> [!TIP]
> [build single package](https://openwrt.org/docs/guide-developer/toolchain/single.package)

`ipk` появятся в `./openwrt-bin/packages/x86_64/` (подкаталоги `base/`, `packages/`, и т.д.).

## 5) Как поменять конфиг
По умолчанию при сборке образа используется `images/openwrt-x86_64.config`.

Чтобы собрать с другим `.config`:
```sh
docker run --rm -it \
  -v "$PWD/openwrt-dl:/home/builder/openwrt/dl" \
  -v "$PWD/openwrt-bin:/home/builder/openwrt/bin" \
  -v "$PWD/.config:/home/builder/openwrt/.config" \
  openwrt-builder bash -lc 'make defconfig'
```
