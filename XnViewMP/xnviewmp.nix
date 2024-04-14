{ pkgs, lib, ... }:

let

  # Set Version and SHA
  xnviewVersion = "1.7.1";
  xnviewSHA = "175amdwx0an94kh4sb8wx562x6isv5y5025b03n1nni2ip1gha6k"; 

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

