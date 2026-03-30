


vim.opt.winborder		                = "rounded"
vim.opt.tabstop 		                = 4
vim.opt.shiftwidth 		                = 4
vim.opt.expandtab 		                = true
vim.opt.softtabstop 	                = 4
vim.opt.number 			                = true
vim.opt.relativenumber 	                = true
vim.opt.wrap	 		                = false
vim.opt.termguicolors	                = true
vim.opt.undofile 		                = true
vim.opt.incsearch 		                = true
vim.opt.ignorecase                      = true
vim.opt.smartcase                       = true
vim.opt.signcolumn 		                = "yes"
vim.opt.swapfile 		                = false
vim.opt.showmode 		                = false
vim.opt.cmdheight 		                = 0;
vim.opt.timeoutlen                      = 300
vim.opt.shortmess 		                = "filnxtToOFsIc"
vim.opt.fillchars                       :append({ eob = ' ' })      -- Replace the ~ symbols shown on empty lines after end-of-file with a space (cleaner look)


vim.g.undotree_SplitWidth               = 40                        -- Undotree panel width in columns
vim.g.undotree_SetFocusWhenToggle       =  1                        -- Automatically focus the undotree panel when you open it


vim.lsp.handlers["textDocument/hover"]  = vim.lsp.with(vim.lsp.handlers.hover, { focusable = false, silent = true })    -- Prevent the hover documentation popup from being focusable
vim.api.nvim_create_autocmd("TextYankPost", { callback = function() vim.highlight.on_yank() end })                      -- Briefly highlight yanked text so you can see what was copied
vim.lsp.config("lua_ls", { settings = { Lua = { workspace = { library = vim.api.nvim_get_runtime_file("", true) }}}})   -- Tell lua_ls about all Neovim's runtime files so it stops flagging vim.* APIs as unknown


-- vim.api.nvim_create_autocmd("VimLeave", {
--     callback = function()
--         vim.lsp.stop_client(vim.lsp.get_clients(), true)
--     end
-- })


-- Disable auto-continuation of comments when pressing Enter or o/O in any filetype.
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove({ "c", "r", "o" }) -- 'c' = wrap comments, 'r' = continue on Enter, 'o' = continue on o/O
    end,
})

-- Visual Multi (multi-cursor) enters: turn off inlay hints and diagnostics to reduce noise
vim.api.nvim_create_autocmd('User', {
    pattern = 'VMEnter',
    callback = function()
        vim.lsp.inlay_hint.enable(false)
        vim.diagnostic.disable()
    end
})

-- Visual Multi (multi-cursor) exits: restore inlay hints and diagnostics
vim.api.nvim_create_autocmd('User', {
    pattern = 'VMLeave',
    callback = function()
        vim.lsp.inlay_hint.enable(true)
        vim.diagnostic.enable()
    end
})

-- After a / or ? search, pressing Enter also centers the screen on the match (zz)
vim.keymap.set('c', '<CR>', function()
    local cmdtype = vim.fn.getcmdtype()
    if cmdtype == '/' or cmdtype == '?' then
        return '<CR>zz'
    end
    return '<CR>'
end, { expr = true })


