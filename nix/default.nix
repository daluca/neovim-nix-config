{ config, lib, pkgs, ... }: let
  lazy-nix-helper-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "lazy-nix-helper.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "b-src";
      repo = "lazy-nix-helper.nvim";
      rev = "v0.4.0";
      hash = "sha256-TBDZGj0NXkWvJZJ5ngEqbhovf6RPm9N+Rmphz92CS3Q=";
    };
  };

  sanitizePluginName = input:
  let
    name = lib.strings.getName input;
    intermediate = lib.strings.removePrefix "vimplugin-" name;
    result = lib.strings.removePrefix "lua5.1-" intermediate;
  in result;

  pluginList = plugins: lib.strings.concatMapStrings (plugin: "  [\"${sanitizePluginName plugin.name}\"] = \"${plugin.outPath}\",\n") plugins;
in with lib; {
  options.neovim-nix = {
    enable = mkEnableOption "NeoVim nix";
  };

  config = mkIf config.neovim-nix.enable {
    xdg.configFile."nvim/lua" = {
      source = ../lua;
      recursive = true;
    };

    home.packages = with pkgs; [
      fd
      ripgrep
    ];

    programs.neovim = {
      enable = true;
      package = pkgs.neovim-unwrapped;
      plugins = with pkgs.vimPlugins; [
        lazy-nix-helper-nvim
        lazy-nvim
        telescope-nvim
        plenary-nvim
        catppuccin-nvim
      ];
      extraLuaConfig = ''
        -- Provide nix-store plugin paths
        local plugins = {
        ${pluginList config.programs.neovim.plugins}
        }
        local lazy_nix_helper_path_nix = "${lazy-nix-helper-nvim}"
        -- Normal init.lua file from this point onwards
      '' + (builtins.readFile ../init.lua);
    };
  };
}
