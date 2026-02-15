-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])
vim.g.transparent_groups = vim.list_extend(
  vim.g.transparent_groups or {},
  vim.tbl_map(function(v)
    return v.hl_group
  end, vim.tbl_values(require("bufferline.config").highlights))
)
-- 延迟检查
-- vim.defer_fn(ensure_language_servers, 1000)
local M = {}
function M.extract_citation_key(bibtex)
  -- 匹配标准格式：@type{key, ...}
  local key = bibtex:match("@%a+%s*{%s*([^,%s]+)")

  -- 匹配不带大括号的格式：@type key, ...
  if not key then
    key = bibtex:match("@%a+%s+([^%s,]+)")
  end

  -- 匹配已删除逗号的格式：@type{key}
  if not key then
    key = bibtex:match("@%a+%s*{%s*([^}]+)%s*}")
  end

  -- 返回结果
  return key and key:gsub("^%s*(.-)%s*$", "%1") or nil
end

function M.citation_key_to_register(key)
  if not key or key == "" then
    vim.notify("No citation key found", vim.log.levels.WARN)
    return false
  end

  -- 设置寄存器 'p' 的值
  vim.fn.setreg("p", key)

  -- 提示用户
  vim.notify(string.format("Citation key '%s' saved to register 'p'. Use \"pp to paste.", key), vim.log.levels.INFO)

  return true
end

function M.process_selection(arxiv_num)
  -- 执行Python脚本（示例命令）
  local command = string.format("/mnt/d/inspire.py %s -d bibtex", vim.fn.shellescape(arxiv_num))

  -- 获取输出并处理空值
  local output = vim.fn.systemlist(command) or {}
  if vim.v.shell_error ~= 0 then
    vim.notify("Error: " .. table.concat(output, "\n"), vim.log.levels.ERROR)
    return
  end

  -- 转换为安全字符串
  local result = table.concat(output, "\n")
  result = result:gsub("\n+$", "") -- 去除末尾空行
  if result == "" then
    vim.notify("Empty result", vim.log.levels.INFO)
    return
  end

  -- 分割为行数组
  local bibtex = vim.split(result, "\n") or {}

  -- 插入到缓冲区
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == "" then
    vim.notify("No file associated with current buffer", vim.log.levels.ERROR)
    return false
  end
  -- 获取当前文件所在目录
  local current_dir = vim.fn.fnamemodify(current_file, ":h")
  -- 构建 ref.bib 文件路径
  local ref_bib_path = current_dir .. "/ref.bib"
  local file_exists = vim.fn.filereadable(ref_bib_path) == 1
  local ok, err = pcall(function()
    if file_exists then
      -- 追加模式
      vim.fn.writefile(bibtex, ref_bib_path, "a")
    else
      -- 创建新文件
      vim.fn.writefile(bibtex, ref_bib_path)
    end
  end)
  if not ok then
    vim.notify("Failed to write to ref.bib: " .. tostring(err), vim.log.levels.ERROR)
  end

  local action = file_exists and "appended to" or "created and written to"
  vim.notify(string.format("%d lines %s ref.bib at: %s", #bibtex, action, ref_bib_path), vim.log.levels.INFO)

  -- for key, value in pairs(bibtex) do
  --   vim.notify(key .. value)
  -- end
  -- vim.notify(bibtex)
  local key = M.extract_citation_key(bibtex[2])
  M.citation_key_to_register(key)
end

vim.api.nvim_create_user_command("GetBib", function(opts)
  M.process_selection(opts.args)
end, { nargs = 1 })

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.lua",
  callback = function()
    vim.lsp.buf.format()
  end,
})
-- vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
--     pattern = { "*" },
--     command = "silent! wall",
--     nested = true,
-- })
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.fn.setpos(".", vim.fn.getpos("'\""))
      vim.cmd("silent! foldopen")
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "text", "markdown", "tex" },
  callback = function()
    vim.opt_local.spell = true -- 启用拼写检查
    vim.opt_local.spelllang = "en_us" -- 设置拼写语言
  end,
})
--
