{ pkgs, pkgs-unstable, ... }:
let
  fontPackages = with pkgs.nerd-fonts; [
    ubuntu
    ubuntu-mono
    fantasque-sans-mono
    fira-code
    mononoki
  ];

  theme = {
    name = "adw-gtk3-dark";
    package = pkgs-unstable.adw-gtk3;
  };
  font = {
    name = "Ubuntu Nerd Font";
    package = pkgs.nerd-fonts.ubuntu;
  };
  cursorTheme = {
    name = "Qogir";
    size = 24;
    package = pkgs-unstable.qogir-icon-theme;
  };
  iconTheme = {
    name = "MoreWaita";
    package = pkgs-unstable.morewaita-icon-theme;
  };
in
{
  home.packages = [ cursorTheme.package ] ++ fontPackages;
  home.pointerCursor = cursorTheme;
  home.file = {
    ".local/share/themes/${theme.name}" = {
      source = "${theme.package}/share/themes/${theme.name}";
    };
    ".config/gtk-4.0/gtk.css".text = ''
          window.messagedialog.response-area > button,
        window.dialog.message .dialog-action-area > button,
        .background.csd{
        border-radius: 0;
      }
    '';
  };
  gtk = {
    inherit font cursorTheme iconTheme;
    theme.name = theme.name;
    enable = true;
    gtk3.extraCss = ''
            headerbar, .titlebar,
        .csd:not(.popup):not(tooltip):not(messagedialog) decoration{
        border-radius: 0;
      }
    '';
  };
}
