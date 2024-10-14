{ config
, pkgs
, inputs
, ...
}:
let
  wallpaperScript = pkgs.writeShellScriptBin "start" ''
    ${pkgs.swww}/bin/swww init &

    sleep 5
    DIRECTORY="$HOME/.config/wallpaper"
    COMMAND="${pkgs.swww}/bin/swww img "
    while true; do
      for file in "$DIRECTORY"/*; do
        ${pkgs.swww}/bin/swww img "$file"
        sleep 600
      done
    done
  '';

  toggleSourceScript = pkgs.writeShellScriptBin "toggle-source" ''
    #!/usr/bin/env bash

    STATE_FILE="/tmp/.current_audio_source"

    if [[ -f "$STATE_FILE" ]]; then
        current_source=$(cat "$STATE_FILE")
    else
        current_source="B"
    fi

    if [[ "$current_source" == "A" ]]; then
        new_source="B"
        source_name="HDMI"
    else
        new_source="A"
        source_name="System"
    fi

    eval "wpctl status | grep $source_name | sed 's/[^0-9]*\([0-9]\+\).*/\1/' | xargs wpctl set-default"

    echo "$new_source" > "$STATE_FILE"

    notify-send "Audio Source" "Switched to $source_name"
  '';
in
{
  home.packages = with pkgs; [ wl-clipboard ];
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    plugins = [ inputs.hy3.packages.x86_64-linux.hy3 ];
    settings = {
      exec-once = [
        "hyprctl setcursor Qogir 24"
        "wl-paste --type text --watch cliphist store #Stores only text data"
        "wl-paste --type image --watch cliphist store #Stores only image data"
        "swww init"
        "1password --silent"
        "${wallpaperScript}/bin/start"
      ];
      debug = {
        disable_logs = false;
      };
      general = {
        gaps_in = 5;
        gaps_out = 5;
        layout = "hy3";
      };
      decoration = {
        rounding = 3;
        dim_inactive = true;
        dim_strength = 0.2;
        blur = {
          passes = 3;
          size = 4;
          special = true;
        };
      };
      workspace = [
        "1, m:DP-1, default:true"
        "2, m:DP-1 "
        "3, m:DP-1"
        "4, m:DP-2, default:true"
        "5, m:DP-2"
      ];
      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "opacity 1.0, class:(kitty)"
        "workspace special:special silent, class:^(ticktick)$"
        "opacity 1.0 override 0.8 override,fullscreen:1"
      ];
      "$mainMod" = "SUPER";
      bind =
        [
          "$mainMod, return, exec, kitty"
          "$mainMod, SPACE, exec, rofi -show drun"
          "$mainMod, Q, hy3:killactive"
          "$mainMod CONTROL, h, hy3:movefocus, l"
          "$mainMod CONTROL, j, hy3:movefocus, d"
          "$mainMod CONTROL, k, hy3:movefocus, u"
          "$mainMod CONTROL, l, hy3:movefocus, r"
          "$mainMod, h, hy3:movefocus, l, visible, nowarp"
          "$mainMod, j, hy3:movefocus, d, visible, nowarp"
          "$mainMod, k, hy3:movefocus, u, visible, nowarp"
          "$mainMod, l, hy3:movefocus, r, visible, nowarp"
          "$mainMod SHIFT, c, movetoworkspacesilent, special"
          "$mainMod, c, togglespecialworkspace"
          "$mainMod SHIFT, h, hy3:movewindow, l, once"
          "$mainMod SHIFT, j, hy3:movewindow, d, once"
          "$mainMod SHIFT, k, hy3:movewindow, u, once"
          "$mainMod SHIFT, l, hy3:movewindow, r, once"
          "$mainMod+CONTROL+SHIFT, h, hy3:movewindow, l, once, visible"
          "$mainMod+CONTROL+SHIFT, j, hy3:movewindow, d, once, visible"
          "$mainMod+CONTROL+SHIFT, k, hy3:movewindow, u, once, visible"
          "$mainMod+CONTROL+SHIFT, l, hy3:movewindow, r, once, visible"
          "$mainMod SHIFT, d, hy3:debugnodes, h"
          "$mainMod, d, hy3:makegroup, h"
          "$mainMod, s, hy3:makegroup, v"
          "$mainMod, z, hy3:makegroup, tab"
          "$mainMod, a, hy3:changefocus, raise"
          "$mainMod+SHIFT, a, hy3:changefocus, lower"
          "$mainMod, e, hy3:expand, expand"
          "$mainMod+SHIFT, e, hy3:expand, base"
          "$mainMod, r, hy3:changegroup, opposite"
          ", XF86Launch6, exec, ${toggleSourceScript}/bin/toggle-source"
          "$mainMod, m, fullscreen, 1"
          "$mainMod, n, exec, swaync-client -t"
          "$mainMod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
          "ALT, J, exec, wl-paste | jq . | wl-copy"
          "$mainMod, S, exec, grim ~/Pictures/screenshot_$(date +'%s_grim.png')"
          "$mainMod, minus, layoutmsg, mfact -0.05"
          "$mainMod, P, exec, sleep 5; hyprctl dispatch dpms off;"
          "$mainMod, equal, layoutmsg, mfact +0.05"
          "$mainMod CTRL, S, exec, grim -g \"$(slurp -o)\" ~/Pictures/screenshot_$(date +'%s_grim.png')"
          "$mainMod CTRL SHIFT, S, exec, grim -g \"$(slurp)\" - | wl-copy"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList
            (
              x:
              let
                ws =
                  let
                    c = (x + 1) / 10;
                  in
                  builtins.toString (x + 1 - (c * 10));
              in
              [
                "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
                "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            )
            6)
        );
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      bindn = [
        ", mouse:272, hy3:focustab, mouse"
        ", mouse_down, hy3:focustab, l, require_hovered"
        ", mouse_up, hy3:focustab, r, require_hovered"
      ];
      monitor = [
        "DP-1, 5120x1440@240, 0x1080, 1"
        "DP-2, 2560x1080, 1440x0, 1"
      ];
      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_NO_HARDWARE_CURSORS,1"
        "WLR_RENDERER_ALLOW_SOFTWARE,1"
        "HYPRCURSOR_THEME,rose-pine-hyprcursor"
      ];
      master = { orientation = "center"; };
      misc = {
        animate_manual_resizes = true;
        animate_mouse_windowdragging = true;
        key_press_enables_dpms = true;
      };
      plugins = {
        hy3 = {
          tabs = {
            height = 2;
            padding = 6;
          };
        };
      };
    };
  };
}
