{
  pkgs,
  hyprlandPackages,
  hyprlandBuildInputs,
  owner ? "",
  repo ? "",
  hash ? "",
  rev ? "",
  ...
}:
pkgs.stdenv.mkDerivation {
  pname = repo;
  version = rev;
  src = pkgs.fetchFromGitHub {
    owner = owner;
    repo = repo;
    rev = rev;
    hash = hash;
  };

  nativeBuildInputs = with pkgs; [cmake pkg-config];

  buildInputs = with pkgs;
    [
      hyprlandPackages.dev
      pango
      cairo
    ]
    ++ hyprlandBuildInputs;

  # no noticeable impact on performance and greatly assists debugging
  cmakeBuildType = "Debug";
  dontStrip = true;

  meta = with pkgs.lib; {
    homepage = "https://github.com/outfoxxed/hy3";
    description = "Hyprland plugin for an i3 / sway like manual tiling layout";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
