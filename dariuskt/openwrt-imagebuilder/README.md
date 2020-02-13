## OpenWRT image builder


### Image list

* openwrt-19.07.1-ramips-rt305x-a5-v11-squashfs-sysupgrade.bin (for 16MB flash)


### run

```
docker run -it --rm -v "$(pwd)/src:/home/project/src" dariuskt/openwrt-imagebuilder
```


### debug/customize

```
docker run -it --rm -v "$(pwd)/src:/home/project/src" dariuskt/openwrt-imagebuilder sudo -HEu project bash -l
```

and edit file `src/build.sh`

