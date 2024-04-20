local lazy_nix_helper_path_local = vim.fn.stdpath("data") .. "/lazy/lazy-nix-helper.nvim"
local lazy_nix_helper_path

if lazy_nix_helper_path_nix ~= nil then
    lazy_nix_helper_path = lazy_nix_helper_path_nix
else
    lazy_nix_helper_path = lazy_nix_helper_path_local
end

if not vim.loop.fs_stat(lazy_nix_helper_path) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/b-src/lazy-nix-helper.nvim.git",
        "--branch=v0.4.0",
        lazy_nix_helper_path,
    })
end

-- add the Lazy Nix Helper plugin to the vim runtime
vim.opt.rtp:prepend(lazy_nix_helper_path)

-- call the Lazy Nix Helper setup function
local non_nix_lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazy_nix_helper_opts = { lazypath = non_nix_lazypath, input_plugin_table = plugins }
require("lazy-nix-helper").setup(lazy_nix_helper_opts)

function plugin_path(plugin)
    return require("lazy-nix-helper").get_plugin_path(plugin)
end

-- get the lazypath from Lazy Nix Helper
local lazypath_nix = plugin_path("lazy.nvim")
local lazypath
if lazypath_nix ~= nil then
    lazypath = lazypath_nix
else
    lazypath = non_nix_lazypath
end

-- set lazypath variable to the path where the Lazy plugin will be installed on your system
-- if Lazy is not already installed there, download and install it
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
-- add the Lazy plugin to the vim runtime
vim.opt.rtp:prepend(lazypath)

-- set mapleader before loading lazy if applicable
vim.g.mapleader = " "

-- install and load plugins from your configuration
require("lazy").setup("plugins")

require("config")
