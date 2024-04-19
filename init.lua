local lazy_nix_helper_path = vim.fn.stdpath("data") .. "/lazy/lazy-nix-helper.nvim"
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

-- set lazypath variable to the path where the Lazy plugin will be installed on your system
-- if Lazy is not already installed there, download and install it
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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

require("options")
