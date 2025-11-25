{
  flake,
  inputs,
  pkgs,
  ...
}:
# treefmt with config
let
  formatter = inputs.treefmt-nix.lib.mkWrapper pkgs {
    _file = ./default.nix;
    package = pkgs.treefmt;

    projectRootFile = ".git/config";

    programs.deadnix.enable = true;
    programs.nixfmt.enable = true;

    settings.formatter.deadnix.pipeline = "nix";
    settings.formatter.deadnix.priority = 1;
    settings.formatter.nixfmt.pipeline = "nix";
    settings.formatter.nixfmt.priority = 2;
  };

  check =
    pkgs.runCommand "format-check"
      {
        nativeBuildInputs = [
          formatter
          pkgs.git
        ];

        # only check on Linux
        meta.platforms = pkgs.lib.platforms.linux;
      }
      ''
        export HOME=$NIX_BUILD_TOP/home

        # keep timestamps so that treefmt is able to detect mtime changes
        cp --no-preserve=mode --preserve=timestamps -r ${flake} source
        cd source
        git init --quiet
        git add .
        treefmt --no-cache
        if ! git diff --exit-code; then
          echo "-------------------------------"
          echo "aborting due to above changes ^"
          exit 1
        fi
        touch $out
      '';
in
formatter
// {
  passthru = formatter.passthru // {
    tests = {
      check = check;
    };
  };
}
