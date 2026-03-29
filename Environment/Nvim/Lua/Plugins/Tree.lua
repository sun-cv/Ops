

return {
    "nvim-tree/nvim-tree.lua",
    config = function()
        require("nvim-tree").setup({
            filesystem_watchers = {
                enable = true,
                debounce_delay = 50,
                ignore_dirs = {
                    "Library",
                    "Temp",
                    "obj",
                    "Logs",
                    ".vs",
                },
            },
        })
    end,
}
