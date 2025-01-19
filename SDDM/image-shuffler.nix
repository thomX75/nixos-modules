# Image Shuffler module
# https://github.com/thomX75/nixos-modules
# TODO: replace "your-user-name" with you user name.

{ config, pkgs, ... }:

{
 
   # Define systemd service to run script on boot
  systemd.services."image-shuffler" = {
    description = "Service to shuffle SDDM's & KDE's background images on startup";
    wantedBy = [ "multi-user.target" ];
    before = [ "sddm.service" ];
    script = ''
      # Defines files and paths
      User="your-user-name"
      UserPath="/home/$User"
      UserImages="$UserPath/Pictures"
      SDDMImages="/etc/nixos/images"
      KDEImg="kde-background.jpg"
      SDDMImg="sddm-background.jpg"

      # Create destination folder
      if [ ! -d "$SDDMImages/backgrounds" ]; then
        mkdir -p $SDDMImages/backgrounds
      fi

      # Sync user's source folder with script's source folder
      ${pkgs.rsync}/bin/rsync --recursive --delete $UserImages/Backgrounds/ $SDDMImages/backgrounds/

      # Change permissions for directories and files
      chmod 0644 $SDDMImages/backgrounds/*

      # Create symlink to random picture in destination folder
      link_random () {
        # Pick any file
        file=$(ls $1 | sort -R | tail -1)
        echo $file
      }

      # Get random file and create symlinks
      random_file=$(link_random $SDDMImages/backgrounds)
      ln -sf $SDDMImages/backgrounds/$random_file $SDDMImages/$SDDMImg
      ln -sf $UserImages/Backgrounds/$random_file $UserImages/$KDEImg
    '';
    serviceConfig = {
      Type = "simple";
      User = "root";
      StandardOutput = "journal+console";
      StandardError = "journal+console";
      };
  };

  # Make SDDM depend on image-shuffler.service and ensure SDDM starts after it.
  systemd.services.sddm = {
    after = [ "image-shuffler.service" ];
  };

  environment.systemPackages = with pkgs; [ rsync ];

}
