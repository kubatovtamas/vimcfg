return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
        vim.keymap.set("n", "<leader>/", ":Neotree toggle current reveal_force_cwd<cr>", { desc = "Neotree Toggle CWD"})
        --vim.keymap.set("n", "<leader>nt", ":Neotree filesystem reveal left<CR>")
        --vim.keymap.set("n", "<leader>lt", ":Neotree toggl<CR>")
    end
}
