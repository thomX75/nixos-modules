# SDDM Breeze theme mod to use with Image Shuffler
{ pkgs, ... }:

let

  sddm-breeze-mod = pkgs.stdenv.mkDerivation rec {
    pname = "sddm-breeze-mod";
    version = "1.0.0";

    src = pkgs.plasma-workspace;  # Use the installed breeze package as the source

    installPhase = ''
      mkdir -p $out/share/sddm/themes/breezeMod
      cp -r $src/share/sddm/themes/breeze/* $out/share/sddm/themes/breezeMod

      chmod 766 $out/share/sddm/themes/breezeMod/theme.conf

      sed -i 's|^background=.*|background=/etc/nixos/images/sddm-background.jpg|' $out/share/sddm/themes/breezeMod/theme.conf
      echo "CursorTheme=breeze_cursors" >> $out/share/sddm/themes/breezeMod/theme.conf
      echo "Numlock=on" >> $out/share/sddm/themes/breezeMod/theme.conf

      chmod 444 $out/share/sddm/themes/breezeMod/theme.conf
    '';

    meta = with pkgs.lib; {
      description = "SDDM Breeze theme mod to use with Image Shuffler";
      homepage = "https://github.com/thomX75/nixos-modules";
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };

in

{
  environment.systemPackages = with pkgs; [ sddm-breeze-mod ];
  services.displayManager.sddm.theme = "breezeMod";
}
