return {
  {
    "3rd/image.nvim",
    config = function()
      require("image").setup({
        backend = "kitty",
        processor = "magick_cli", -- or "magick_rock"
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            only_render_image_at_cursor_mode = "popup", -- or "inline"
            floating_windows = false, -- if true, images will be rendered in floating markdown windows
            filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
          },
          neorg = {
            enabled = true,
            filetypes = { "norg" },
          },
          typst = {
            enabled = true,
            filetypes = { "typst" },
          },
          html = {
            enabled = false,
          },
          css = {
            enabled = false,
          },
        },
        max_width = nil,
        max_height = nil,
        max_width_window_percentage = nil,
        max_height_window_percentage = 50,
        scale_factor = 1.0,
        window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
        editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
        tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
      })
    end,
  },
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    dependencies = {
      "3rd/image.nvim",
      -- "willothy/wezterm.nvim",
    },
    build = ":UpdateRemotePlugins",
    -- init = function()
    --   vim.g.molten_auto_open_output = false -- cannot be true if molten_image_provider = "wezterm"
    --   vim.g.molten_output_show_more = true
    --   vim.g.molten_image_provider = "wezterm"
    --   vim.g.molten_output_virt_lines = true
    --   vim.g.molten_split_direction = "right" --direction of the output window, options are "right", "left", "top", "bottom"
    --   vim.g.molten_split_size = 40 --(0-100) % size of the screen dedicated to the output window
    --   vim.g.molten_virt_text_output = true
    --   vim.g.molten_use_border_highlights = true
    --   vim.g.molten_virt_lines_off_by_1 = true
    --   vim.g.molten_output_win_zindex = 50
    init = function()
      -- these are examples, not defaults. please see the readme
      -- vim.g.molten_output_win_max_height = 20
      -- vim.g.molten_auto_image_popup = true
      vim.g.molten_auto_open_output = false -- cannot be true if molten_image_provider = "wezterm"
      -- vim.g.molten_output_show_more = true
      vim.g.molten_image_provider = "none"
      vim.g.molten_output_virt_lines = true
      vim.g.molten_virt_text_output = true
      -- vim.g.molten_image_provider = "wezterm.nvim"
      vim.g.maplocalleader = "\\"
      vim.keymap.set("n", "<localleader>mi", ":molteninit<cr>", { silent = true, desc = "initialize the plugin" })
      vim.keymap.set(
        "n",
        "<localleader>e",
        ":MoltenEvaluateOperator<cr>",
        { silent = true, desc = "run operator selection" }
      )
      vim.keymap.set("n", "<localleader>rl", ":MoltenEvaluateLine<cr>", { silent = true, desc = "evaluate line" })
      vim.keymap.set("n", "<localleader>rr", ":MoltenRestart<cr>", { silent = true, desc = "restart kernel" })
      vim.keymap.set(
        "n",
        "<localleader>os",
        ":noautocmd MoltenEnterOutput<CR>",
        { desc = "open output window", silent = true }
      )
      vim.keymap.set(
        "v",
        "<localleader>r",
        ":<c-u>MoltenEvaluateVisual<cr>gv",
        { silent = true, desc = "evaluate visual selection" }
      )
    end,
  },
}
