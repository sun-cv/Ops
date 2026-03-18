


return {
  -- Mason core with custom registry for Roslyn
  {
    "mason-org/mason.nvim",
    lazy = true,
    config = function()
      require("mason").setup({
        registries = {
          "github:Crashdummyy/mason-registry",
          "github:mason-org/mason-registry",
        },
      })
    end,
  },

  -- Mason <-> lspconfig bridge
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls",
          "eslint",
          "lua_ls",
        },
        automatic_installation = true,
      })
    end,
  },

  -- Roslyn for C#
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    opts = {
      filewatching = "roslyn",
    },
  },

  -- LSP configs
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- Node.js / TypeScript
      vim.lsp.config("ts_ls", {})
      vim.lsp.config("eslint", {
        on_attach = function(_, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
      })

      -- Lua
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
          },
        },
      })

      vim.lsp.enable({ "ts_ls", "eslint", "lua_ls" })
    end,
  },
}
