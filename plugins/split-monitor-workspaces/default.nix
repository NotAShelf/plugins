{
  pkgs,
  hyprlandPackages,
  hyprlandBuildInputs,
  lock,
  ...
}:
pkgs.stdenv.mkDerivation rec {
  pname = "split-monitor-workspaces";
  version = lock.locked.rev;

  src = pkgs.fetchFromGitHub {
    owner = lock.locked.owner;
    repo = lock.locked.repo;
    rev = lock.locked.rev;
    hash = lock.locked.narHash;
  };

  nativeBuildInputs = with pkgs; [cmake pkg-config];
  buildInputs = [hyprlandPackages.dev pkgs.jq pkgs.unixtools.whereis] ++ hyprlandBuildInputs;

  configurePhase = ''

  '';

  patchPhase = ''
    sed -i 's|INSTALL_LOCATION=''${HOME}/.local/share/hyprload/plugins/bin|INSTALL_LOCATION=$(shell echo $$out)|' Makefile
  '';

  buildPhase = ''
    mkdir -p $out/lib
    make all
  '';

  installPhase = ''
    cp -v ${pname}.so $out/lib/lib${pname}.so
  '';

  meta = with pkgs.lib; {
    homepage = "https://github.com/Duckonaut/split-monitor-workspaces";
    description = "A small Hyprland plugin to provide awesome-like workspace behavior ";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
