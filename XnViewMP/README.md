This module facilitates the installation of the XnViewMP package's AppImage into NixOS. It was created and tested on NixOS 23.11 with KDE.

This readme serves as a quick guide to installing XnViewMP on NixOS.

To install XnViewMP on your NixOS system, copy xnviewmp.nix to your modules folder and add it to the imports in configuration.nix:

```
  # Import configuration modules
  imports = [
      ...
      ./modules/xnviewmp.nix
      ...
    ];                      
```
Now rebuild your system: ```sudo nixos-rebuild switch```

How to update:
When a new update arrives, you need to run nix-prefetch-url to get the SHA of the file to update the module:

```
nix-prefetch-url https://download.xnview.com/XnView_MP.glibc2.17-x86_64.AppImage
```
Then update the section of the module with the current version number and SHA:

```
  # Set Version and SHA
  xnviewVersion = "1.6.5";
  xnviewSHA = "1vkmrwm6sscflxlalk73kwbpg7xf2cr9ay7dznm82w63b7wrfwd7";
```

And rebuild your system: ```sudo nixos-rebuild switch```
