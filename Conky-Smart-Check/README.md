This module checks the SMART status of your drives using ```services.smartd``` and saves it to the file ```/tmp/disk_status.txt``` for Conky to read. See conky-screenshots folder.

The text color of the status changes according to the disk status read from the file and remains unchanged when the status is "PASSES". It changes to yellow for "WARNING" and red for "FAILED" status.

You need to change "your-user-name" to your user name. You also need to add code to your Conky configuration to read from the file for example:
```
SMART Status:${alignr}${if_match "${exec cat /tmp/disk_status.txt}" == "PASSED"} PASSED\
${else}${if_match "${exec cat /tmp/disk_status.txt}" == "WARNING"} ${color yellow}WARNING\
${else}${if_match "${exec cat /tmp/disk_status.txt}" == "FAILED"}  ${color red}FAILED\
${else} ${color white}Unknown${endif}${endif}${endif}${color}
```

To install Conky Smart Check on your NixOS system, copy smart-check.nix to your modules folder and add it to the imports in configuration.nix:

```
  # Import configuration modules
  imports = [
      ...
      ./modules/smart-check.nix
      ...
    ];                      
```
Now rebuild your system: ```sudo nixos-rebuild switch```
