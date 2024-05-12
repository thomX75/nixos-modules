{ config, pkgs, ... }:

{

  # TODO: replace "your-user-name" with your user name.
  users.users.your-user-name.extraGroups = [ "smart" ];
  
  # Enable SmartD service
  services.smartd = {
    enable = true;
    autodetect = true;
    notifications.x11 = {
      enable = true;
      display = ":${toString config.services.xserver.display}";
    };
  };

  # Creates a smart checking script named /etc/scripts/smart-check.sh
  # which generates output in /tmp/disk_status.txt for Conky to read.
  environment.etc =
  {
    "scripts/smart-check.sh" =
    {
      text =
      ''
      #!/run/current-system/sw/bin/bash

      # Function to check SMART status of a disk
      check_disk_smart_status() {
          disk=$1
          smart_status=$(sudo smartctl -H $disk | grep "SMART overall-health self-assessment test result")
          if [[ $smart_status == *"PASSED"* ]]; then
              disk_status="PASSED"
          elif [[ $smart_status == *"FAILED"* ]]; then
              disk_status="FAILED"
          else
              smart_warning=$(sudo smartctl -l warning $disk | grep "SMART Health Status")
              if [[ $smart_warning == *"Warning"* ]]; then
                  disk_status="WARNING"
              else
                  disk_status="UNKNOWN"
              fi
          fi
      }

      # Get list of disks
      disks=$(lsblk -o NAME -nldA)

      # Variable to track overall status
      overall_status="PASSED"

      # Loop through each disk
      for disk in $disks; do
          check_disk_smart_status "/dev/$disk"
          if [[ "$disk_status" == "FAILED" ]]; then
              overall_status="FAILED"
              break
          elif [[ "$disk_status" == "WARNING" ]]; then
              overall_status="WARNING"
          fi
      done

      # Write overall status to file
      echo "$overall_status" > /tmp/disk_status.txt

      '';
      mode = "0554";
    };
  };

  # Creates service to run the script.
  systemd.services."SmartCheck" = {
    script = ''
      #!/run/current-system/sw/bin/bash
      set -eu
      /run/current-system/sw/bin/bash /etc/scripts/smart-check.sh
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  # Enables timer to run smart-check.sh at boot and every 30 minutes after.
  systemd.timers."SmartCheck" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "15s";            # Delay to start after boot, adjust as needed
      OnUnitActiveSec = "30m";      # Run every 30 minutes
      Unit = "SmartCheck.service";
    };
  };

}
