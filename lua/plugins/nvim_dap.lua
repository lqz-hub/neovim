return {
    -- 在 lazy.nvim 配置中
    {
        'mfussenegger/nvim-dap', -- DAP 核心客户端
        config = function()
            local dap = require('dap')

            -- ========== Python 调试配置 ==========
            dap.adapters.python = {
                type = 'executable',
                command = 'python', -- 或 python3
                args = { '-m', 'debugpy.adapter' }
            }

            dap.configurations.python = {
                {
                    type = 'python',
                    request = 'launch',
                    name = '启动 Python 文件',
                    program = '${file}', -- 调试当前文件
                    pythonPath = function()
                        return 'python'  -- 或返回你的 Python 解释器路径
                    end,
                },
                {
                    type = 'python',
                    request = 'launch',
                    name = '调试带参数的 Python 脚本',
                    program = '${file}',
                    args = function()
                        local args_string = vim.fn.input('输入参数 (空格分隔): ')
                        return vim.split(args_string, ' ')
                    end,
                },
                {
                    type = 'python',
                    request = 'attach',
                    name = '附加到进程',
                    processId = function()
                        return tonumber(vim.fn.input('输入进程 ID: '))
                    end,
                },
            }

            -- ========== C/C++ 调试配置 ==========
            dap.adapters.gdb = {
                type = 'executable',
                command = 'gdb', -- 确保系统中已安装 gdb
                args = { '-i', 'dap' }
            }

            -- C 语言配置
            dap.configurations.c = {
                {
                    name = '启动 C 程序',
                    type = 'gdb',
                    request = 'launch',
                    program = function()
                        -- 自动查找或手动指定可执行文件
                        local default_path = vim.fn.getcwd() .. '/a.out' -- Linux/macOS 默认
                        if vim.fn.filereadable(default_path) == 1 then
                            return default_path
                        end
                        return vim.fn.input('可执行文件路径: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = '${workspaceFolder}',
                    stopAtBeginningOfMainSubprogram = false,
                },
                {
                    name = '附加到 C 进程',
                    type = 'gdb',
                    request = 'attach',
                    program = function()
                        return vim.fn.input('可执行文件路径: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    processId = function()
                        return tonumber(vim.fn.input('进程 ID: '))
                    end,
                }
            }

            -- C++ 配置继承 C 的配置
            dap.configurations.cpp = dap.configurations.c
        end
    },
    {
        'rcarriga/nvim-dap-ui', -- 调试界面 UI
        dependencies = { 'mfussenegger/nvim-dap', "nvim-neotest/nvim-nio" },
        config = function()
            require('dapui').setup()
            local dap, dapui = require("dap"), require("dapui")
            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end
        end
    },
    {
        'theHamsta/nvim-dap-virtual-text', -- 代码内联显示变量值
        dependencies = { 'mfussenegger/nvim-dap' },
        config = function() require('nvim-dap-virtual-text').setup() end
    },

}
