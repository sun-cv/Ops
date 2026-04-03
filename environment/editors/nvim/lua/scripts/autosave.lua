


vim.api.nvim_create_autocmd({"InsertLeave", "FocusLost", "CmdlineEnter"}, {
    pattern = "*",
    callback = function()
        if vim.bo.modified and vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
            vim.cmd("silent! noautocmd write")
            vim.api.nvim_exec_autocmds("BufWritePost", { buffer = 0 })
        end
    end
})
