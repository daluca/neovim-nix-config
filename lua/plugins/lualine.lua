return {
    "nvim-lualine/lualine.nvim",
    name = "lualine.nvim",
    dir = plugin_path("lualine.nvim"),
    opts = {},
    dependencies = {
        {
            "nvim-tree/nvim-web-devicons",
            name = "nvim-web-devicons",
            dir = plugin_path("nvim-web-devicons"),
        },
    },
}
