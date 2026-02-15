return {
  "hrsh7th/nvim-cmp",
  lazy = true,
  dependencies = {

    -- 补全源
    "luozhiya/fittencode.nvim",
    "hrsh7th/cmp-buffer", -- 缓冲区单词补全
    "hrsh7th/cmp-path", -- 路径补全
    "hrsh7th/cmp-cmdline", -- 命令行补全
    "hrsh7th/cmp-nvim-lsp", -- LSP补全

    -- 代码片段支持
    "honza/vim-snippets",
    "SirVer/ultisnips",
    "quangnguyen30192/cmp-nvim-ultisnips",

    -- 其他有用源（可选）
    "hrsh7th/cmp-nvim-lua", -- nvim配置API补全
    "hrsh7th/cmp-nvim-lsp-signature-help", -- 函数签名帮助
  },
  config = function()
    require("fittencode").setup({
      completion_mode = "source",
    })
    local lspkind = require("lspkind")
    local cmp = require("cmp")
    require("cmp_nvim_ultisnips").setup({})
    local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
    cmp.setup({
      -- 配置代码片段引擎
      snippet = {
        expand = function(args)
          vim.fn["UltiSnips#Anon"](args.body)
        end,
      },

      -- 快捷键映射
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(), -- 触发补全
        ["<C-e>"] = cmp.mapping.abort(), -- 关闭补全
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true, -- 回车时选择第一个项目
        }),

        -- Tab键映射
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            cmp_ultisnips_mappings.jump_backwards(fallback)
          end
        end, { "i", "s" }),
      }),

      -- 补全源配置
      sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 1000 }, -- LSP源，优先级最高
        { name = "ultisnips", priority = 750 }, -- 代码片段
        { name = "buffer", priority = 500 }, -- 缓冲区
        { name = "path", priority = 250 }, -- 路径
        { name = "fittencode", priority = 1500 },
      }),
      -- 格式化显示
      formatting = {
        format = lspkind.cmp_format({
          -- 显示模式
          mode = "symbol_text", -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'

          -- 最大宽度（防止补全窗口太宽）
          maxwidth = 50,

          -- 内容过长时显示省略号
          ellipsis_char = "...",

          -- 在符号前显示菜单标签
          menu = {
            buffer = "[Buffer]",
            nvim_lsp = "[LSP]",
            luasnip = "[Snip]",
            nvim_lua = "[Lua]",
            latex_symbols = "[Latex]",
            path = "[Path]",
            cmdline = "[Cmd]",
            fittenCode = "[AI]",
            codeium = "[Codeium]",
            copilot = "[Copilot]",
          },

          -- 是否显示补全源名称
          show_labelDetails = true,

          -- 自定义符号（可覆盖预设）
          symbol_map = {
            Text = "󰉿",
            Method = "󰆧",
            Function = "󰊕",
            Constructor = "",
            Field = "󰜢",
            Variable = "󰀫",
            Class = "󰠱",
            Interface = "",
            Module = "",
            Property = "󰜢",
            Unit = "󰑭",
            Value = "󰎠",
            Enum = "",
            Keyword = "󰌋",
            Snippet = "",
            Color = "󰏘",
            File = "󰈙",
            Reference = "󰈇",
            Folder = "󰉋",
            EnumMember = "",
            Constant = "󰏿",
            Struct = "󰙅",
            Event = "",
            Operator = "󰆕",
            TypeParameter = "",
            Codeium = "",
            fittencode = "",
          },

          -- 自定义每个来源的样式
          before = function(entry, vim_item)
            -- 根据来源设置不同的图标颜色
            local hl_group = ({
              nvim_lsp = "CmpItemKindClass",
              buffer = "CmpItemKindBuffer",
              luasnip = "CmpItemKindSnippet",
              nvim_lua = "CmpItemKindFunction",
              path = "CmpItemKindFile",
              cmdline = "CmpItemKindCmdLine",
            })[entry.source.name]

            if hl_group then
              vim_item.kind_hl_group = hl_group
            end

            return vim_item
          end,
        }),
      },

      -- 实验性功能
      experimental = {
        ghost_text = true, -- 显示补全预览
        native_menu = false,
      },

      -- 补全窗口设置
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
    })

    -- 命令行补全
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })
  end,
}
