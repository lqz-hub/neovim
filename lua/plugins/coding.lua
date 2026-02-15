return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true, -- use opts = {} for passing setup options
  },
  {
    "kylechui/nvim-surround",
    version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
  { "terryma/vim-multiple-cursors" },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          custom_filter = function(buf_number, _)
            if vim.bo[buf_number].filetype == "qf" then
              return false
            end

            return true
          end,
        },
      })
    end,
  },
  { "preservim/nerdtree" },
}
