

vim.opt.winborder		= "rounded"
vim.opt.tabstop 		= 4
vim.opt.shiftwidth 		= 4
vim.opt.expandtab 		= true
vim.opt.softtabstop 	= 4
vim.opt.number 			= true
vim.opt.relativenumber 	= true
vim.opt.wrap	 		= false
vim.opt.termguicolors	= true
vim.opt.undofile 		= true
vim.opt.incsearch 		= true
vim.opt.ignorecase      = true
vim.opt.smartcase       = true
vim.opt.signcolumn 		= "yes"
vim.opt.wrap	 		= false
vim.opt.swapfile 		= false
vim.opt.showmode 		= false
vim.opt.cmdheight 		= 0;
--vim.opt.timeoutlen      = 300

vim.opt.shortmess 		= "filnxtToOFsIc"

vim.lsp.config("lua_ls", { settings = { Lua = { workspace = { library = vim.api.nvim_get_runtime_file("", true), }}}})
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { focusable = false, silent = true })

vim.opt.fillchars:append({ eob = ' ' })

vim.g.undotree_SplitWidth = 40
vim.g.undotree_SetFocusWhenToggle = 1

vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#ffb454" })
vim.api.nvim_create_autocmd("TextYankPost", {callback = function() vim.highlight.on_yank() end })
