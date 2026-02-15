return {
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      -- 设置 pdf 阅读器；macOS 可设置为 skim

      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_view_general_options = "-r @line @pdf @tex"
      -- 编译报错时不自动弹出错误窗口 :copen 手动打开
      vim.g.vimtex_quickfix_mode = 0
      -- 编译出现警告时，Quickfix 窗口在非焦点状态下打开，但不会自动切换到该窗口
      vim.g.vimtex_quickfix_open_on_warning = 2
      -- 指定 LaTeX 风格
      vim.g.tex_flavor = "latex"
      -- 使用 latexmk

      vim.g.vimtex_compiler_method = "latexmk"
      -- latex 编译参数
      vim.g.vimtex_compiler_latexmk = {
        options = {
          "-xelatex",
          "-pdf",
          "-shell-escape",
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
          "-auxdir=./aux/",
        },
      }
    end,
    -- 仅在编辑 tex/latex 文件时加载
    ft = { "tex", "latex" },
  },
} -- 最后一行不能有空行
