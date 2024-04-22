return {
    "folke/which-key.nvim",
    name = "which-key.nvim",
    dir = plugin_path("which-key.nvim"),
    opts = {},
    init = function()
        vim.opt.timeout = true
        vim.opt.timeoutlen = 300
    end,
    event = "VeryLazy",
}
