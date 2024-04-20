{
  description = "NeoVim configuration in a flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{self, nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system}.pkgs;
  in {
    homeManagerModules.neovim = import ./nix;
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        stylua
        pre-commit
      ];
    };
  };
}
