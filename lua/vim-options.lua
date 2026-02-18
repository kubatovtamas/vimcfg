vim.g.mapleader = " "

vim.cmd("set rtp+=/opt/homebrew/opt/fzf")

vim.g.loaded_perl_provider = 0

vim.cmd("set expandtab")
vim.cmd("set autoindent")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

vim.cmd("set nu")
vim.cmd("set relativenumber")

vim.cmd("set nowrap")

vim.cmd("set colorcolumn=88")

vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.swapfile = true

vim.opt.clipboard:append("unnamedplus")

vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.wrapscan = true
vim.opt.gdefault = true
vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
    pattern = "[/?]",
    callback = function()
        vim.o.hlsearch = true -- Enable highlighting when entering search mode
    end,
})

vim.api.nvim_create_autocmd({ "CmdlineLeave" }, {
    pattern = "[/?]",
    callback = function()
        vim.cmd("set nohlsearch") -- Clear highlighting when leaving search mode
    end,
})

vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 12

-- Delete and paste without yanking
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })

-- Delete without saving in register
vim.keymap.set("n", "<leader>d", '"_d', { desc = "Delete without yank (normal)" })
vim.keymap.set("v", "<leader>d", '"_d', { desc = "Delete without yank (visual)" })

-- Map Shift + Tab to deindent in insert mode
vim.keymap.set({ "n", "i" }, "<S-Tab>", "<C-d>", { noremap = true, silent = true, desc = "Deindent (Shift+Tab)" })

-- File writing shortcuts
vim.keymap.set("n", "<leader>ww", ":write<CR>", { noremap = true, silent = true, desc = "[W]rite File" })
vim.keymap.set("n", "<leader>WW", ":wa<CR>", { noremap = true, silent = true, desc = "[W]rite All Files" })
vim.keymap.set("n", "<leader>wq", ":wq<CR>", { noremap = true, silent = true, desc = "[W]rite [Q]uit" })
vim.keymap.set("n", "<leader>wqa", ":wqa<CR>", { noremap = true, silent = true, desc = "[W]rite [Q]uit All" })
vim.keymap.set("n", "<leader>qq", ":q<CR>", { noremap = true, silent = true, desc = "[Q]uit" })

-- Center screen on scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

-- Move lines up and down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Center screen on search result navigation
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result + center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result + center" })

-- Run Python script
vim.keymap.set("n", "<leader>py", ":write | :!python %<CR>", { noremap = true, desc = "Run Python script" })

-- Copy the current buffer's relative to the Git repo root path to register 'a' (relative path)
vim.api.nvim_set_keymap(
    "n",
    "<Leader>pwd",
    [[:let @+ = substitute(expand('%:p'), system('git rev-parse --show-toplevel | tr -d "\\n"'), '', '')<CR>]],
    { noremap = true, silent = true, desc = "[PWD] to clipboard" }
)

-- Copy the current buffer's path to register 'a' (absolute path)
vim.api.nvim_set_keymap(
    "n",
    "<Leader>pwD",
    [[:let @+ = expand('%:p')<CR>]],
    { noremap = true, silent = true, desc = "[PWD] relative to git root to clipboard" }
)

-- Open current buffer in One Markdown
vim.api.nvim_set_keymap(
    "n",
    "<Leader>mo",
    [[:silent execute "!open -a 'One Markdown' " . shellescape(expand('%:p'))<CR>]],
    { noremap = true, silent = true, desc = "[M]arkdown [O]pen in One Markdown" }
)

-- Scroll up three lines
vim.api.nvim_set_keymap("n", "<C-y>", "5<C-y>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-y>", "5<C-y>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-y>", "<C-o>5<C-y>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("c", "<C-y>", "<C-C>5<C-y>", { noremap = true, silent = true })

-- Scroll down three lines
vim.api.nvim_set_keymap("n", "<C-e>", "5<C-e>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-e>", "5<C-e>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-e>", "<C-o>5<C-e>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("c", "<C-e>", "<C-C>5<C-e>", { noremap = true, silent = true })

-- Transform selected lines into bullet/task list, mark as complete/uncomplete
vim.keymap.set("v", "<leader>mb", ":s!^\\(\\s*\\)\\(.*\\)!\\1- \\2! <CR> gv", { desc = "[M]ake [B]ullet" })
vim.keymap.set("v", "<leader>mr", ":s!^\\(\\s*\\)\\(- \\[x\\] \\|- \\[ \\] \\|\\- \\)\\(.*\\)!\\1\\3! <CR> gv", { desc = "[M]ake [R]emoved Bullet" })
vim.keymap.set("v", "<leader>mt", ":s!^\\(\\s*\\)\\(.*\\)!\\1- [ ] \\2! <CR> gv", { desc = "[M]ake [T]ask List" })
vim.keymap.set("v", "<leader>mc", ":s!^\\(\\s*\\)- \\[ \\]!\\1- [x]! <CR> gv", { desc = "[M]ake [C]omplete Task" })
vim.keymap.set("v", "<leader>mu", ":s!^\\(\\s*\\)- \\[x\\]!\\1- [ ]! <CR> gv", { desc = "[M]ake [U]ncomplete Task" })

-- Terminal
vim.api.nvim_set_keymap('t', '<Esc>', [[<C-\><C-n><C-w>w]], {noremap = true})
vim.keymap.set("n", "<leader>tt", ":ToggleTerm<CR>", {noremap = true, desc = "[T]oggle [T]erminal"})

-- Alpha open
vim.keymap.set("n", "<leader>a", ":Alpha<CR>", {noremap = true, desc = "[A]lpha"})

-- Remove empty lines in visual line mode
vim.keymap.set("x", "<leader>re", ":g/^\\s*$/d<CR>", { noremap = true, desc = "[R]emove [E]mpty lines" })


-- Insert green checkmark (✅)
vim.keymap.set("n", "<leader>acm", "a ✅<Esc>", { noremap = true, desc = "[A]ppend [C]heck[M]ark" })
vim.keymap.set("n", "<leader>icm", "i✅ <Esc>", { noremap = true, desc = "[I]nsert [C]heck[M]ark" })

-- Insert red cross (❌)
vim.keymap.set("n", "<leader>axm", "a ❌<Esc>", { noremap = true, desc = "[A]ppend [X]-[M]ark" })
vim.keymap.set("n", "<leader>ixm", "i❌ <Esc>", { noremap = true, desc = "[I]nsert [X]-[M]ark" })
