{
  config,
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.vscode ];
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ms-vsliveshare.vsliveshare
    ];
    userSettings = {
      "window.titleBarStyle" = "custom";
      "workbench.colorTheme" = "Github Dark Colorblind (Beta)";
      "editor.fontFamily" = "'FiraCode Nerd Font','Droid Sans Mono', 'monospace', monospace";
    };
  };
}
