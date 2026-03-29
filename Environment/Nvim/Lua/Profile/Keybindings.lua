


local keymap    = require("which-key")
local harpoon   = require("harpoon")
local oil       = require("oil")
local smooth    = require("neoscroll")


-- General
vim.keymap.set("n", "<Esc>", 	"<cmd>nohlsearch<cr>", 	                                                                { desc = "Exit highlight"	    })
vim.keymap.set("i", "jj", 	    "<esc>",                                                                                { desc = "Exit insert"  	    })
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

-- Scrolling
keymap.add({ "<C>", group = "Scroll" })
keymap.add({ "<C>", group = "Scroll" })

vim.keymap.set({ "n", "v", "x" }, "<A-k>", function() smooth.scroll( -50, { move_cursor = true, duration = 200 }) end,  { desc = "Scroll up 50 lines"   })
vim.keymap.set({ "n", "v", "x" }, "<A-j>", function() smooth.scroll(  50, { move_cursor = true, duration = 200 }) end,  { desc = "Scroll down 50 lines" })
vim.keymap.set({ "n", "v", "x" }, "<C-k>", function() smooth.scroll( -25, { move_cursor = true, duration = 100 }) end,  { desc = "Scroll up 25 lines"   })
vim.keymap.set({ "n", "v", "x" }, "<C-j>", function() smooth.scroll(  25, { move_cursor = true, duration = 100 }) end,  { desc = "Scroll down 25 lines" })
vim.keymap.set({ "n", "v", "x" }, "<S-k>", function() smooth.scroll(  -5, { move_cursor = true, duration =  25 }) end,  { desc = "Scroll up 5 lines"    })
vim.keymap.set({ "n", "v", "x" }, "<S-j>", function() smooth.scroll(   5, { move_cursor = true, duration =  25 }) end,  { desc = "Scroll down 5 lines"  })
vim.keymap.set({ "n", "v", "x" }, "zt",    function() smooth.zt({ half_win_duration = 50 }) end,                        { desc = "Scroll top of screen" })
vim.keymap.set({ "n", "v", "x" }, "zz",    function() smooth.zz({ half_win_duration = 50 }) end,                        { desc = "Scroll center screen" })
vim.keymap.set({ "n", "v", "x" }, "zb",    function() smooth.zb({ half_win_duration = 50 }) end,                        { desc = "Scroll bottom screen" })
-- Buffer
keymap.add({ "<leader>b", group = "Buffer" })
vim.keymap.set("n", "<Tab>",      "<cmd>BufferNext<cr>",                                                                { desc = "Next buffer"          })
vim.keymap.set("n", "<S-Tab>",    "<cmd>BufferPrevious<cr>",     	                                                    { desc = "Prev buffer"          })
vim.keymap.set("n", "<leader>bb", "<cmd>BufferClose<cr>",                                                               { desc = "Close buffer"         })
vim.keymap.set("n", "<leader>bd", function() vim.cmd("Alpha") end,                                                      { desc = "Dashboard" } )

-- Harpoon
keymap.add({ "<leaderh>", group = "harpoon" })
vim.keymap.set("n", "<leader>ha",  function() harpoon:list():add() end,                                                 { desc = "Add to harpoon"       })
vim.keymap.set("n", "<leader>hm",  function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,                         { desc = "Harpoon menu"         })
vim.keymap.set("n", "<leader>h1",  function() harpoon:list():select(1) end,                                             { desc = "Harpoon file 1"       })
vim.keymap.set("n", "<leader>h2",  function() harpoon:list():select(2) end,                                             { desc = "Harpoon file 2"       })
vim.keymap.set("n", "<leader>h3",  function() harpoon:list():select(3) end,                                             { desc = "Harpoon file 3"       })
vim.keymap.set("n", "<leader>h4",  function() harpoon:list():select(4) end,                                             { desc = "Harpoon file 4"       })
vim.keymap.set("n", "<leader>h5",  function() harpoon:list():select(5) end,                                             { desc = "Harpoon file 5"       })

-- Find
keymap.add({ "<leader>f", group = "Find"})
vim.keymap.set("n", "ff",   "/",                                                                                        { desc = "Search file"          })
vim.keymap.set("n", "<leader>ff",  "<cmd>Telescope find_files<cr>",                                                     { desc = "Find files"           })
vim.keymap.set("n", "<leader>fg",  "<cmd>Telescope live_grep<cr>",                                                      { desc = "Live grep"            })
vim.keymap.set("n", "<leader>fd",function() vim.cmd("cd " .. require("oil").get_current_dir()) end,                     { desc = "CD to oil directory"  })
vim.keymap.set('n', 'n', 'nzz',                                                                                         { desc = "Recent on search"     })
vim.keymap.set('n', 'N', 'Nzz',                                                                                         { desc = "Recent on search"     })
vim.keymap.set('n', '*', '*zz',                                                                                         { desc = "Recent on search"     })
vim.keymap.set('n', '#', '#zz',                                                                                         { desc = "Recent on search"     })

