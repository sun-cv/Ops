


local keymap    = require("which-key")
local harpoon   = require("harpoon")
local smooth    = require("neoscroll")

local module    = require("functions.keybindings")

-- General
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", 	                                                                { desc = "Exit highlight"	    })
vim.keymap.set("i", "jj", 	 "<esc>",                                                                                   { desc = "Exit insert"  	    })
vim.keymap.set("n", "<C-j>", "<C-d>zz",                                                                                 { desc = "page down centered"   })
vim.keymap.set("n", "<C-k>", "<C-u>zz",                                                                                 { desc = "page up centered"     })
vim.keymap.set("n", ";;",    "zz",                                                                                      { desc = "page up centered"     })

-- Window
keymap.add({ "<leader>w", group = "Window" })
vim.keymap.set("n", "<leader>wh", "<C-w>h", 				                                                            { desc = "Move to left split"   })
vim.keymap.set("n", "<leader>wl", "<C-w>l", 				                                                            { desc = "Move to right split"  })
vim.keymap.set("n", "<leader>wj", "<C-w>j", 			                                                                { desc = "Move to lower split"  })
vim.keymap.set("n", "<leader>wk", "<C-w>k", 			                                                                { desc = "Move to upper split"  })
vim.keymap.set("n", "<leader>wv", "<cmd>vsp<cr>",                                                                       { desc = "Split vertical"       })
vim.keymap.set("n", "<leader>wd", "<cmd>sp<cr>",                                                                        { desc = "Split horizontal"     })
vim.keymap.set("n", "<leader>wx", "<cmd>close<cr>",                                                                     { desc = "Close split"          })

-- Buffer
keymap.add({ "<leader>b", group = "Buffer" })
vim.keymap.set("n", "<Tab>",      "<cmd>BufferNext<cr>",                                                                { desc = "Next buffer"          })
vim.keymap.set("n", "<S-Tab>",    "<cmd>BufferPrevious<cr>",     	                                                    { desc = "Prev buffer"          })
vim.keymap.set("n", "<leader>bb", function() vim.cmd("write") vim.cmd("BufferClose") end,                               { desc = "Save Close buffer"    })
vim.keymap.set("n", "<leader>be", function() vim.cmd("BufferClose") end,                                                { desc = "No Save Close buffer" })
vim.keymap.set("n", "<leader>bd", function() vim.cmd("Alpha") end,                                                      { desc = "Dashboard"            })
vim.keymap.set("n", "<leader>ba", module.CloseAllBuffers,                                                               { desc = "Close all buffers"    })

-- Scrolling
keymap.add({ "<C>", group = "Scroll" })
vim.keymap.set({ "n", "v", "x" }, "<a-k>", function() smooth.scroll( -50, { move_cursor = true, duration = 100 }) end,  { desc = "Scroll up 50 lines"   })
vim.keymap.set({ "n", "v", "x" }, "<A-j>", function() smooth.scroll(  50, { move_cursor = true, duration = 100 }) end,  { desc = "Scroll down 50 lines" })
vim.keymap.set({ "n", "v", "x" }, "<C-k>", function() smooth.scroll( -25, { move_cursor = true, duration =  60 }) end,  { desc = "Scroll up 25 lines"   })
vim.keymap.set({ "n", "v", "x" }, "<C-j>", function() smooth.scroll(  25, { move_cursor = true, duration =  60 }) end,  { desc = "Scroll down 25 lines" })
vim.keymap.set({ "n", "v", "x" }, "<S-k>", function() smooth.scroll(  -5, { move_cursor = true, duration =  20 }) end,  { desc = "Scroll up 5 lines"    })
vim.keymap.set({ "n", "v", "x" }, "<S-j>", function() smooth.scroll(   5, { move_cursor = true, duration =  20 }) end,  { desc = "Scroll down 5 lines"  })
vim.keymap.set({ "n", "v", "x" }, "zt",    function() smooth.zt({ half_win_duration = 50 }) end,                        { desc = "Scroll top of screen" })
vim.keymap.set({ "n", "v", "x" }, "zz",    function() smooth.zz({ half_win_duration = 50 }) end,                        { desc = "Scroll center screen" })
vim.keymap.set({ "n", "v", "x" }, "zb",    function() smooth.zb({ half_win_duration = 50 }) end,                        { desc = "Scroll bottom screen" })

-- Filetree
keymap.add({ "<leader>t", group = "File Tree" })
vim.keymap.set("n", "<leader>t", module.OpenFileTree,                                                                   { desc = "file explorer/go up"  })

-- Find
keymap.add({ "<leader>f", group = "Find"})
vim.keymap.set("n", "ff",   "/",                                                                                        { desc = "Search file"          })
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>",                                                      { desc = "Find files"           })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>",                                                       { desc = "Live grep"            })
vim.keymap.set("n", "<leader>fd",  function() vim.cmd("cd " .. require("oil").get_current_dir()) end,                   { desc = "CD to oil directory"  })
vim.keymap.set('n', 'n', 'nzz',                                                                                         { desc = "Recent on search"     })
vim.keymap.set('n', 'N', 'Nzz',                                                                                         { desc = "Recent on search"     })
vim.keymap.set('n', '*', '*zz',                                                                                         { desc = "Recent on search"     })
vim.keymap.set('n', '#', '#zz',                                                                                         { desc = "Recent on search"     })

