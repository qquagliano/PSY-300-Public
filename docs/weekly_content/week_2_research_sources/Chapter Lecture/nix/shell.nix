let
  # NOTE: Pinned nixpkgs version for reproducability
  pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/e248589c0f8d41857070fbd3e84d1ff7a5ecd9fc.tar.gz") {};

  # NOTE: Python packages
  py_pkgs = pkgs.python3.withPackages (python-pkgs: [
    python-pkgs.numpy
    python-pkgs.pandas
    python-pkgs.scipy
  ]);

  # NOTE: R packages
  r_pkgs = builtins.attrValues {
    inherit
      (pkgs.rPackages)
      kableExtra
      knitr
      quarto
      reticulate
      sessioninfo
      ;
  };

  # NOTE: TeX packages (Full for max compatibility)
  tex_pkgs = pkgs.texliveFull;

  # NOTE: System packages
  sys_packages = builtins.attrValues {
    inherit
      (pkgs)
      git
      glibcLocales
      nix
      python312Full
      quarto
      R
      ;
  };
in
  pkgs.mkShell {
    LOCALE_ARCHIVE =
      if pkgs.system == "x86_64-linux"
      then "${pkgs.glibcLocales}/lib/locale/locale-archive"
      else "";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";

    buildInputs = [py_pkgs r_pkgs sys_packages tex_pkgs];
  }
