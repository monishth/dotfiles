{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (python311.withPackages (p: [
      p.material-color-utilities
      p.pywayland
      p.pygobject3
      p.gst-python
    ]))
  ];
}
