{ pkgs, ... }:
{
  home.packages = with pkgs; [
    unstable.doctl
    kubectl
    kubernetes-helm
    unstable.asciinema
    postgresql
    unstable.redli
    unstable.lazygit
    gh
    stripe-cli
    unstable.sqlc
    unstable.sqlite
  ];
}
