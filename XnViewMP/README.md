XnViewMP appimage packaged for NixOS (tested on 23.11)

This readme is only quick guide to get started.

To get XnViewMP installed on you NixOS add it to imports:

```
  # Import configuration modules
  imports = [
      ...
      ./modules/xnviewmp.nix
      ...
    ];                      
```


How to update:
When new update arrives you need run nix-prefetch-url to get sha of file to update the module:

```
nix-prefetch-url https://download.xnview.com/XnView_MP.glibc2.17-x86_64.AppImage
```
Then update section of module with current version and SHA:

```
  # Set Version and SHA
  xnviewVersion = "1.6.5";
  xnviewSHA = "1vkmrwm6sscflxlalk73kwbpg7xf2cr9ay7dznm82w63b7wrfwd7";
```
