return {
    "xiyaowong/transparent.nvim",

    config = function()
        require("transparent").setup({
            extra_groups = { "NormalFloat", "NvimTreeNormal" }, -- 浮动窗口 & NvimTree
            exclude_groups = {},                    -- 不清除的组
        })
    end
}
