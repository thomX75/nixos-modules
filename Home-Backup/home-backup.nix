# Home directory backuper at scheduled time.
# https://github.com/thomX75/nixos-modules

# TODO: This module needs some configuration. Replace "your-user-name" with your actual username, and adjust backupDisk, backupFolder, sourceFile, and maxBackups according to your needs.
# TODO: sourceFile is a list of folders or files to be backed up. See example: home-backup.conf.
# TODO: At the bottom, configure systemd.timer to run on the desired dates and times.


{ config, pkgs, ... }:

{

  # Creates systemd service.
  systemd.services."home-backup" = {
    description = "create backup based on home-backup.conf source list file";
    script = ''
      # Get the hostname
      hostname=$(cat /etc/hostname)

      # Define variables
      backupDisk="/mnt/Your-Disk"
      backupFolder="$backupDisk/Backup/Home-Backup-$hostname/"
      sourceFile="/home/your-user-name/.dotfiles/configs/home-backup.conf"
      dateStamp="$(date +'%Y.%m.%d-%H.%M')"
      maxBackups=14
      backupUser="your-user-name"
      backupGroup="users"

      # Create backup folder if it doesn't exist
      mkdir -p "$backupFolder"

      # Check if a backup has already been made today
      if [ -n "$(find "$backupFolder" -name "*.tgz" -daystart -mtime 0)" ]; then
        echo "A backup has already been made today."
        exit 0
      fi

      # Initialize an empty temporary file list
      tempFileList=$(mktemp)

      # Read each line from sourceFile and check if it exists
      while IFS= read -r filePath; do
        if [ -e "$filePath" ]; then
          echo "$filePath" >> "$tempFileList"
        else
          echo "Skipping missing file or directory: $filePath"
        fi
      done < "$sourceFile"

      # Compress files to temporary directory using tar
      newArchive="$backupFolder$dateStamp.tgz"
      PATH=/run/current-system/sw/bin:$PATH tar czf "$newArchive" -T "$tempFileList"

      # Change ownership of the backup archive
      chown -R "$backupUser:$backupGroup" "$backupFolder"

      # Remove the temporary file list
      rm "$tempFileList"

      # Remove backups over $maxBackups
      backupFiles=$(ls -t "$backupFolder" | tail -n +$(($maxBackups + 1)))
      for file in $backupFiles; do
        rm -- "$backupFolder$file"
      done
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      StandardOutput = "journal+console";
      StandardError = "journal+console";
    };
  };

  # Enables timer to run home-backup service on calendar. 
  systemd.timers."home-backup" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 17:00";
      Persistent = true;
      Unit = "home-backup.service";
    };
  };

}
