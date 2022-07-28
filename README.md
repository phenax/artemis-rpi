# Artemis
Nixos image builder and server configuration for my raspberry pi 4 server


## Build an installer img

* Copy `secrets.example.nix` to secrets.nix and configure the values
* Run `make build` to build a new server img file in output/sd-image
* Run `make burn DEV=/dev/sdX` to burn the image onto a usb drive or sd card (for device /dev/sdX)


## Install

* Put the usb drive/sd card in your rpi
* Wait for the rpi to connect to the network (if you have a monitor, you can use that as well)
* Connect via ssh (or use a monitor and keyboard if you're boring)
* Run `journalctl -f -u artemis-init.service` to see the log 
* Wait for that to finish (or if it errors out, just run `nixos-rebuild switch` once)
* Reboot and it's done

