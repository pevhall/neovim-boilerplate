require "helpers/globals"
require "helpers/keyboard"


-- Telescope {{{
nm('<leader>tdd', '<cmd>Telescope lsp_definitions<CR>')                            -- Goto declaration
nm('<leader>tdt', '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>')              -- Search for dynamic symbols
nm('<leader>tfo', '<cmd>Telescope oldfiles<CR>')                                   -- Show recent files
nm('<leader>tfg', '<cmd>Telescope git_files<CR>')                                  -- Search for a file in project
nm('<leader>tff', '<cmd>Telescope find_files<CR>')                                 -- Search for a file (ignoring git-ignore)
nm('<leader>ti', '<cmd>Telescope jumplist<CR>')                                   -- Show jumplist (previous locations)
nm('<leader>tgb', '<cmd>Telescope git_branches<CR>')                               -- Show git branches
nm('<leader>tgg', '<cmd>Telescope live_grep<CR>')                                  -- Find a string in project
nm('<leader>tb', '<cmd>Telescope buffers<CR>')                                    -- Show all buffers
nm('<leader>tm', '<cmd>Telescope marks<CR>')                                            -- Show all marks
nm('<leader>ta', '<cmd>Telescope<CR>')                                            -- Show all commands
nm('<leader>tt', '<cmd>Telescope resume<CR>')                                            -- Show all commands
-- }}}

-- Trouble {{{
nm('<leader>xx', '<cmd>TroubleToggle<CR>')                                         -- Show all problems in project (with help of LSP)
nm('<leader>xdr', '<cmd>Trouble lsp_references<CR>')                                       -- Show use of object in project
-- }}}

-- Neo Tree {{{
nm('<leader>v', '<cmd>NeoTreeFocusToggle<CR>')                                        -- Toggle file explorer
-- }}}

-- {{{ lines: luascript
--local ls = require("luasnip")
--vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
--vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
--vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})
--
--vim.keymap.set({"i", "s"}, "<C-E>", function()
--	if ls.choice_active() then
--		ls.change_choice(1)
--	end
--end, {silent = true})
-- }}}

--{{{ misc
--" Quickly select the text that was just pasted. 
nm('gV', '`[v`]')
--"<https://stackoverflow.com/questions/4256697/vim-search-and-highlight-but-do-not-jump>
nm('#', ':let @/ = \"\\\\<<C-r><C-w>\\\\>\"<cr>:set hlsearch<cr>')
--To search for visually selected text <https://vim.fandom.com/wiki/Search_for_visually_selected_text>
-- fix: vm('//', 'y/\\V<C-R>=escape(@",\'/\\\')<CR><CR>')
--replace all (and prevent jump)
nm('<Leader>s', 'm`:%s/<C-r>//<C-r><C-w>/g<cr>``')
--"write the command to replace all but leave open for changes (useful to keep history etc)
nm('<Leader><a-s>', ':%s/<C-r>//<C-r><C-w>/g')
--find whole words
nm('<leader>/', '/\\<\\><left><left>')
--
--" swap word under cursor with word at mark x
nm('gx', 'm``xyiw``viwp`xviwp``')
-- first, delete some text. Then, use visual mode to select some other text, and press Ctrl-S. The two pieces of text should then be swapped.
vm('<leader>gx', '<Esc>`.``gvP``P')


--move selected line up or down with J and K (todo add number)
vm("<c-j>", ":m '>+1<CR>gv=gv")
vm("<c-k>", ":m '<-2<CR>gv=gv")

-- move cursor to centre of window after c-u or c-d
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- paste without changing unamed reigster
vim.keymap.set("x", "<leader>p", [["_dP]])

-- quicklist navigation
nm(']q', ':cnext<CR>')
nm('[q', ':cprevious<CR>')
-- locationlist navigation
nm(']l', ':lnext<CR>')
nm('[l', ':lprevious<CR>')
--}}}

--NOTE: more keybindings in ./extensions/treesitter_textobjects.lua

-- copy the current file path: {{{
--copy abs file path
nm('<leader>%',  ':let @+=expand("%:p")<CR>')
--"copy file name
nm('<leader>%t', ':let @+=expand("%:t")<CR>')
--"copy directory
nm('<leader>%h', ':let @+=expand("%:p:h")<CR>')
--"copy abs file path and line number
nm('<leader>%:', ':let @+ = expand("%:p") . ":" . line(".")<CR>')
-- }}}

-- regular copy past {{{
vm('<c-x>', '"+x')
vm('<c-c>', '"+y')
nm('<c-v>', '"+p')
vm('<c-v>', '"+p')
--im('<c-v>', '"+p')
im('<c-v>', '<c-r>+')

-- cmap('<c-v>', '<c-r>+')
-- use <C-E> for block select instead
nm('<c-e>', '<c-v>')

--To simulate |i_CTRL-R| in terminal-mode:
tm('<expr> <C-R>', '<C-\\><C-N>"\'.nr2char(getchar()).\'pi\'')
--}}}

-- to navigate windows and tabs from any mode: {{{
tm('<A-p>', '<C-\\><C-N>gT')
tm('<A-n>', '<C-\\><C-N>gt')
im('<A-p>', '<C-\\><C-N>gT')
im('<A-n>', '<C-\\><C-N>gt')
nm('<A-p>', 'gT')
nm('<A-n>', 'gt')

tm('<A-h>', '<C-\\><C-N><C-w>h')
tm('<A-j>', '<C-\\><C-N><C-w>j')
tm('<A-k>', '<C-\\><C-N><C-w>k')
tm('<A-l>', '<C-\\><C-N><C-w>l')
im('<A-h>', '<C-\\><C-N><C-w>h')
im('<A-j>', '<C-\\><C-N><C-w>j')
im('<A-k>', '<C-\\><C-N><C-w>k')
im('<A-l>', '<C-\\><C-N><C-w>l')
nm('<A-h>', '<C-w>h')
nm('<A-j>', '<C-w>j')
nm('<A-k>', '<C-w>k')
nm('<A-l>', '<C-w>l')
-- }}}

--{{{ lsp

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[e', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']e', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>el', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gdD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gdd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gdK', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gdi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gd<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>dwa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>dwr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>dwl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', 'gdt', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>drn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>dca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gdr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>df', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
--- {{{

-- vim:tabstop=2 shiftwidth=2 expandtab syntax=lua foldmethod=marker foldlevelstart=0 foldlevel=0
