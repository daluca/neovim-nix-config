return {
    "catppuccin/nvim",
    tag = "v1.7.0",
    name = "catppuccin.nvim",
    dir = plugin_path("catppuccin-nvim"),
    lazy = false,
    config = function()
        vim.cmd([[colorscheme catppuccin]])
    end,
}
