This directory contains flew modules for SDDM ***WIP***

sddm-avatar.nix - this module creates script to be executed by systemd service before SDDM.
It will copy on boot all users ```~/.face.icon``` to ```/var/lib/AccountsService/icons/$username``` also update if changed.
Note ```~/.face.icon``` has to be png picture for SDDM to be able to read it.