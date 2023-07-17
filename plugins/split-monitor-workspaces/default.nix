{
  inputs,
  hyprlandPackages,
  hyprlandBuildInputs,
  lib,
  stdenv,
  cmake,
  pkg-config,
  jq,
  whereis,
  ...
}:
stdenv.mkDerivation rec {
  pname = "split-monitor-workspaces";
  version = inputs.split-monitor-workspaces.rev;

  src = inputs.split-monitor-workspaces;

  nativeBuildInputs = [cmake pkg-config];
  buildInputs = [hyprlandPackages.dev jq whereis] ++ hyprlandBuildInputs;

  dontConfigure = true;

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

  meta = with lib; {
    homepage = "https://github.com/Duckonaut/split-monitor-workspaces";
    description = "A small Hyprland plugin to provide awesome-like workspace behavior ";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
