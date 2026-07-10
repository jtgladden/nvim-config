local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap('n', '<leader>e', ':NvimTreeToggle<CR>', opts)

-- Exit insert mode by typing 'jk' or kj
vim.keymap.set('i', 'jk', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('i', 'kj', '<Esc>', { noremap = true, silent = true })

-- Call ChatGPT on buffer
vim.api.nvim_set_keymap(
    'n',
    '<leader>cg',
    ':lua require("chatgpt").SendBufferToChatGPT()<CR>',
    { noremap = true, silent = true }
)

-- Call chat interactive
vim.keymap.set("n", "<leader>ci", function()
    require("chatgpt").ChatGPTInteractive()
end, { noremap = true, silent = true })

-- Run Python file in a floating terminal popup
local python_popup = { win = nil, buf = nil }

-- Prefer an active/discoverable venv over whatever python3 happens to be on PATH
local function find_venv_python(file_path)
    if vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV ~= "" then
        for _, name in ipairs({ "python3", "python" }) do
            local p = vim.env.VIRTUAL_ENV .. "/bin/" .. name
            if vim.fn.executable(p) == 1 then
                return p
            end
        end
    end

    local venv_dirs = vim.fs.find({ ".venv", "venv" }, {
        upward = true,
        path = vim.fs.dirname(file_path),
        type = "directory",
    })

    for _, dir in ipairs(venv_dirs) do
        for _, name in ipairs({ "python3", "python" }) do
            local p = dir .. "/bin/" .. name
            if vim.fn.executable(p) == 1 then
                return p
            end
        end
    end

    return nil
end

local function run_python_in_popup()
    local file = vim.api.nvim_buf_get_name(0)
    if file == "" then
        vim.notify("Buffer has no file name; save it first", vim.log.levels.ERROR)
        return
    end

    if vim.bo.filetype ~= "python" then
        vim.notify("Not a Python buffer (filetype=" .. vim.bo.filetype .. ")", vim.log.levels.WARN)
    end

    local venv_python = find_venv_python(file)
    local python_cmd = venv_python
        or ((vim.fn.executable("python3") == 1) and "python3")
        or ((vim.fn.executable("python") == 1) and "python")
        or nil
    if not python_cmd then
        vim.notify("No python3/python executable found on PATH", vim.log.levels.ERROR)
        return
    end

    -- Save the file silently; a visible "written" message would trigger a
    -- hit-enter prompt right as the floating window steals the screen
    local ok, err = pcall(function()
        vim.cmd("silent write")
    end)
    if not ok then
        vim.notify("Failed to save file: " .. err, vim.log.levels.ERROR)
        return
    end

    -- Close any previous popup left open from an earlier run
    if python_popup.win and vim.api.nvim_win_is_valid(python_popup.win) then
        vim.api.nvim_win_close(python_popup.win, true)
    end

    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].bufhidden = "wipe"

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
        title = venv_python and " Python Output (venv) " or " Python Output ",
        title_pos = "center",
    })

    python_popup.win = win
    python_popup.buf = buf

    vim.fn.jobstart({ python_cmd, file }, {
        term = true,
        cwd = vim.fn.fnamemodify(file, ":h"),
        on_exit = function()
            if python_popup.buf == buf then
                python_popup.win = nil
                python_popup.buf = nil
            end
        end,
    })

    local close_opts = { buffer = buf, silent = true, nowait = true }
    vim.keymap.set("n", "q", "<cmd>close<CR>", close_opts)
    vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", close_opts)
    vim.keymap.set("t", "<Esc>", [[<C-\><C-n><cmd>close<CR>]], close_opts)

    vim.cmd("startinsert")
end

vim.keymap.set('n', '<leader>r', run_python_in_popup, { desc = 'Run Python file in popup' })
