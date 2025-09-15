{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.git = {
    enable = true;
    userName = "Monish Thirukumaran";
    userEmail = "monish.thir@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };

  };
}
