--[[
  File: settings.lua
  Description: Base settings for neovim
  Info: Use <zo> and <zc> to open and close foldings
]]

require "helpers/globals"

-- Set associating between turned on plugins and filetype
cmd[[filetype plugin on]]

-- Disable comments on pressing Enter
cmd[[autocmd FileType * setlocal formatoptions-=cro]]

-- Tabs {{{
opt.expandtab = true                -- Use spaces by default
opt.shiftwidth = 4                  -- Set amount of space characters, when we press "<" or ">"
opt.tabstop    = 4                  -- 1 tab equal 2 spaces
opt.smartindent = true              -- Turn on smart indentation. See in the docs for more info
-- }}}

-- Clipboard {{{
opt.clipboard = 'unnamedplus' -- Use system clipboard
opt.fixeol = false -- Turn off appending new line in the end of a file
-- }}}

-- Folding {{{
opt.foldmethod = 'syntax'
-- }}}

-- Search {{{
opt.ignorecase = true               -- Ignore case if all characters in lower case
opt.joinspaces = false              -- Join multiple spaces in search
opt.smartcase = true                -- When there is a one capital letter search for exact match
opt.showmatch = true                -- Highlight search instances
-- }}}

-- Window {{{
opt.splitbelow = true               -- Put new windows below current
opt.splitright = true               -- Put new vertical splits to right
-- }}}

-- Wild Menu {{{
opt.wildmenu = true
opt.wildmode = "longest:full,full"
-- }}}

-- Default Plugins {{{
--local disabled_built_ins = {
--    "netrw",
--    "netrwPlugin",
--    "netrwSettings",
--    "netrwFileHandlers",
--    "gzip",
--    "zip",
--    "zipPlugin",
--    "tar",
--    "tarPlugin",
--    "getscript",
--    "getscriptPlugin",
--    "vimball",
--    "vimballPlugin",
--    "2html_plugin",
--    "logipat",
--    "rrhelper",
--    "spellfile_plugin",
--    "matchit"
--}
--
--for _, plugin in pairs(disabled_built_ins) do
--    g["loaded_" .. plugin] = 1
--end
-- }}}

--" use hybride/relative line numbers {{{ <https://jeffkreeftmeijer.com/vim-number/>
vim.api.nvim_command('set number relativenumber')
vim.api.nvim_create_autocmd({'WinEnter','FocusGained','InsertLeave'}, {
  command = 'set relativenumber'
} )
vim.api.nvim_create_autocmd({'WinLeave','FocusLost','InsertEnter'}, {
  command = 'set norelativenumber'
} )
--"}}}

--vim.api.nvim_create_user_command('Bd', vim.api.nvim_command('bp | bd #'), { nargs = 0 })
vim.api.nvim_create_user_command('Bd', 'bp | bd #', { nargs = 0 })

-- highlight yanked text for 200ms using the "Visual" highlight group
vim.cmd[[
augroup highlight_yank
autocmd!
au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=250})
augroup END
]]

-- {{{  https://unix.stackexchange.com/questions/43119/preserve-modified-time-stamp-after-edit
--if has('unix')
--	function! WritePreserveDate()
--		let mtime = system("stat -c %.Y ".shellescape(expand('%:p')))
--		write
--		call system("touch --date='@".mtime."' ".shellescape(expand('%:p')))
--		edit
--	endfunction
--endif
---}}}

-- vim: tabstop=2 shiftwidth=2 expandtab syntax=lua foldmethod=marker foldlevelstart=1
