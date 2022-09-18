local awful = require("awful")

local _M = {
    {
        id         = "global",
        rule       = {},
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen }
    },
    {
        id       = "floating",
        rule_any = {
            instance = { "copyq", "pinentry" },
            class = {
                "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
                "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer",
                "Galculator", "Thunar", "tsmapplication.exe", "Gedit",
                "mpv", "io.github.celluloid_player.Celluloid", "feh"
            },
            name = {
                "Event Tester",  -- xev.
                "^Friends*", -- steam friends
                "DayZ Launcher"
            },
            role = {
                "AlarmWindow",    -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
                "Organizer"      -- Firefox history, bookmark etc.. windows
            }
        },
        properties = { floating = true }
    },
    {
        id = "titlebars",
        rule_any = { type = { "normal", "dialog" }},
        properties = { titlebars_enabled = true }
    },
    {
        id = "game",
        rule_any = {
            class = {
                "wowclassic.exe",
                "wow.exe",
                "etl",
                "Civ6Sub",
                "csgo_linux64"
            },
            name = { "^DayZ$" }
        },
        properties = {
            screen = 1,
            tag = "2",
            --fullscreen = true,
            titlebars_enabled = false
        }
    },
    {
        id = "chat",
        rule_any = { class = { "discord" }},
        properties = { screen = 1, tag = "3" }
    },
    {
        id = "music",
        rule_any   = { class = { "Spotify" }},
        properties = { screen = 1, tag = "4" }
    },
    {
        id = "launcher",
        rule_any   = { class = { "Steam", "battle.net.exe" }},
        properties = { screen = 1, tag = "5" }
    },
    {
        id = "tools",
        rule_any   = { class = { "obs" }},
        properties = { screen = 1, tag = "6" }
    },
    {
        id = "util",
        rule_any   = { class = { "tsmapplication.exe" }},
        properties = { screen = 1, tag = "7" }
    },
    {
        rule_any = {
            class = {
                "Steam",
                "firefox",
                "battle.net.exe",
                "io.github.celluloid_player.Celluloid"
            }
        },
        properties = { titlebars_enabled = false }
    }
}

return _M
