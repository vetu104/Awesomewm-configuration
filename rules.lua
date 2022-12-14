local awful = require("awful")
local gears = require("gears")

local _M = {
    {
        id         = "global",
        rule       = {},
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen,
        }
    },
    {
        id = "normal",
        rule_any = { type = { "normal", "dialog" }},
        properties = {
            titlebars_enabled = true,
            shape = gears.shape.rounded_rect
        },
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
                "Xfce4-power-manager-settings",

            },
            name = { "DayZ Launcher", },
        },
        properties = { titlebars_enabled = false }
    },
    {
        id       = "floating",
        rule_any = {
            instance = { "copyq", "pinentry" },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "Sxiv",
                "Tor Browser",
                "Wpa_gui",
                "veromix",
                "xtightvncviewer",
                "Galculator",
                "Thunar",
                "tsmapplication.exe",
                "Gedit",
                "mpv",
                "io.github.celluloid_player.Celluloid",
                "Xarchiver",
                "origin.exe",
                "ncmpcpp",
        name = { "^DayZ$" },
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
            placement = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen,
        }
    },
    {
        id = "fullscreen",
        rule_any = {
            class = {
                "tesv.exe",
                "wowclassic.exe"
            }
        },
        properties = {
            screen = 1,
            tag = "2",
            floating = true,
            fullscreen = true,
            titlebars_enabled = false,
        }
    },
    {
        id = "game",
        rule_any = {
            class = {
                "wowclassic.exe",
                "etl",
                "csgo_linux64",
                "Civ6Sub",
            },
            name = {
                "^DayZ$",
                "World of Warcraft",
                "Sid Meier's Civilization VI (DX11)",
            }
        },
        properties = {
            screen = 1,
            tag = "2",
            titlebars_enabled = false,
            shape = gears.shape.rectangle
        },
        -- When a client starts up in fullscreen, resize it to cover the fullscreen a short moment later
        -- Fixes wrong geometry when titlebars are enabled
        -- (c) https://github.com/elenapan/
        callback = function(c)
            gears.timer.delayed_call(function()
                if c.valid then
                    c:geometry(c.screen.geometry)
                end
            end)
        end
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
