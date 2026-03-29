


return {
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
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "ts_ls", "eslint", "lua_ls" },
                automatic_installation = true,
            })
        end,
    },
    {
        "seblyng/roslyn.nvim",
        ft = "cs",
        lazy = false,
        opts = {
            filewatching = "off",
            broad_search = false,
            lock_target = true,
        },
        config = function(_, opts)
            require("roslyn").setup(opts)
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "cs",
                once = true,
                callback = function()
                    vim.defer_fn(function()
                        vim.cmd("Roslyn restart")
                    end, 3000)
                end,
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "mason-org/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            vim.lsp.config("roslyn", {
                settings = {
                    ["csharp|background_analysis"] = {
                        dotnet_analyzer_diagnostics_scope = "openFiles",
                        dotnet_compiler_diagnostics_scope = "openFiles",
                    },
                },
            })
            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim", "require" } },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                    },
                },
            })
            vim.lsp.enable({"lua_ls", "roslyn" })
        end,
    },
}
