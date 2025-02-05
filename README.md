# nixos-modules
This is my collection of modules for the NixOS repository. Modules are updated for the stable 24.05.

I'm at the very beginning of my journey with NixOS, so I'll inevitably make mistakes or approach problems incorrectly. If you notice an error or have a different approach, please leave a comment.

Also, I’ve just started using flakes and am using only a little bit of Home Manager, as I’m taking baby steps in the NixOS realm.

DISCLAIMER: I do not take any responsibility for damage to your system. Please review the code before applying the module to your system.



To install modules on your NixOS system, copy the module(s) to your modules folder and add it to the imports in configuration.nix:

```
  # Import configuration modules
  imports = [
      ...
      ./modules/image-shuffler.nix
      ./modules/sddm-avatar.nix
      ./modules/sddm-breeze-mod-plasma6.nix
      ./modules/xnviewmp.nix
      ...
    ];                      
```
Now rebuild your system: ```sudo nixos-rebuild switch``` or rebuild it with flakes.
