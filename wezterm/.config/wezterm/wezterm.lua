-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-----------------------------------------------------------
-- Font & Readability
-----------------------------------------------------------
config.font = wezterm.font('JetBrains Mono')
config.font_size = 9
config.line_height = 1.0

-- Keep tab bar always visible for easy tab management
config.hide_tab_bar_if_only_one_tab = false

-- Initial window geometry
config.initial_cols = 120
config.initial_rows = 28

-- Generous scrollback buffer
config.scrollback_lines = 10000

-- Visual scrollbar indicator
config.enable_scroll_bar = true

-----------------------------------------------------------
-- Performance
-----------------------------------------------------------
-- GPU-accelerated rendering
config.front_end = 'WebGpu'

-- Smooth animations
config.animation_fps = 60

-----------------------------------------------------------
-- Cursor
-----------------------------------------------------------
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 700

-----------------------------------------------------------
-- Color Scheme
-----------------------------------------------------------
config.color_scheme = 'Tokyo Night'

-----------------------------------------------------------
-- Misc
-----------------------------------------------------------
-- Proper TERM identification
config.term = 'wezterm'

local pwsh_path = 'C:\\Program Files\\PowerShell\\7\\pwsh.exe'

config.launch_menu = {
    {
        label = 'PowerShell 7',
        args = { pwsh_path, '-NoLogo' },
        domain = { DomainName = 'local' },
    },
    {
        label = 'Command Prompt',
        args = { 'cmd.exe' },
        domain = { DomainName = 'local' },
    },
}

config.default_prog = config.launch_menu[1].args

-- Override the new-tab (+) button to always spawn in the local DefaultDomain,
-- rather than following the current pane's domain (which may be an SSH session).
wezterm.on('new-tab-button-click', function(window, pane, button, default_action)
    if button == 'Left' then
        window:perform_action(wezterm.action.SpawnTab('DefaultDomain'), pane)
        return false
    end
    -- For other buttons (e.g. Right), allow the default behavior.
    return nil
end)

-- Finally, return the configuration to wezterm:
return config
