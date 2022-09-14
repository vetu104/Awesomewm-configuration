local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local ruled = require("ruled")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")
local lain = require("lain")

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
modkey = "Mod4"
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
        -- awful.layout.suit.tile.bottom,
        -- awful.layout.suit.tile.top,
        -- awful.layout.suit.fair,
        -- awful.layout.suit.fair.horizontal,
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
            --upscale   = true,
            --downscale = true,
            widget    = wibox.widget.imagebox
            --[[
            valign = "center",
            halign = "center",
            tiled  = false,
            widget = wibox.container.tile,
            --]]
        }
    }
end)
-- }}}

--require("bar")
local theme = beautiful.get()
local separators = lain.util.separators
local arrow = separators.arrow_left

-- cputemp widget
local temp = lain.widget.temp({
    format = "%.0f",
    settings = function()
        widget:set_markup("cpu: "..coretemp_now.."c")
    end
})
-- nvidiatemp widget
local nvtemp = lain.widget.contrib.nvtemp({
    settings = function()
        widget:set_markup("gpu: "..nvtemp_now.."c")
    end
})
-- clock widget
    local clock = wibox.widget.textclock("%d/%m %H:%M")
-- loadavg widget
local loadavg = lain.widget.sysload({
    settings = function()
        widget:set_markup(load_1.." "..load_5.." "..load_15)
    end
})


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
    -- Layout indicator, for each screen
    s.mylayoutbox = awful.widget.layoutbox {
        screen  = s,
        buttons = {
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc(-1) end),
            awful.button({ }, 5, function () awful.layout.inc( 1) end),
        }
    }
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = {
            awful.button({ }, 1, function(t) t:view_only() end),
            awful.button({ modkey }, 1, function(t)
                                            if client.focus then
                                                client.focus:move_to_tag(t)
                                            end
                                        end),
            awful.button({ }, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                                            if client.focus then
                                                client.focus:toggle_tag(t)
                                            end
                                        end),
            awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
        }
    }
    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = {
            awful.button({ }, 1, function (c)
                c:activate { context = "tasklist", action = "toggle_minimization" }
            end),
            awful.button({ }, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
            awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
            awful.button({ }, 5, function() awful.client.focus.byidx( 1) end),
        }
    }

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
                arrow(theme.bg_normal, "#343434"),
                wibox.container.background(wibox.container.margin(wibox.widget({
                    nil, temp.widget, layout = wibox.layout.align.horizontal
                }), dpi(4), dpi(4)), "#343434"),
                arrow("#343434", theme.bg_focus),
                wibox.container.background(wibox.container.margin(wibox.widget({
                    nil, nvtemp.widget, layout = wibox.layout.align.horizontal
                }), dpi(3), dpi(6)), theme.bg_focus),
                arrow(theme.bg_focus, "#343434"),
                wibox.container.background(wibox.container.margin(wibox.widget({
                    nil, loadavg.widget, layout = wibox.layout.align.horizontal
                }), dpi(4), dpi(4)), "#343434"),
                arrow("#343434", theme.bg_focus),
                wibox.container.background(wibox.container.margin(wibox.widget({
                    nil, clock, layout = wibox.layout.align.horizontal
                }), dpi(3), dpi(6)), theme.bg_focus),
                --arrow("#343434", theme.bg_normal),
                wibox.widget.systray(),
                s.mylayoutbox,
            },
        }
    })
end)

