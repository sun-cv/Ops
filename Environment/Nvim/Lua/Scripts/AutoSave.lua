


vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI"}, {
    pattern = "*",
    callback = function()
        if vim.bo.modified and vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
            vim.cmd("silent! write")
        end
    end
})
