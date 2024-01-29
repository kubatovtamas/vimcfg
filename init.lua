local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("vim-options")
require("lazy").setup("plugins")

vim.api.nvim_create_autocmd("VimEnter", {
    desc = "Auto select virtualenv when Nvim opens in a Python project",
    pattern = "*",
    callback = function()
        local cwd = vim.fn.getcwd()
        local pyproject_toml = vim.fn.findfile("pyproject.toml", cwd .. ";")
        local pipfile = vim.fn.findfile("Pipfile", cwd .. ";")

        -- Check if either pyproject.toml or Pipfile exists
        if pyproject_toml ~= "" or pipfile ~= "" then
            require("venv-selector").retrieve_from_cache()
        end
    end,
    once = true,
})