-- LSP
keymap.add({ "<leader>d", group = "Definition" })
vim.keymap.set("n", "<leader>dd", vim.lsp.buf.definition,                                                               { desc = "Go to definition"     })
vim.keymap.set("n", "<leader>dt", vim.lsp.buf.type_definition,                                                          { desc = "Type definition"      })
vim.keymap.set("n", "<leader>dr", vim.lsp.buf.rename,                                                                   { desc = "Rename"               })
vim.keymap.set("n", "<leader>df", vim.lsp.buf.references,                                                               { desc = "References"           })
vim.keymap.set("n", "<leader>da", vim.lsp.buf.code_action,                                                              { desc = "Code action"          })
vim.keymap.set("n", "<leader>dh", vim.lsp.buf.hover,                                                                    { desc = "Hover"                })

-- Undo
keymap.add({ "<leader>u", group = "Undo" })
vim.keymap.set("n", "<leader>uh", "<cmd>UndotreeToggle<cr>",                                                            { desc = "Undo tree"            })

-- Error handling
keymap.add({ "<leader>e", group = "Errors" })
vim.keymap.set("n", "<leader>ee", vim.diagnostic.open_float,                                                            { desc = "Show error"           })
vim.keymap.set("n", "<leader>ek", function() vim.diagnostic.jump({ count = -1 }) end,                                   { desc = "Previous diagnostic"  })
vim.keymap.set("n", "<leader>ej", function() vim.diagnostic.jump({ count =  1 }) end,                                   { desc = "Next diagnostic"      })
vim.keymap.set("n", "<leader>ea", vim.lsp.buf.code_action,                                                              { desc = "Code actions"         })

-- Terminal
keymap.add({ "<leader>j", group = "Terminal" })
vim.keymap.set("n", "<leader>jj", "<cmd>ToggleTerm<cr>",                                                                { desc = "Toggle terminal"      })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>",                                                                             { desc = "Exit terminal mode"   })
vim.keymap.set("n", "<leader>jd", module.TerminalToDirectory,                                                           { desc = "CD to terminal dir"   })

-- Register
keymap.add({ "<leader>r", group = "Register" })
vim.keymap.set({"n", "v"}, "<leader>r",   function() return '"'   end,                                                  { expr = true, desc = "access register"      })
vim.keymap.set({"n", "v"}, "<leader>ry",  function() return '"+y' end,                                                  { expr = true, desc = "Yank to clipboard register"})
vim.keymap.set({"n", "v"}, "<leader>rb",  function() return '"_' end,                                                   { expr = true, desc = "Black Hole"})
vim.keymap.set({"n", "v"}, "<leader>rv", "<cmd>reg<cr>",                                                                { desc = "View register"})

-- Comments
keymap.add({ "<leader>c", group = "comment" })
vim.keymap.set({"n", "v"}, "<leader>cc", "<cmd>normal gcc<cr>",                                                         { desc = "Toggle line comment"  })
vim.keymap.set({"n", "v"}, "<leader>cb", "<cmd>normal gbc<cr>",                                                         { desc = "Toggle block comment" })

-- Harpoon
keymap.add({ "<leaderh>", group = "harpoon" })
vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end,                                                  { desc = "Add to harpoon"       })
vim.keymap.set("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,                          { desc = "Harpoon menu"         })
vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end,                                              { desc = "Harpoon file 1"       })
vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end,                                              { desc = "Harpoon file 2"       })
vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end,                                              { desc = "Harpoon file 3"       })
vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end,                                              { desc = "Harpoon file 4"       })
vim.keymap.set("n", "<leader>h5", function() harpoon:list():select(5) end,                                              { desc = "Harpoon file 5"       })
keymap.add({ "<leader>h", group = "Highlight" })
vim.keymap.set("n", "<leader>ht", "<cmd>HighlightColors Toggle<cr>",                                                    { desc = "Toggle color light"   })

-- Cursor
keymap.add({ "<leader>s", group = "Select" })
vim.keymap.set("n", "<leader>sj", "<Plug>(VM-Add-Cursor-Down)",                                                         { desc = "Add cursor down"      })
vim.keymap.set("n", "<leader>sk", "<Plug>(VM-Add-Cursor-Up)",                                                           { desc = "Add cursor up"        })
vim.keymap.set("n", "<leader>sv", '<C-v>',                                                                              { desc = 'Visual block mode'    })

-- Selection movement
keymap.add({ "<leader><S>", group = "Selection" })
vim.keymap.set("v", "<S-j>", ":m '>+1<CR>gv=gv",                                                                        { desc = "Move selection down", silent = true, noremap = true })
vim.keymap.set("v", "<S-k>", ":m '<-2<CR>gv=gv",                                                                        { desc = "Move selection up",   silent = true, noremap = true })

-- Text Manipulation
keymap.add({ "<leader>m", group = "Text Manipulation" })
vim.keymap.set("n", "<leader>o", "o<esc>",                                                                              { desc = "line below - no insert" })
vim.keymap.set("n", "<leader>O", "O<esc>",                                                                              { desc = "line above - no insert" })

-- Claude Code
keymap.add({ "<leader>a", group = "AI" })
vim.keymap.set("n", "<leader>at", "<cmd>ClaudeCode<cr>",            { desc = "Toggle Claude"   })
vim.keymap.set("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       { desc = "Focus Claude"    })
vim.keymap.set("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   { desc = "Resume Claude"   })
vim.keymap.set("n", "<leader>ac", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue Claude" })
vim.keymap.set("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Select model"    })
vim.keymap.set("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       { desc = "Add buffer"      })
vim.keymap.set("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>",        { desc = "Send selection"  })
vim.keymap.set("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>",  { desc = "Accept diff"     })
vim.keymap.set("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",    { desc = "Deny diff"       })



