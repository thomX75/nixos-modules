Modules in this folder are built directly from Git to update them faster than in distro packages.

How to update: When a new update arrives, you need to run
How to update: ```nix-prefetch-url``` or ```nix-prefetch-git``` to get the SHA or hash of the file to update the appimage, binary or source code.
Note: ```nix-prefetch-git``` needs to be installed on your system, alternatively you can use ```nix-shell -p nix-prefetch-git``` to temporarily pull the package.

For AppImage:
```
nix-prefetch-url https://download.xnview.com/XnView_MP.glibc2.17-x86_64.AppImage
```

For Git source:
```
nix-prefetch-git --url https://github.com/BlitterStudio/amiberry --rev v7.0.4
```


Then update the section of the module with the current version number and hash/SHA:

```
  ...
  *version = "x.y.z";
  ...
```

```
  ...
  hash = "sha256-d4ys305+zlKb912B30UEoAm8eoou8IZNhfqi13WvuKQ=";
  ...
```
  or
```
  ...
  *SHA = "0phcr3njmi3d8frhgcr99wjxbcrgf80zad8rkgpyfmk6bz0gq2vd";
  ...
```