{ pkgs, ... }:
{
  home.packages = with pkgs; [
    clang
    gnumake
    clang-tools
    bear
    pkg-config
    gdb
    cmake
    unstable.valgrind
  ];
}
