return {
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {},
        dependencies = {
            {
                "mason-org/mason.nvim",
                opts = {
                    ui = {
                        icons = {
                            package_installed = "✓",
                            package_pending = "➜",
                            package_uninstalled = "✗"
                        }
                    }
                }
            },
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason-lspconfig").setup {
                ensure_installed = { "lua_ls" },
            }
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.lsp.enable('lua_ls')
        end,
        keys = {
            {
                "]w",
                function()
                    vim.diagnostic.goto_next({
                        severity = vim.diagnostic.severity.WARN
                    })
                end,
                desc = "Go to next warning"
            },
            {
                "[w",
                function()
                    vim.diagnostic.goto_prev({
                        severity = vim.diagnostic.severity.WARN
                    })
                end,
                desc = "Go to previous warning"
            },
            {
                "]e",
                function()
                    vim.diagnostic.goto_next({
                        severity = vim.diagnostic.severity.ERROR
                    })
                end,
                desc = "Go to next error"
            },
            {
                "[e",
                function()
                    vim.diagnostic.goto_prev({
                        severity = vim.diagnostic.severity.ERROR
                    })
                end,
                desc = "Go to previous error"
            }
        }
    },
    {
        "ionide/ionide-vim",
        config = function()
            vim.g["fsharp#lsp_codelens"] = 0
            vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" },
                {
                    pattern = { "*.fs", "*.fsx", "*.fsi" },
                    callback = function()
                        vim.lsp.codelens.refresh()
                    end,
                    -- buffer = 0, -- current buffer
                }
            )
        end
    }
}
