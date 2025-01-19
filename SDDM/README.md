This directory contains several modules for SDDM ***WIP***.

```sddm-avatar.nix``` this module copies all users ```~/.face.icon``` files to ```/var/lib/AccountsService/icons/$username``` on boot, and updates the copy if the original file changes. Note that ```~/.face.icon``` must be a PNG picture for SDDM to read it. *** this module has been re-worked to resolve issue with datestamp of source and destionation files. ***

```sddm-breeze-mod-plasmaX.nix``` these modules, along with ```image-shuffler.nix```, shuffles the SDDM background on boot or logoff. It sources images from ```~/Pictures/Backgrounds```, and creates a link to a randomly selected image in ```~/Pictures```. You can use this linked image as your wallpaper in KDE and lock screen. Both Plasma 5 and Plasma 6 available.
The only issue with this solution is that every time the background is changed, the Wallpaper control panel will ask you to apply changes. However, you don't need to do so.


