{ nixosConfig, lib, ... }:
{
  programs.ssh = {
    enable = true;

    extraConfig = lib.mkIf nixosConfig.programs._1password.enable ''
      Host *
          IdentityAgent ~/.1password/agent.sock
    '';
  };
}
