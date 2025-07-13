return {
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvimtools/none-ls-extras.nvim",
        },
        config =
            function()
                local null_ls = require("null-ls")

                null_ls.setup({
                    sources = {
                        null_ls.builtins.formatting.stylua,
                        null_ls.builtins.completion.spell,
                        null_ls.builtins.formatting.prettier,
                        -- null_ls.builtins.diagnostics.eslint_d,
                        require("none-ls.diagnostics.eslint"), -- requires none-ls-extras.nvim
                    },
                })
            end,
        keys = {
            {
                "<leader>gf", vim.lsp.buf.format, {}, desc = "Format with none-ls"
            },
        },
    }
}
