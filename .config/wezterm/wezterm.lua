-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Disable bell
config.audible_bell = "Disabled"

-- Tab-bar
config.hide_tab_bar_if_only_one_tab = true
config.window_frame = {
	font_size = 8,
	active_titlebar_bg = '#000000',
}
config.colors = {
	tab_bar = {
		inactive_tab_edge = '#aaaaaa',
		inactive_tab = {
			bg_color = '#000000',
			fg_color = '#909090',
		},
		active_tab = {
			bg_color = '#191724',
			fg_color = '#e0def4',
		},
		new_tab = {
			bg_color = '#000000',
			fg_color = '#909090',
		},

	},
}

-- Terminal fonts
config.color_scheme = 'rose-pine'

config.font = wezterm.font_with_fallback({
	"Source Code Pro",
	"Symbols Nerd Font Mono",
	--"Cascadia Code Light",
	--"Vazir Code Hack FD Regular",
	--"MesloLGS NF",
})
config.font_size = 11

-- Cursor
config.default_cursor_style = 'BlinkingBar'

-- Terminal opacity
config.window_background_opacity = 0.97

-- Terminal window padding
config.window_padding = {
	left = '0.5cell',
	right = '0.5cell',
	top = '0.5cell',
	bottom = '0.5cell'
}

--[[ config.window_background_gradient = {
orientation = { Linear = { angle = -45 } },
preset = "Inferno",
segment_size = 5,
segment_smoothness = 20.0,
}
]]--

-- Keybindings
config.keys = {

	-- Generic
	{ key = 'f', mods = 'ALT', action = wezterm.action.ToggleFullScreen },

	-- Tabs
	{ key = 't', mods = 'ALT', action = wezterm.action({ SpawnTab = 'DefaultDomain' }) },
	{ key = 'w', mods = 'ALT', action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },

	-- Panes
	-- Pane Handling
	{ key = '/', mods = 'ALT', action = wezterm.action({ SplitVertical = { domain = 'CurrentPaneDomain' } }) },
	{ key = "'", mods = 'ALT', action = wezterm.action({ SplitHorizontal = { domain = 'CurrentPaneDomain' } }) },
	{ key = 'x', mods = 'ALT', action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
	-- Pane Navigates
	{ key = 'h', mods = 'ALT', action = wezterm.action({ ActivatePaneDirection = 'Left' }) },
	{ key = 'l', mods = 'ALT', action = wezterm.action({ ActivatePaneDirection = 'Right' }) },
	{ key = 'k', mods = 'ALT', action = wezterm.action({ ActivatePaneDirection = 'Up' }) },
	{ key = 'j', mods = 'ALT', action = wezterm.action({ ActivatePaneDirection = 'Down' }) },
	-- Pane Cycles
	{ key = '[', mods = 'ALT', action = wezterm.action({ ActivatePaneDirection = 'Next' }) },
	{ key = ']', mods = 'ALT', action = wezterm.action({ ActivatePaneDirection = 'Prev' }) },
	-- Pane Resize
	{ key = 'H', mods = 'ALT|SHIFT', action = wezterm.action({ AdjustPaneSize = { 'Left', 2 } }) },
	{ key = 'J', mods = 'ALT|SHIFT', action = wezterm.action({ AdjustPaneSize = { 'Down', 2 } }) },
	{ key = 'K', mods = 'ALT|SHIFT', action = wezterm.action({ AdjustPaneSize = { 'Up', 2 } }) },
	{ key = 'L', mods = 'ALT|SHIFT', action = wezterm.action({ AdjustPaneSize = { 'Right', 2 } }) },

}

-- ALT + (number) to go Tab-(number)
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = 'ALT',
		action = wezterm.action.ActivateTab(i - 1),
	})
end

-- and finally, return the configuration to wezterm
return config

