return {
  "rcarriga/nvim-notify",
  opts = {
    -- 基础配置
    timeout = 3000,
    max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.75)
    end,
    stages = "fade_in_slide_out",
    background_colour = "#000000",
  },
  
  config = function(_, opts)
    local notify = require("notify")
    notify.setup(opts)
    
    -- 直接覆盖 vim.notify
    vim.notify = notify
  end,
}
