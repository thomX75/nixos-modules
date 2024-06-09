This module installs Wine and disables Wine desktop integration.

You may wonder why I created this module, and here are my reasons:

- If you randomly click on Windows executables (e.g., .exe files), they will launch and create the ```~/.wine``` prefix.
- After every system update, Wine creates ```.desktop``` files with the Wine application's mimetype for Wine/Windows apps.

This module removes these problems and won't affect Lutris or Steam. Additionally, wine will still work as intended, but you'll need to run it using its full path like ```wine ~/Downloads/random.exe``` rather than just clicking on an icon.

The module is built in two parts:

```home-wine.nix```: Rename this file to ```wine.nix```, copy it to your home-manager modules, and add it to imports. This part creates a new desktop icon with removed extensions for wine applications.
```nixos-wine.nix```: Rename this file to ```wine.nix``` and copy it to NixOS modules, then add it to imports. This part removes the ```wine-extension-*.desktop``` files from ```~/.local/share/applications/``` for all users.