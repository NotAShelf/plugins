{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";

    # plugins from their individual repositories
    hy3.url = "github:outfoxxed/hy3";

    hyprNStack = {
      url = "github:zakk4223/hyprNStack";
      flake = false;
    };

    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      flake = false;
    };
  };

  outputs = {
    self,
    flake-parts,
    nixpkgs,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [];
      systems = ["x86_64-linux" "aarch64-linux"];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        packages = let
          lock = builtins.fromJSON (builtins.readFile ./flake.lock);
          nodes = lock.nodes;

          hyprlandBuildInputs = inputs'.hyprland.packages.hyprland.buildInputs;
          hyprlandPackages = inputs'.hyprland.packages.hyprland;
        in {
          # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
          default = pkgs.hello;

          # hy3 provides its own plugin package, no need to re-invent the wheel
          hy3 = inputs'.hy3.packages.default;

          # rest of the plugins need to be build with our derivations
          split-monitor-workspaces = pkgs.callPackage ./plugins/split-monitor-workspaces {
            lock = nodes."split-monitor-workspaces";

            inherit hyprlandBuildInputs hyprlandPackages;
          };
        };
      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.
      };
    };
}
