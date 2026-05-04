
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*/profile/theme.lua",
    callback = function()
        dofile(vim.fn.expand("%:p"))
    end,
    desc = "Hot-reload theme.lua on save",
})