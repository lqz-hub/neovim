-- ~/.config/nvim/lua/config/telescope-minimal.lua
return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
  },
  
  config = function()
    local telescope = require("telescope")
    
    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<Esc>"] = "close",
          },
        },
        file_ignore_patterns = {
          "node_modules", ".git", "__pycache__"
        },
      },
      extensions = {
        file_browser = {
          theme = "dropdown",
        },
      },
    })
    
    -- 加载扩展
    pcall(telescope.load_extension, "file_browser")
  end,
}
