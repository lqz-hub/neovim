return {
    "jghauser/kitty-runner.nvim",
    config = function()
        require("kitty-runner").setup()
        -- local opts = require("kitty-runner.config").window_config
        -- require("kitty-runner").setup(opts)
    end
}
