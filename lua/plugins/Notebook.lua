return {
  {
    "GCBallesteros/NotebookNavigator.nvim",
    keys = {
      {
        "]h",
        function()
          require("notebook-navigator").move_cell("d")
        end,
      },
      {
        "[h",
        function()
          require("notebook-navigator").move_cell("u")
        end,
      },
    },
    dependencies = {
      "nvim-mini/mini.comment",
      "benlubas/molten-nvim", -- alternative repl provider
      "anuvyklack/hydra.nvim",
    },
    event = "VeryLazy",
    repl_provider = "auto",
  },
}
