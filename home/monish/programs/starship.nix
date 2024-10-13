{ config
, pkgs
, ...
}: {
  programs.starship = {
    enable = true;
    enableTransience = true;
    settings = {
      aws.disabled = true;
      gcloud.disabled = true;
      time.disabled = false;
      time.format = "at [$time]($style)\n";
      line_break.disabled = true;
    };
  };
}
