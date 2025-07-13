return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({
                    global = false
                })
            end,
            desc = "Buffer Local Keymaps (which-key)"
        },
        -- { "<leader>f",  group = "file" }, -- group
        -- { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
        -- { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Live Grep", mode = "n" },
        -- { "<leader>e",
        --     function ()
        --         require
        --     end
        -- , desc = "Reveal file in Neo-tree", mode = "n" }

    }
}
