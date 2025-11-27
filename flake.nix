{
  description = "Ziglings development environment with Zig 0.16";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # Zig overlay for specific versions
    zig-overlay.url = "github:mitchellh/zig-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      zig-overlay,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        # Get Zig 0.15 from the overlay (or latest 0.15 dev build)
        zigPkgs = zig-overlay.packages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Zig 0.15 - use a recent 0.15 dev build for latest features
            # (zigPkgs."master-2025-07-24" or zigPkgs.master)
            (zigPkgs."master-2025-08-19" or zigPkgs.master)
            # ZLS from nixpkgs (should be compatible with Zig 0.15)
            zls
            # Development tools
            git
            which
            lgpio
            # GPIO library for Raspberry Pi
            libgpiod
          ];

        };
      }
    );
}
