local M = {}

function M.get_sections()
  local header = {
    type = "text",
    val = {[[
      _       __                               ______    ___ __
     | |     / /_  ___   _____  _________     / ____/___/ (_) /_____  _____
     | | /| / / / / / | / / _ \/ ___/ __ \   / __/ / __  / / __/ __ \/ ___/
     | |/ |/ / /_/ /| |/ /  __/ /  / / / /  / /___/ /_/ / / /_/ /_/ / /
     |__/|__/\__, / |___/\___/_/  /_/ /_/  /_____/\__,_/_/\__/\____/_/
            /____/
]]
    },
    opts = {
      hl = "Label",
      shrink_margin = false,
      -- wrap = "overflow";
    },
  }

  local top_buttons = {
    entries = {
      { "e", lvim.icons.ui.NewFile .. " New File", "<CMD>ene!<CR>" },
    },
  }

  local bottom_buttons = {
    entries = {
      { "q", "Quit", "<CMD>quit<CR>" },
    },
  }

  local footer = {
    type = "group",
  }

  return {
    header = header,
    top_buttons = top_buttons,
    bottom_buttons = bottom_buttons,
    -- this is probably broken
    footer = footer,
  }
end

return M
