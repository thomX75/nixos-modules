This module facilitates packaging of the XnViewMP's AppImage into NixOS.

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
