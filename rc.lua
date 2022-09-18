local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local ruled = require("ruled")
require("awful.hotkeys_popup.keys")
--local lain = require("lain")
local keys = require("keys")
local widget = require("widget")

local dpi = beautiful.xresources.apply_dpi

-- {{{ Error handling
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_xdg_config_home() .. "awesome/themes/default/theme.lua")
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
-- }}}

--{{{ Autostart programs
awful.spawn(gears.filesystem.get_xdg_config_home() .. "awesome/autorun.sh", false)
--}}}

-- {{{ Tag layout
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.tile,
        awful.layout.suit.floating,
        -- awful.layout.suit.tile.left,
        awful.layout.suit.tile.bottom,
        -- awful.layout.suit.tile.top,
        -- awful.layout.suit.fair,
        awful.layout.suit.fair.horizontal,
        -- awful.layout.suit.spiral,
        -- awful.layout.suit.spiral.dwindle,
        -- awful.layout.suit.max,
        -- awful.layout.suit.max.fullscreen,
        -- awful.layout.suit.magnifier,
        -- awful.layout.suit.corner.nw,
    })
end)
-- }}}

-- {{{ Wallpaper
screen.connect_signal("request::wallpaper", function(s)
    awful.wallpaper {
        screen = s,
        widget = {
            horizontal_fit_policy = "fit",
            vertical_fit_policy = "fit",
            image     = beautiful.wallpaper,
            widget    = wibox.widget.imagebox
        }
    }
end)
-- }}}


-- {{{ Wibar
-- Create a textclock widget
screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table. (NOT!)
    if s.index == 1 then
        awful.tag({ "1", "2", "3", "4", "5", "6", "7" }, s, awful.layout.layouts[1])
    elseif s.index == 2 then
        awful.tag.add("8", {
            screen = s,
            layout = awful.layout.layouts[1],
            selected = true
        })
        awful.tag.add("9", {
            screen = s,
            layout = awful.layout.layouts[1]
        })
    end
    s.mylayoutbox = awful.widget.layoutbox({
        screen  = s,
        buttons = keys.layoutindicatorbuttons
    })
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist({
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = keys.taglistbuttons
    })
    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist({
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = keys.tasklistbuttons
    })
    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        screen   = s,
        widget   = {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                s.mytaglist,
            },
            s.mytasklist, -- Middle widget
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                --arrow(theme.bg_normal, "#343434"),
                wibox.container.margin(widget.cputemp, dpi(4), dpi(4)),
                --[[
                wibox.container.background(wibox.container.margin(wibox.widget({
                    nil, widg.cputemp, layout = wibox.layout.align.horizontal
                }), dpi(4), dpi(4)), "#343434"),
                --]]
                --arrow("#343434", theme.bg_focus),
                wibox.container.margin(widget.gputemp, dpi(4), dpi(4)),
                --[[
                wibox.container.background(wibox.container.margin(wibox.widget({
                    nil, widg.gputemp, layout = wibox.layout.align.horizontal
                }), dpi(3), dpi(6)), theme.bg_focus),
                --]]
                --arrow(theme.bg_focus, "#343434"),
                wibox.container.margin(widget.sysload, dpi(4), dpi(4)),
                --[[
                wibox.container.background(wibox.container.margin(wibox.widget({
                    nil, widg.sysload, layout = wibox.layout.align.horizontal
                }), dpi(4), dpi(4)), "#343434"),
                --]]
                --arrow("#343434", theme.bg_focus),
                wibox.container.margin(widget.clock, dpi(4), dpi(4)),
                --[[
                wibox.container.background(wibox.container.margin(wibox.widget({
                    nil, widg.clock, layout = wibox.layout.align.horizontal
                }), dpi(3), dpi(6)), theme.bg_focus),
                --]]
                --arrow("#343434", theme.bg_normal),
                wibox.widget.systray(),
                s.mylayoutbox,
            },
        }
    })
end)

--}}

--- {{{ Set keybindings and mousebuttons
root.keys(keys.globalkeys)
client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings(keys.clientkeys)
end)
client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings(keys.clientbuttons)
end)
--- }}}

-- {{{ Rules
ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule {
        id         = "global",
        rule       = {},
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    }
    -- Floating clients.
    ruled.client.append_rule {
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
    }

    -- Add titlebars to normal clients and dialogs
    ruled.client.append_rule {
        id = "titlebars",
        rule_any = { type = { "normal", "dialog" }},
        properties = { titlebars_enabled = true }
    }

    -- Bind clients to tags
    -- Game
    ruled.client.append_rule {
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
    }
    -- Chat
    ruled.client.append_rule {
        id = "chat",
        rule_any = { class = { "discord" }},
        properties = { screen = 1, tag = "3" }
    }
    -- Music
    ruled.client.append_rule {
        id = "music",
        rule_any   = { class = { "Spotify" }},
        properties = { screen = 1, tag = "4" }
    }
    -- Launcher
    ruled.client.append_rule {
        id = "launcher",
        rule_any   = { class = { "Steam", "battle.net.exe" }},
        properties = { screen = 1, tag = "5" }
    }
    -- Tools
    ruled.client.append_rule {
        id = "tools",
        rule_any   = { class = { "obs" }},
        properties = { screen = 1, tag = "6" }
    }
    -- Util
    ruled.client.append_rule {
        id = "util",
        rule_any   = { class = { "tsmapplication.exe" }},
        properties = { screen = 1, tag = "7" }
    }
    -- Some clients don't want titlebars
    ruled.client.append_rule {
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
end)

-- Detect clients that spawn without a class
client.connect_signal("request::manage", function(c)
    if not c.class then
        c.minimized = true
        c:connect_signal("property::class", function()
            c.minimized = false
            ruled.client.apply(c)
        end)
    end
end)

-- When a client starts up in fullscreen, resize it to cover the fullscreen a short moment later
-- Fixes wrong geometry when titlebars are enabled
client.connect_signal("request::manage", function(c)
    if c.fullscreen then
        gears.timer.delayed_call(function()
            if c.valid then
                c:geometry(c.screen.geometry)
            end
        end)
    end
end)
-- }}}

-- {{{ Titlebars
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = {
        awful.button({ }, 1, function()
            c:activate { context = "titlebar", action = "mouse_move"  }
        end),
        awful.button({ }, 3, function()
            c:activate { context = "titlebar", action = "mouse_resize"}
        end),
    }

    awful.titlebar(c).widget = {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.minimizebutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)
-- }}}

-- {{{ Notifications
ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule {
        rule       = { },
        properties = {
            screen           = awful.screen.preferred,
            implicit_timeout = 5,
        }
    }
end)

naughty.connect_signal("request::display", function(n)
    naughty.layout.box { notification = n }
end)
-- }}}

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:activate { context = "mouse_enter", raise = false }
end)
