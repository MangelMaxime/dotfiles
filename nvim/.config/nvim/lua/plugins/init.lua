return {
    { 'echasnovski/mini.icons',   version = false },
    { 'echasnovski/mini.comment', version = false },
    {
        'echasnovski/mini.surround',
        version = false,
        config =
            function()
                require('mini.surround').setup({})
            end
    },
    {
        'echasnovski/mini.pairs',
        version = false,
        config =
            function()
                require('mini.pairs').setup({})
            end
    },
    -- {
    --     "rose-pine/neovim",
    --     name = "rose-pine",
    --     config = function()
    --         vim.cmd("colorscheme rose-pine-dawn")
    --     end
    -- },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config =
            function()
                vim.cmd("colorscheme catppuccin-frappe")
            end
    }
}
