{ config
, pkgs
, ...
}: {
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "monish" ];
  };
  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        google-chrome
        firefox
      '';
      mode = "0755";
    };
  };

  programs.ssh = {
    extraConfig = ''
      Host *
          IdentityAgent ~/.1password/agent.sock
    '';
  };
}
