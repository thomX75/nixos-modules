# XnViewMP appimage module
# https://github.com/thomX75/nixos-modules

{ config, pkgs, ... }:

let

  # Set Version and SHA
  xnviewVersion = "1.7.2";
  xnviewSHA = "1wjzrnqmskxc6fl46hggxcyqszaaszg517n39l6j3l2c92ih1sq5";

  # Build XnViewMP from AppImage
  xnviewmp = pkgs.appimageTools.wrapType2 {
    name = "xnviewmp-${xnviewVersion}";
    src = pkgs.fetchurl {
      url = "https://download.xnview.com/XnView_MP.glibc2.17-x86_64.AppImage";
      sha256 = "${xnviewSHA}";
    };
    extraPkgs = pkgs: with pkgs; [
      qt5.qtbase
    ];
    extraInstallCommands = ''
      mkdir -p $out/share/applications
      cat > $out/share/applications/xnviewmp.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Name=XnView MP
      Icon=xnviewmp
      Exec=xnviewmp-${xnviewVersion} %F
      Categories=Graphics;
      EOF
      
      # Ensure the icon is copied to the right place
      mkdir -p $out/share/icons/hicolor/512x512/apps
      cp ${icon}/share/icons/hicolor/512x512/apps/xnviewmp.png $out/share/icons/hicolor/512x512/apps/
    '';
  };

  # Fetch and convert the icon
  icon = pkgs.runCommand "xnviewmp-icon" { 
    nativeBuildInputs = [ pkgs.imagemagick ];
    src = pkgs.fetchurl {
      url = "https://www.xnview.com/img/app-xnviewmp-512.webp";
      sha256 = "10zcr396y6fj8wcx40lyl8gglgziaxdin0rp4wb1vca4683knnkd";
    };
  } ''
    mkdir -p $out/share/icons/hicolor/512x512/apps
    convert $src $out/share/icons/hicolor/512x512/apps/xnviewmp.png
  '';

in
{
  environment.systemPackages = with pkgs; [
    xnviewmp
  ];
}