-- LSP
keymap.add({ "<leader>d", group = "Definition" })
vim.keymap.set("n", "<leader>dd",  vim.lsp.buf.definition,                                                              { desc = "Go to definition"     })
vim.keymap.set("n", "<leader>dt",  vim.lsp.buf.type_definition,                                                         { desc = "Type definition"      })
vim.keymap.set("n", "<leader>dr",  vim.lsp.buf.rename,                                                                  { desc = "Rename"               })
vim.keymap.set("n", "<leader>df",  vim.lsp.buf.references,                                                              { desc = "References"           })
vim.keymap.set("n", "<leader>da",  vim.lsp.buf.code_action,                                                             { desc = "Code action"          })
vim.keymap.set("n", "<leader>dh",  vim.lsp.buf.hover,                                                                   { desc = "Hover"                })

keymap.add({ "<leader>h", group = "Highlight" })
vim.keymap.set("n", "<leader>ht", "<cmd>HighlightColors Toggle<cr>",                                                    { desc = "Toggle color light"   })

-- Cursor
keymap.add({ "<leader>s", group = "Select" })
vim.keymap.set("n", "<leader>sj",   "<Plug>(VM-Add-Cursor-Down)",                                                       { desc = "Add cursor down"      })
vim.keymap.set("n", "<leader>sk",   "<Plug>(VM-Add-Cursor-Up)",                                                         { desc = "Add cursor up"        })
vim.keymap.set("n", "<leader>sv",   '<C-v>',                                                                            { desc = 'Visual block mode'    })

-- Comments
keymap.add({ "<leader>c", group = "Comment" })
vim.keymap.set("n", "<leader>cc",   "<cmd>normal gcc<cr>",                                                              { desc = "Toggle line comment"  })
vim.keymap.set("n", "<leader>cb",   "<cmd>normal gbc<cr>",                                                              { desc = "Toggle block comment" })
vim.keymap.set("v", "<leader>cc",   "<cmd>normal gcc<cr>",                                                              { desc = "Toggle line comment"  })
vim.keymap.set("v", "<leader>cb",   "<cmd>normal gbc<cr>",                                                              { desc = "Toggle block comment" })

-- Selection movement
vim.keymap.set("v", "<S-j>", ":m '>+1<CR>gv=gv",                                                                        { desc = "Move selection down", silent = true, noremap = true })
vim.keymap.set("v", "<S-k>", ":m '<-2<CR>gv=gv",                                                                        { desc = "Move selection up",   silent = true, noremap = true })

-- Error handling
keymap.add({ "<leader>e", group = "Errors" })
vim.keymap.set("n", "<leader>ee",  vim.diagnostic.open_float,                                                           { desc = "Show error"           })
vim.keymap.set("n", "<leader>ek",  function() vim.diagnostic.jump({ count = -1 }) end,                                  { desc = "Previous diagnostic"  })
vim.keymap.set("n", "<leader>ej",  function() vim.diagnostic.jump({ count =  1 }) end,                                  { desc = "Next diagnostic"      })

-- Undo
keymap.add({ "<leader>u", group = "Undo" })
vim.keymap.set("n", "<leader>uh", "<cmd>UndotreeToggle<cr>",                                                            { desc = "Undo tree"            })

-- Terminal
vim.keymap.set("n", "<leader>jj", "<cmd>ToggleTerm<cr>",                                                                { desc = "Toggle terminal"      })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>",                                                                             { desc = "Exit terminal mode"   })
vim.keymap.set("n", "<leader>jd", function()
    for _, term in ipairs(
        require("toggleterm.terminal").get_all())
            do term:send("cd " .. require("oil").get_current_dir()) end
        end,                                                                                                            { desc = "CD to terminal directory" })

-- Filetree
vim.keymap.set("n", "<leader>t", function()
    if oil.get_current_dir() then
        oil.discard_all_changes()
        require("oil.actions").parent.callback()
    else
        oil.discard_all_changes()
        oil.open_float(nil, { preview = { vertical = true } })
    end
end, { desc = "Open file explorer / go up" })

