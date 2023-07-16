{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";

    hy3.url = "github:outfoxxed/hy3";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    ...
  }:
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

          hy3 = pkgs.callPackage ./builder.nix {
            owner = nodes.hy3.locked.owner;
            repo = nodes.hy3.locked.repo;
            hash = nodes.hy3.locked.narHash;
            rev = nodes.hy3.locked.rev;
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
