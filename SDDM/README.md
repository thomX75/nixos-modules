This directory contains flew modules for SDDM ***WIP***

```sddm-avatar.nix``` - this module creates script to be executed by systemd service before SDDM.
It will copy on boot all users ```~/.face.icon``` to ```/var/lib/AccountsService/icons/$username``` also update if changed.
Note ```~/.face.icon``` has to be png picture for SDDM to be able to read it.

```sddm-breeze-mod.nix``` - this module along with ```image-shuffler.nix``` will shufle SDDM background on boot or logoff.
It sources images in ```~/Pictures/Backgrounds```, creates also link to random selected image in ```~/Pictures``` you can use it in KDE and lock screen.
Only issue with this solution is that every time background is changes and you open Wallpaper control panel will ask you to apply changes.
