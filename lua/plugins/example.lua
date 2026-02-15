return {
    -- 懒加载插件（按需加载）
    {
        "folke/which-key.nvim",
        lazy = true,
        config = function()
            require("which-key").setup()
        end,
    },
}
