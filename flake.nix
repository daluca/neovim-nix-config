{
  description = "NeoVim configuration in a flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{self, nixpkgs, ...}: {
    homeManagerModules.neovim = import ./nix;
  };
}
