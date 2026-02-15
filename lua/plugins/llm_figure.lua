return {
  {
    "Kurama622/llm.nvim",
    -- branch = "dev/ollama-images",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    -- cmd = { "LLMSessionToggle", "LLMSelectedTextHandler", "LLMAppHandler" },
    lazy = false,
    config = function()
      local tools = require("llm.tools")
      require("llm").setup({
        -- [[ local llm ]]
        url = "http://192.168.11.12:11434/api/chat",
        model = "qwen3:latest",
        api_type = "ollama",
        temperature = 0.3,
        top_p = 0.7,

        prompt = "You are a helpful chinese assistant.",

        prefix = {
          user = { text = "😃 ", hl = "Title" },
          assistant = { text = "  ", hl = "Added" },
        },
        style = "right", -- right | left | top | bottom
        chat_ui_opts = {
          input = {
            split = {
              relative = "win",
              position = {
                row = "80%",
                col = "50%",
              },
              border = {
                text = {
                  top = "  Enter Your Question ",
                  top_align = "center",
                },
              },
              win_options = {
                winblend = 0,
                winhighlight = "Normal:String,FloatBorder:LlmYellowLight,FloatTitle:LlmYellowNormal",
              },
              size = { height = 2, width = "80%" },
            },
          },
          output = {
            split = {
              size = "40%",
            },
          },
          history = {
            split = {
              -- Default: true.
              -- If the window flickers when the cursor moves on macOS, you can set enable_fzf_focus_print = false.
              enable_fzf_focus_print = true,
              size = "60%",
            },
          },
          models = {
            split = {
              relative = "win",
              size = { height = "30%", width = "60%" },
            },
          },
        },
        -- popup window options
        popwin_opts = {
          relative = "cursor",
          enter = true,
          focusable = true,
          zindex = 50,
          position = { row = -7, col = 15 },
          size = { height = 15, width = "50%" },
          border = { style = "single", text = { top = " Explain ", top_align = "center" } },
          win_options = {
            winblend = 0,
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          },

          -- move popwin
          move = {
            left = {
              mode = "n",
              keys = "<left>",
              distance = 5,
            },
            right = {
              mode = "n",
              keys = "<right>",
              distance = 5,
            },
            up = {
              mode = "n",
              keys = "<up>",
              distance = 2,
            },
            down = {
              mode = "n",
              keys = "<down>",
              distance = 2,
            },
          },
        },

        -- history_path = "/tmp/llm-history",
        save_session = true,
        max_history = 15,
        max_history_name_length = 20,
        max_tokens = 1600000,
        eneble_trace = true,
        timeout = 500,

        -- stylua: ignore
        keys = {
          -- The keyboard mapping for the input window.
          ["Input:Submit"]      = { mode = "n", key = "<cr>" },
          ["Input:Cancel"]      = { mode = {"n", "i"}, key = "<C-c>" },
          ["Input:Resend"]      = { mode = {"n", "i"}, key = "<C-r>" },

          -- only works when "save_session = true"
          ["Input:HistoryNext"] = { mode = {"n", "i"}, key = "<C-j>" },
          ["Input:HistoryPrev"] = { mode = {"n", "i"}, key = "<C-k>" },

          -- The keyboard mapping for the output window in "split" style.
          ["Output:Ask"]        = { mode = "n", key = "i" },
          ["Output:Cancel"]     = { mode = "n", key = "<C-c>" },
          ["Output:Resend"]     = { mode = "n", key = "<C-r>" },

          -- The keyboard mapping for the output and input windows in "float" style.
          ["Session:Toggle"]    = { mode = "n", key = "<leader>ac" },
          ["Session:Close"]     = { mode = "n", key = {"<esc>", "Q"} },

          -- Scroll
          ["PageUp"]            = { mode = {"i","n"}, key = "<C-b>" },
          ["PageDown"]          = { mode = {"i","n"}, key = "<C-f>" },
          ["HalfPageUp"]        = { mode = {"i","n"}, key = "<C-u>" },
          ["HalfPageDown"]      = { mode = {"i","n"}, key = "<C-d>" },
          ["JumpToTop"]         = { mode = "n", key = "gg" },
          ["JumpToBottom"]      = { mode = "n", key = "G" },
        },
        app_handler = {
          ReviewText = {
            handler = tools.attach_to_chat_handler,
            prompt = [[You are a English expert. Your task is to correct  all the text provided by the user.

NOTE:
- All the text input by the user is part of the content to be corrected, and you should ONLY FOCUS ON addressing the problems on the grammer or the logic.
- RETURN ONLY THE MODIFIDE RESULT.]],
            opts = {
              exit_on_move = true,
              enter_flexible_window = false,
            },
          },
          FormulaRecognition = {
            handler = tools.images_handler,
            prompt = "Please convert the formula in the image to LaTeX syntax, and only return the syntax of the formula.",
            opts = {
              url = "http://192.168.11.12:11434/api/chat",
              model = "qwen2.5vl:7b",
              fetch_key = vim.env.LOCAL_LLM_KEY,
              api_type = "ollama",
              picker = {
                   cmd = "fd . /mnt/c/Users/ps/Pictures/Screenshots/ | xargs -d '\n' ls -t | fzf --no-preview",
                  enable_fzf_focus_print = true,
                -- keymap
                mapping = {
                  mode = "i",
                  keys = "<C-f>",
                },
              },
                        },
          },
          CodeExplain = {
            handler = tools.flexi_handler,
            prompt = "Explain the following code, please only return the explanation, and answer in Chinese",
            opts = {
              enter_flexible_window = true,
              url = "http://192.168.11.12:11434/api/chat",
              -- model = "deepseek-coder:33b",
              -- model = "qwen2.5-coder:1.5b",
              -- model = "codellama:70b",
              model = "qwen3-coder",
              api_type = "ollama",
              max_tokens = 80000,
            },
          },
          -- Completion = {
          --   handler = tools.completion_handler,
          --   opts = {
          --     -------------------------------------------------
          --     ---                   ollama
          --     -------------------------------------------------
          --     -- url = "https://api.deepseek.com/chat",
          --     -- model = "deepseek-chat",
          --     -- api_type = "deepseek",
          --     ------------------- end ollama ------------------
          --     -- url = "http://192.168.11.12:11434/v1/completions",
          --     -- -- model = "deepseek-coder:33b",
          --     -- model = "qwen2.5-coder:1.5b",
          --     -- -- model = "codellama:70b",
          --     -- -- model = "qwen3-coder",
          --     -- api_type = "ollama",
          --     -------------------------------------------------
          --     ---                 siliconflow
          --     -------------------------------------------------
          --     url = "https://api.siliconflow.cn/v1/completions",
          --     model = "Qwen/Qwen2.5-Coder-7B-Instruct",
          --     api_type = "openai",
          --     fetch_key = function()
          --       return "sk-fdcimwbmxjezscjlofmmdeplztibdjkrlsqbmxreppghkpmh"
          --     end,
          --     ------------------ end siliconflow ----------------
          --
          --     n_completions = 2,
          --     context_window = 1600,
          --     max_tokens = 800,
          --
          --     -- A mapping of filetype to true or false, to enable completion.
          --     filetypes = { sh = false },
          --
          --     -- Whether to enable completion of not for filetypes not specifically listed above.
          --     default_filetype_enabled = true,
          --
          --     auto_trigger = true,
          --
          --     -- just trigger by { "@", ".", "(", "[", ":", " " } for `style = "nvim-cmp"`
          --     only_trigger_by_keywords = true,
          --
          --     style = "virtual_text", -- nvim-cmp or blink.cmp
          --
          --     timeout = 100, -- max request time
          --
          --     -- only send the request every x milliseconds, use 0 to disable throttle.
          --     throttle = 1000,
          --     -- debounce the request in x milliseconds, set to 0 to disable debounce
          --     debounce = 400,
          --
          --     --------------------------------
          --     ---   just for virtual_text
          --     --------------------------------
          --     keymap = {
          --       virtual_text = {
          --         accept = {
          --           mode = "i",
          --           keys = "<C-q>",
          --         },
          --         next = {
          --           mode = "i",
          --           keys = "<A-n>",
          --         },
          --         prev = {
          --           mode = "i",
          --           keys = "<A-p>",
          --         },
          --         toggle = {
          --           mode = "n",
          --           keys = "<leader>cp",
          --         },
          --       },
          --     },
          --   },
          -- },
        },
      })
    end,
    keys = {
      { "<leader>ac", mode = "n", "<cmd>LLMSessionToggle<cr>" },
      { "<leader>ae", mode = "v", "<cmd>LLMAppHandler CodeExplain<cr>", desc = " Explain the Code" },
      { "<leader>rt", mode = "v", "<cmd> LLMAppHandler ReviewText<cr>" },
      { "<leader>fl", mode = "n", "<cmd> LLMAppHandler FormulaRecognition<cr>" },
      { "<leader>ts", mode = "x", "<cmd>LLMSelectedTextHandler 英译汉<cr>" },
    },
  },
}
