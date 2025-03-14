local M = {}

---@alias telescope_themes
---| "cursor"   # see `telescope.themes.get_cursor()`
---| "dropdown" # see `telescope.themes.get_dropdown()`
---| "ivy"      # see `telescope.themes.get_ivy()`
---| "center"   # retain the default telescope theme

function M.config()
  local actions = require("lvim.utils.modules").require_on_exported_call "telescope.actions"
  lvim.builtin.telescope = {
    ---@usage disable telescope completely [not recommended]
    active = true,
    on_config_done = nil,
    theme = "dropdown", ---@type telescope_themes
    defaults = {
      prompt_prefix = lvim.icons.ui.Telescope .. " ",
      selection_caret = lvim.icons.ui.Forward .. " ",
      entry_prefix = "  ",
      initial_mode = "insert",
      selection_strategy = "reset",
      sorting_strategy = nil,
      layout_strategy = nil,
      layout_config = {},
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
        "--glob=!.git/",
      },
      ---@usage Mappings are fully customizable. Many familiar mapping patterns are setup as defaults.
      mappings = {
        i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,

        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,

        ["<C-c>"] = actions.close,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,

        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        --["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        --["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        --["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        --["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-l>"] = actions.complete_tag,
        ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>

        },
        n = {
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        --["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        --["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        --["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        --["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["H"] = actions.move_to_top,
        ["M"] = actions.move_to_middle,
        ["L"] = actions.move_to_bottom,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,

        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        ["?"] = actions.which_key,
        },
      },
      file_ignore_patterns = {},
      path_display = { "smart" },
      winblend = 0,
      border = {},
      borderchars = nil,
      color_devicons = true,
      set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    },
    pickers = {
      find_files = {
        hidden = true,
      },
      live_grep = {
        --@usage don't include the filename in the search results
        only_sort_text = true,
      },
      grep_string = {
        only_sort_text = true,
      },
      buffers = {
        initial_mode = "normal",
        mappings = {
          i = {
            ["<C-d>"] = actions.delete_buffer,
          },
          n = {
            ["dd"] = actions.delete_buffer,
          },
        },
      },
      planets = {
        show_pluto = true,
        show_moon = true,
      },
      git_files = {
        hidden = true,
        show_untracked = true,
      },
      colorscheme = {
        enable_preview = true,
      },
    },
    extensions = {
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      },
    },
  }
end

function M.setup()
  local previewers = require "telescope.previewers"
  local sorters = require "telescope.sorters"

  lvim.builtin.telescope = vim.tbl_extend("keep", {
    file_previewer = previewers.vim_buffer_cat.new,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,
    file_sorter = sorters.get_fuzzy_file,
    generic_sorter = sorters.get_generic_fuzzy_sorter,
  }, lvim.builtin.telescope)

  local telescope = require "telescope"

  local theme = require("telescope.themes")["get_" .. (lvim.builtin.telescope.theme or "")]
  if theme then
    lvim.builtin.telescope.defaults = theme(lvim.builtin.telescope.defaults)
  end

  telescope.setup(lvim.builtin.telescope)

  if lvim.builtin.project.active then
    pcall(function()
      require("telescope").load_extension "projects"
    end)
  end

  if lvim.builtin.telescope.on_config_done then
    lvim.builtin.telescope.on_config_done(telescope)
  end

  if lvim.builtin.telescope.extensions and lvim.builtin.telescope.extensions.fzf then
    pcall(function()
      require("telescope").load_extension "fzf"
    end)
  end
end

return M
