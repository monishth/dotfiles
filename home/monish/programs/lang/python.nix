{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (python313.withPackages (p: [
      p.material-color-utilities
      p.pyarrow
      p.pywayland
      p.pygobject3
      p.gst-python
      p.streamlit
      p.pandas
      p.numpy
      p.plotly
      p.matplotlib
      p.altair

      p.emoji
      p.regex
      p.python-dateutil
      p.nltk
      p.scikit-learn
      p.networkx
      p.pyvis
      p.jinja2
      p.requests
      p.tenacity
    ]))
  ];
}
