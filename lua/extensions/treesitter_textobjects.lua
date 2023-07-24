require'nvim-treesitter.configs'.setup {

  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["am"] = "@function.outer",
        ["im"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["ad"] = "@conditional.outer",
        ["id"] = "@conditional.inner",
        ["ao"] = "@loop.outer",
        ["io"] = "@loop.inner",
        ["a-"] = "@comment.outer",
        ["i-"] = "@comment.inner",
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- You can also use captures from other query groups like `locals.scm`
        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ['@parameter.outer'] = 'v',
        ['@function.outer'] = 'v',
        ['@class.outer'] = 'v',
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true of false
      include_surrounding_whitespace = true,
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]c"] = "@class.outer",
        ["]m"] = "@function.outer",
        ["]d"] = "@conditional.outer",
        ["]o"] = "@loop.outer",
        ["]-"] = "@comment.outer",
        --
        -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
        --["]o"] = "@loop.*",
        -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
        --
        -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
        -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
        ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
      },
      goto_next_end = {
        ["]C"] = "@class.outer",
        ["]M"] = "@function.outer",
        ["]D"] = "@conditional.outer",
        ["]O"] = "@loop.outer",
        ["]_"] = "@comment.outer",
      },
      goto_previous_start = {
        ["[c"] = "@class.outer",
        ["[m"] = "@function.outer",
        ["[d"] = "@conditional.outer",
        ["[o"] = "@loop.outer",
        ["[-"] = "@comment.outer",
      },
      goto_previous_end = {
        ["[C"] = "@class.outer",
        ["[M"] = "@function.outer",
        ["[D"] = "@conditional.outer",
        ["[O"] = "@loop.outer",
        ["]_"] = "@comment.outer",
      },
    },
  },
}

