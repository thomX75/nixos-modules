{ config, ... }:

{

  home.file.".local/share/applications/wine.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Wine Windows Program Loader
    Exec=wine start /unix %f
    MimeType=
    Icon=wine
    NoDisplay=true
    StartupNotify=true
  '';

}