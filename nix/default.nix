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
    intermediate = lib.strings.removePrefix "vimplugins-" name;
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
      ];
      extraLuaConfig = ''
        local plugins = {
        ${pluginList config.programs.neovim.plugins}
        }
        local lazy_nix_helper_path = "${lazy-nix-helper-nvim}"
        if not vim.loop.fs_stat(lazy_nix_helper_path) then
          lazy_nix_helper_path = vim.fn.stdpath("data") .. "/lazy_nix_helper/lazy_nix_helper.nvim"
          if not vim.loop.fs_stat(lazy_nix_helper_path) then
            vim.fn.system({
              "git",
              "clone",
              "--filter=blob:none",
              "https://github.com/b-src/lazy_nix_helper.nvim.git",
              lazy_nix_helper_path,
            })
          end
        end

        -- add the Lazy Nix Helper plugin to the vim runtime
        vim.opt.rtp:prepend(lazy_nix_helper_path)

        -- call the Lazy Nix Helper setup function
        local non_nix_lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
        -- local lazy_nix_helper_opts = { lazypath = require("lazy-nix-helper").get_plugin_path("vimplugin-lazy.nvim"), input_plugin_table = plugins }
        local lazy_nix_helper_opts = { lazypath = non_nix_lazypath, input_plugin_table = plugins }
        require("lazy-nix-helper").setup(lazy_nix_helper_opts)

        -- get the lazypath from Lazy Nix Helper
        local lazypath_local = require("lazy-nix-helper").lazypath()
        local lazypath_nix = require("lazy-nix-helper").get_plugin_path("vimplugin-lazy.nvim")
        local lazypath
        if lazypath_nix ~= nil then
          lazypath = lazypath_nix
        else
          lazypath = lazypath_local
        end

        if not vim.loop.fs_stat(lazypath) then
          vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
          })
        end
        vim.opt.rtp:prepend(lazypath)

        -- Example using a list of specs with the default options
        vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
        vim.g.maplocalleader = "\\" -- Same for `maplocalleader`

        -- install and load plugins from your configuration
        require("lazy").setup("plugins")

        require("options")
      '';
    };
  };
}
