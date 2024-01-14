--[[
  File: telescope.lua
  Description: Telescope plugin configuration
  See: https://github.com/nvim-telescope/telescope.nvim
]]
local telescope = require("telescope")
telescope.setup()
telescope.load_extension('fzf')

--------------------------------------------------------------------------------

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values

-- our picker function: colors

pick_from_file_list = function(opts)
  local map_file = assert(io.open(opts.fargs[1], 'r'))
  local lines = {}
  local idx = 1;
  for line in map_file:lines() do
      lines[idx] = line
      idx = idx + 1
  end
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "colors",
    finder = finders.new_table {
      results = lines
    },
    previewer = conf.file_previewer(opts),
    sorter = conf.file_sorter(opts) --conf.generic_sorter(opts),
  }):find()
end

-- to execute the function
vim.api.nvim_create_user_command('FileList', pick_from_file_list,  { nargs='+' , complete='file'})

