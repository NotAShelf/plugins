{
  inputs,
  inputs',
  pkgs,
  ...
}: let
  hyprlandBuildInputs = inputs'.hyprland.packages.hyprland.buildInputs;
  hyprlandPackage = inputs'.hyprland.packages.hyprland;

  pluginBuilder = path: {name, ...}:
    pkgs.callPackage path rec {
      inherit name inputs hyprlandBuildInputs hyprlandPackage;
      src = inputs.${name};
    };
in {
  inherit pluginBuilder;
}
