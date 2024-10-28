{
  config,
  pkgs,
  ...
}:
{
  imports = [ ./one-password.nix ];
  services.xserver = {
    xkb = {
      layout = "gb";
      variant = "";
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          user = "monish";
          command = "dbus-launch Hyprland";
        };
      };
    };
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };
}
