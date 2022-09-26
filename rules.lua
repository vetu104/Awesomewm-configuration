local awful = require("awful")
local gtr = require("gears.timer")

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
        id = "titlebars_on",
        rule_any = { type = { "normal", "dialog" }},
        properties = { titlebars_enabled = true }
    },
    {
        id = "titlebars_off",
        rule_any = {
            class = {
                "Steam",
                "firefox",
                "battle.net.exe",
                "io.github.celluloid_player.Celluloid",
                "origin.exe",

            }
        },
        properties = { titlebars_enabled = false }
    },
    {
        id       = "floating",
        rule_any = {
            instance = { "copyq", "pinentry" },
            class = {
                "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
                "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer",
                "Galculator", "Thunar", "tsmapplication.exe", "Gedit",
                "mpv", "io.github.celluloid_player.Celluloid", "feh", "Xarchiver", "origin.exe"
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
        properties = {
            floating = true,
            placement = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },
    {
        id = "game_general",
        rule_any = {
            class = {
                "wowclassic.exe",
                "wow.exe",
                "etl",
                "csgo_linux64"
            },
            name = { "^DayZ$" }
        },
        properties = {
            screen = 1,
            tag = "2",
            titlebars_enabled = false
        },
        -- When a client starts up in fullscreen, resize it to cover the fullscreen a short moment later
        -- Fixes wrong geometry when titlebars are enabled
        -- (c) https://github.com/elenapan/
        callback = function(c)
            gtr.delayed_call(function()
                if c.valid then
                    c:geometry(c.screen.geometry)
                end
            end)
        end
    },
    {
        id = "game_civ6",
        rule = { class = "Civ6Sub" },
        properties = {
            screen = 1,
            tag = "2",
            fullscreen = false,
            floating = false,
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
        rule_any   = { class = {
            "Steam",
            "battle.net.exe",
            "origin.exe"
        }},
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
}

return _M
