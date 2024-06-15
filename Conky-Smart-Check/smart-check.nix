# Smart Check module
# https://github.com/thomX75/nixos-modules
# TODO: Change "your-user-name" to your username.

{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [ util-linux smartmontools ];

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
      # Get list of disks
      disks=$(${pkgs.util-linux}/bin/lsblk -o NAME -nldA)

      # Function to check SMART status of a disk
      check_disk_smart_status() {
        disk=$1
        smart_status=$(${pkgs.smartmontools}/bin/smartctl -H /dev/$disk | grep "SMART overall-health self-assessment test result")
        if [[ $smart_status == *"PASSED"* ]]; then
          disk_status="PASSED"
        elif [[ $smart_status == *"WARNING"* ]]; then
          disk_status="WARNING"
        elif [[ $smart_status == *"FAILED"* ]]; then
          disk_status="FAILED"
        else
          disk_status="UNKNOWN"
        fi
        echo $disk_status
      }

      # Variable to track overall status
      overall_status="PASSED"

      # Loop through each disk
      for disk in $disks; do
        disk_status=$(check_disk_smart_status "$disk")
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
