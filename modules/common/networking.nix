{ config
, pkgs
, ...
}: {
  networking = {
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [ 3010 8081 ];
    };
  };

  services.openssh = {
    enable = true;
    ports = [ 22 2222 ];
  };
}