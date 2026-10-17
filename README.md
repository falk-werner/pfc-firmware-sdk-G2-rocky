# Install WAGO Firmware SDK G2 on Rocky Linux

These instructions apply to Rocky Linux 10.2 (Red Quartz).

## Install PTXdist, Toolchain and SDK dependencies

```bash
sudo ./install-sdk.sh
```

## Clone SDK

```bash
git clone https://github.com/WAGO/pfc-firmware-sdk-G2.git
cd pfc-firmware-sdk-G2
```

## Apply patches

```bash
git apply ../sdk.patch
```

## Configure PTXdist

```bash
cd ptxproj
ptxdist select configs/wago-pfcXXX/ptxconfig_pfc_g2
ptxdist platform configs/wago-pfcXXX/platformconfig
ptxdist toolchain /opt/LINARO.Toolchain-2022.08-wago.1/arm-linux-gnueabihf/bin/
```

## Get Firmweare dependencies

```bash
ptxdist get -q -j -n19
```

## Build the firmware

```bash
ptxdist go -q -j -n19
```

## Build image

```bash
ptxdist images -q
```

## Create WUP file

```bash
make wup
```



