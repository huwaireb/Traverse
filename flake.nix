{
  description = ''
    huwaireb/Traverse: An iOS App to navigate campuses, using IMDF. Built with Xcode (SP)  Topics
  '';

  outputs =
    inputs:
    inputs.parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        { pkgs, ... }:
        let
          llvmPackages = pkgs.llvmPackages_19;
          inherit (llvmPackages) stdenv;
        in
        {
          devShells.default = pkgs.mkShell.override { inherit stdenv; } {
            packages = builtins.attrValues {
              inherit (pkgs) typst tinymist;
              ccls = pkgs.ccls.override { inherit llvmPackages; };
            };
          };
        };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };
}