-- {{{ Key bindings
-- General Awesome keys
awful.keyboard.append_global_keybindings({
    awful.key({ modkey }, "s", hotkeys_popup.show_help,
        { description="show help", group="awesome" }),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
        { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "e", awesome.quit,
        { description = "quit awesome", group = "awesome" }),
    awful.key({ modkey }, "Return", function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher"} ),
    awful.key({ modkey }, "d", function() awful.spawn("rofi -show drun") end,
        { description = "open rofi", group = "launcher" }),
})
-- Media keys
awful.keyboard.append_global_keybindings({
    awful.key({}, "XF86AudioRaiseVolume", function() awful.spawn("spotify-volume.py raise") end,
        { description="raise music volume", group="media" }),
    awful.key({}, "XF86AudioLowerVolume", function() awful.spawn("spotify-volume.py lower") end,
        { description = "lower music volume", group = "media" }),
    awful.key({}, "XF86AudioMute", function() awful.spawn("pactl set-sink-mute 0 toggle") end,
        { description = "toggle mute", group = "media" }),
    awful.key({}, "XF86AudioPlay", function() awful.spawn("playerctl play-pause") end,
        { description = "pause media", group = "media" }),
    awful.key({}, "XF86AudioNext", function() awful.spawn("playerctl next") end,
        { description = "next media item", group = "media" } ),
    awful.key({}, "XF86AudioPrev", function() awful.spawn("playerctl previous") end,
        { description = "previous media item", group = "media" }),
    awful.key({}, "Print", function()
        awful.spawn.with_shell("scrot -s ~/Pictures/Screenshots/%Y-%m-%dT%H:%M:%S-screenshot.png")
    end,
        { description = "take a screenshot", group = "media" })
})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey }, "j", function() awful.client.focus.byidx(1) end,
        { description = "focus next by index", group = "client" }),
    awful.key({ modkey }, "k", function() awful.client.focus.byidx(-1) end,
        { description = "focus previous by index", group = "client" }),
    awful.key({ modkey }, "Tab", function()
            awful.client.focus.history.previous() if client.focus then client.focus:raise() end
        end,
        { description = "go back", group = "client" }),
    awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative(1) end,
        { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }),
    awful.key({ modkey, "Control" }, "n", function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then c:activate { raise = true, context = "key.unminimize" } end
        end,
        { description = "restore minimized", group = "client" })
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey }, "u", awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }),
    awful.key({ modkey }, "l", function() awful.tag.incmwfact( 0.05) end,
        { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey }, "h", function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
        { description = "increase the number of master clients", group = "layout" }),
    awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
        { description = "decrease the number of master clients", group = "layout" }),
    awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(1, nil, true) end,
        { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "layout" }),
    awful.key({ modkey }, "space", function() awful.layout.inc(1) end,
        { description = "select next", group = "layout" }),
    awful.key({ modkey, "Shift" }, "space", function () awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" })
})


awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function(index)
            local tag = root.tags()[index]
            local screen = tag.screen
            if tag then
                tag:view_only()
                if awful.screen.focused() ~= screen then
                    awful.screen.focus(screen)
                end
            end
        end
    },
    awful.key {
        modifiers   = { modkey, "Control" },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function(index)
            local tag = root.tags()[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end
    },
    awful.key {
        modifiers = { modkey, "Shift" },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function(index)
            if client.focus then
                local tag = root.tags()[index]
                if tag then
                    client.focus:move_to_tag(tag)
                    local screen = tag.screen
                    if awful.screen.focused() ~= screen then
                        awful.screen.focus(screen)
                    end
                end
            end
        end
    }
})

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({}, 1, function(c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, 1, function(c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),
        awful.button({ modkey }, 3, function(c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end)
    })
end)

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey }, "f", function(c) c.fullscreen = not c.fullscreen; c:raise() end,
            { description = "toggle fullscreen", group = "client" }),
        awful.key({ modkey, "Shift" }, "q", function(c) c:kill() end,
            { description = "close", group = "client" }),
        awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle,
            { description = "toggle floating", group = "client" }),
        awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
            { description = "move to master", group = "client" }),
        awful.key({ modkey }, "t", function(c) c.ontop = not c.ontop end,
            { description = "toggle keep on top", group = "client" }),
        awful.key({ modkey }, "n", function(c) c.minimized = true end,
            { description = "minimize", group = "client" }),
        awful.key({ modkey }, "m", function(c) c.maximized = not c.maximized; c:raise() end,
            { description = "(un)maximize", group = "client" }),
        awful.key({ modkey, "Control" }, "m", function(c)
                c.maximized_vertical = not c.maximized_vertical; c:raise()
            end,
            { description = "(un)maximize vertically", group = "client" }),
        awful.key({ modkey, "Shift" }, "m", function(c)
                c.maximized_horizontal = not c.maximized_horizontal; c:raise()
            end,
            { description = "(un)maximize horizontally", group = "client" }),
    })
end)
-- }}}

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
        },
        callback = awful.client.setslave,
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
            fullscreen = true,
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
