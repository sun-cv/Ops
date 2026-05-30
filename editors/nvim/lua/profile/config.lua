


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
vim.opt.timeoutlen                      = 300
vim.opt.updatetime                      = 500
vim.opt.cmdheight                       = 0
vim.opt.shortmess 		                = "filnxtToOFsIc"
vim.opt.fillchars                       :append({ eob = ' ' })

vim.g.undotree_SplitWidth               = 40
vim.g.undotree_SetFocusWhenToggle       =  1

-- vim.lsp.document_color.enable(false)

vim.lsp.handlers["textDocument/hover"] = function(_, _, _, config)
  config = config or {}
  config.focusable = false
  config.silent = true
  return vim.lsp.buf.hover()
end -- Prevent the hover documentation popup from being focusable

vim.api.nvim_create_autocmd("TextYankPost", { callback = function() vim.highlight.on_yank() end })

vim.lsp.config("lua_ls", { settings = { Lua = { workspace = { library = vim.api.nvim_get_runtime_file("", true) }}}})


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
        vim.diagnostic.enable(false)
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


