{ config, pkgs, ... }:

{

  # Define the script in /etc/scripts/sddm-avatar.sh
  environment.etc = {
    "scripts/sddm-avatar.sh" = {
      text = ''
        #!/run/current-system/sw/bin/bash
        for user in /home/*; do
          username=$(basename $user)
          if [ ! -f /etc/nixos/sddm/$username ]; then
            cp $user/.face.icon /var/lib/AccountsService/icons/$username
          else
            if [ $user/.face.icon -nt /var/lib/AccountsService/icons/$username ]; then
              cp -i $user/.face.icon /var/lib/AccountsService/icons/$username
            fi
          fi
        done
      '';
      mode = "0554";
    };
  };
  
  # Define systemd service to run script on boot
  systemd.services.sddm-avatar = {
    description = "Script to copy or update users Avatars at startup.";
    wantedBy = [ "multi-user.target" ];
    before = [ "sddm.service" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "/etc/scripts/sddm-avatar.sh";
      StandardOutput = "journal+console";
      StandardError = "journal+console";
    };
  };

  # Make SDDM depend on sddm-avatar.service and ensure SDDM starts after it.
  systemd.services.sddm = {
    after = [ "sddm-avatar.service" ];
  };

}