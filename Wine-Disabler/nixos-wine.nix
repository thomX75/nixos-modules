{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    winetricks
    winePackages.fonts
    wineWowPackages.stable
  ];

  system.activationScripts.wine-cleanup = {
    text = ''
      for user in /home/*; do
        username=$(basename $user)
        if [ -f /home/$username/.local/share/applications/wine-extension-*.desktop ]; then
          rm /home/$username/.local/share/applications/wine-extension-*.desktop
        fi
      done
    '';
  };

}