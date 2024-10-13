{
  config,
  pkgs,
  ...
}: {
  users.users.monish = {
    isNormalUser = true;
    description = "Monish Thirukumaran";
    extraGroups = ["networkmanager" "wheel" "docker" "input"];
    shell = pkgs.fish;
    packages = with pkgs; [
      thunderbird
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEyQWE7fW+AtR8BOu2TAb5eQM5Va0/ab8ERuAVZlQ1m monish.thir@gmail.com"
    ];
  };
}
