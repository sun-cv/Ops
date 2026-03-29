



vim.api.nvim_create_autocmd({"BufLeave", "InsertLeave", "FocusLost", "CmdlineEnter"}, {
    pattern = "*",
    callback = function()
        if vim.bo.modified and vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
            vim.cmd("silent! noautocmd write")
        end
    end
})
