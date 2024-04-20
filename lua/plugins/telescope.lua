return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    name = "telescope.nvim",
    dir = plugin_path("telescope.nvim"),
    dependencies = {
        {
            "nvim-lua/plenary.nvim",
            name = "plenary.nvim",
            dir = plugin_path("plenary.nvim"),
        },
    },
}
