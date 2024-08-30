{ config
, pkgs
, ...
}:
let
  onePassPath = "~/.1password/agent.sock";
in
{
  programs.ssh = {
    extraConfig = ''
      Host *
          IdentityAgent ${onePassPath}
    '';
  };
}
