# TODO: Change "your-user-name" to your username.

{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    smartmontools
  ];

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

  # Creates a smart checking systemd service which generates
  # output in /tmp/disk_status.txt for Conky to read.
  systemd.services."smart-check" = {
    wantedBy = [ "multi-user.target" ];
    description = "Service to update disk status at startup and every 30 minuter after.";
    script = ''
      set -eu

      # Function to check SMART status of a disk
      check_disk_smart_status() {
          disk=$1
          smart_status=$(/run/current-system/sw/bin/smartctl -H $disk | grep "SMART overall-health self-assessment test result")
          if [[ $smart_status == *"PASSED"* ]]; then
              disk_status="PASSED"
          elif [[ $smart_status == *"FAILED"* ]]; then
              disk_status="FAILED"
          else
              smart_warning=$(/run/current-system/sw/bin/smartctl -l warning $disk | grep "SMART Health Status")
              if [[ $smart_warning == *"Warning"* ]]; then
                  disk_status="WARNING"
              else
                  disk_status="UNKNOWN"
              fi
          fi
      }

      # Get list of disks
      disks=$(/run/current-system/sw/bin/lsblk -o NAME -nldA)

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
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      StandardOutput = "journal+console";
      StandardError = "journal+console";
    };
  };

  # Enables timer to run smart-check service.
  systemd.timers."smart-check" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "15s";            # Delay to start after boot, adjust as needed
      OnUnitActiveSec = "30m";      # Run every 30 minutes
      Unit = "smart-check.service";
    };
  };

}
