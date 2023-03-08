# pocOpenWrt

## Build docker
```
docker build . -t debian/openwrtbuilder:latest
```

## Start docker and compile
```
docker run -it debian/openwrtbuilder:latest /bin/bash

$ make menuconfig
$ make
```


## SDK

https://firmware-selector.openwrt.org/?version=22.03.3&target=ath79%2Fgeneric&id=glinet_gl-ar300m16

## Model gl-ar300m_lite openwrt

https://openwrt.org/toh/gl.inet/gl-ar300m_lite
