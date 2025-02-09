# Amiberry 7 directly from GitHub, built from source.
# https://github.com/thomX75/nixos-modules

{ config, pkgs, ... }:

let

  # Set Version and SHA
  freetubeVersion = "0.23.1";
  freetubeSHA = "0phcr3njmi3d8frhgcr99wjxbcrgf80zad8rkgpyfmk6bz0gq2vd";

  # Build freetube from AppImage
  freetube = pkgs.appimageTools.wrapType2 {
    name = "freetube-${freetubeVersion}";
    src = pkgs.fetchurl {
      url = "https://github.com/FreeTubeApp/FreeTube/releases/download/v${freetubeVersion}-beta/freetube-${freetubeVersion}-amd64.AppImage";
      sha256 = "${freetubeSHA}";
    };
    extraPkgs = pkgs: with pkgs; [ ];
    extraInstallCommands = ''
      mkdir -p $out/share/applications
      cat > $out/share/applications/freetube.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Name=FreeTube
      Icon=freetube
      Exec=freetube-${freetubeVersion} %F
      Categories=Graphics;
      EOF
    '';
  };

  # Fetch and convert the icon
  icon = pkgs.runCommand "freetube-icon" { 
    src = pkgs.fetchurl {
      url = "https://github.com/FreeTubeApp/FreeTube/blob/development/_icons/256x256.png";
      sha256 = "1hxs6f81lpj7a7kd6npq7qmh0l945pm6lfa32kzihszm5dhv1280";
    };
  } ''
    mkdir -p $out/share/icons/hicolor/512x512/apps
    cp $src $out/share/icons/hicolor/512x512/apps/freetube.png
  '';

in
{
  environment.systemPackages = with pkgs; [
    freetube
  ];
}

