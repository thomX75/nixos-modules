Note: I've created this module to daily back up my NixOS configuration files in case of unnoticed breakage of any sort.
The existing backup solution seemed overcomplicated and too large for a simple task like backing up dotfiles.

This module creates backups of your selected data in home-backup.conf using a systemd timer.

The systemd timer is configured to create a backup at 17:00 every day. You need to adjust it to run it at times or/and days that suit you needs.
Apart from the schedule, you will need to configure all paths and the list of folders to back up to function as desired.
You need also replace "your-user-name" with your actual username.

To install the module on your NixOS system, copy it to your modules folder and add it to the imports in configuration.nix:

```
  # Import configuration modules
  imports = [
      ...
      ./modules/home-backup.nix
      ...
    ];                      
```

And rebuild your system: ```sudo nixos-rebuild switch```
