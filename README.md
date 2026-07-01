# Neovim Config Reference

**Leader key:** `Space`

---

## Keybindings

### General

| Key | Mode | Action |
|-----|------|--------|
| `jk` or `kj` | Insert | Exit insert mode (Escape) |
| `<leader>e` | Normal | Toggle file explorer (NvimTree) |
| `<leader>r` | Normal | Save and run current Python file in a floating terminal popup |

### Telescope (Fuzzy Finder)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ff` | Normal | Find files in project |
| `<leader>fg` | Normal | Live grep (search text in files) |
| `<leader>fb` | Normal | Browse open buffers |
| `<leader>fh` | Normal | Search help tags |
| `<leader>fo` | Normal | Find files in OneDrive |

**Inside Telescope:**

| Key | Action |
|-----|--------|
| `<C-j>` / `<C-k>` | Move up/down through results |
| `<CR>` | Open file (PDFs are auto-converted to text via `pdftotext`) |

### LaTeX / VimTeX

| Key | Mode | Action |
|-----|------|--------|
| `<leader>b` | Normal | View compiled PDF (`:VimtexView`) |
| `<leader>c` | Normal | Clean LaTeX build files (`:VimtexClean`) |

### ChatGPT

| Key | Mode | Action |
|-----|------|--------|
| `<leader>cg` | Normal | Send buffer + question to ChatGPT (opens response in new buffer) |
| `<leader>ci` | Normal | Interactive ChatGPT conversation in current buffer |
| `<leader>cs` | Normal | Save current ChatGPT conversation to file |

### Autocompletion (nvim-cmp + LuaSnip)

| Key | Mode | Action |
|-----|------|--------|
| `<Tab>` | Insert/Select | Expand snippet / jump to next node / select next completion |
| `<S-Tab>` | Insert/Select | Jump to previous snippet node / select previous completion |
| `<CR>` | Insert/Select | Confirm selected completion item |
| `<C-Space>` | Insert | Manually trigger completion menu |
| `<C-e>` | Insert/Select | Exit current snippet |

---

## Python Runner (`<leader>r`)

Saves the current file and runs it in a centered floating terminal.

- **Interpreter resolution order:** `$VIRTUAL_ENV` (if a venv is active) → nearest `.venv/` or `venv/` directory found by walking up from the file → `python3`/`python` on `PATH`.
- Popup title shows `(venv)` when a virtualenv interpreter is used.
- Close the popup with `q` or `Esc` (normal mode) or `Esc` (terminal mode).
- Warns instead of running if the buffer isn't a `.py` file or no Python interpreter is found.

---

## LaTeX Snippets

Type the trigger word in a `.tex` file and press `<Tab>` to expand.

| Trigger | Description |
|---------|-------------|
| `article` | Full article template (abstract, intro, main, conclusion, biblatex/APA) |
| `short` | Short paper template (letter size, double-spaced, header block) |

Both snippets use tab stops — press `<Tab>` to jump between fields.

---

## ChatGPT Features

- **Buffer mode** (`<leader>cg`): sends current buffer content with your question; response opens in a new scratch buffer.
- **Interactive mode** (`<leader>ci`): multi-turn conversation written into the current buffer. User messages are highlighted in yellow, assistant responses in purple.
- **Auto-save**: when an interactive chat buffer is closed, the conversation is automatically saved to `~/nvim_chats/chat_<timestamp>.txt`.
- **Manual save** (`<leader>cs`): prompts for a name and saves to `~/nvim_chats/<name>_<timestamp>.chat`.

Requires: OpenAI API key in `$OPENAI_API_KEY` and Python venv at `~/.venvs/openai/`.

---

## LSP — LaTeX (texlab)

Active for `.tex` and `.bib` files.

- **Auto-build on save** via `latexmk -pdf`
- **ChkTeX linting** on open and save
- **Build output** goes to `./build/`
- Forward PDF search configured for **Skim** (macOS)
- Diagnostics (virtual text, signs, underlines) are disabled for a cleaner view

---

## Editor Settings

| Setting | Value |
|---------|-------|
| Line numbers | On (with relative numbers) |
| Clipboard | System clipboard (`unnamedplus`) |
| Indentation | 4 spaces (tabs expanded) |
| Word wrap | On with `breakindent` and `↪` marker |
| Spell check | On — English US (`en_us`) |
| Colorscheme | Dracula (transparent background) |

---

## Plugins

| Plugin | Purpose |
|--------|---------|
| `nvim-tree` | File explorer sidebar (width 30, left side) |
| `telescope.nvim` | Fuzzy finder for files, grep, buffers, help |
| `telescope-media-files` | Media file preview in Telescope |
| `vimtex` | LaTeX editing, compiling, viewing |
| `nvim-cmp` | Autocompletion engine |
| `cmp-nvim-lsp` | LSP completion source |
| `cmp-buffer` | Buffer word completion source |
| `cmp-path` | File path completion source |
| `cmp-omni` | Omnifunc completion (VimTeX citations) |
| `nvim-lspconfig` | LSP client configuration |
| `LuaSnip` | Snippet engine |
| `friendly-snippets` | Community snippet library |
| `nvim-autopairs` | Auto-close brackets, quotes, etc. |
| `nvim-treesitter` | Syntax highlighting and parsing |
| `neoscroll` | Smooth scrolling |
| `AnsiEsc` | ANSI color code rendering |
| `dracula/vim` | Dracula colorscheme |
