local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local naughty = require("naughty")
local ruled = require("ruled")
require("awful.hotkeys_popup.keys")
local wibox = require("wibox")
local keys = require("keys") --custom
local rules = require("rules") --custom
local widget = require("widget") --custom
local lain = require("lain")
local colors = require("colors")
local dpi = beautiful.xresources.apply_dpi

laptopmode = os.getenv("AWESOME_LAPTOP")

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
local theme = "janecky"
beautiful.init(gears.filesystem.get_xdg_config_home() .. "awesome/themes/" .. theme .. "/theme.lua")
terminal = "st"
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
        awful.layout.suit.tile.bottom,
        awful.layout.suit.floating,
        -- awful.layout.suit.tile.left,
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
            widget    = wibox.widget.imagebox
        }
    }
end)
-- }}}

-- {{{ Wibar
local arrow = lain.util.separators.arrow_left

screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table. (NOT!)
    if s.index == 1 then
        awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8" }, s, awful.layout.layouts[1])
    elseif s.index == 2 then
        awful.tag.add("9", {
            screen = s,
            layout = awful.layout.layouts[2],
            selected = true
        })
        awful.tag.add("10", {
            screen = s,
            layout = awful.layout.layouts[2]
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
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = keys.tasklistbuttons,
        style    = {
            shape_border_width = dpi(1),
            shape_border_color = colors.color4,
            shape  = gears.shape.rounded_bar,
        },
        layout   = {
            spacing = 10,
            spacing_widget = {
                {
                    forced_width = 5,
                    shape        = gears.shape.circle,
                    widget       = wibox.widget.separator
                },
                valign = 'center',
                halign = 'center',
                widget = wibox.container.place,
            },
            layout  = wibox.layout.flex.horizontal
        },
        widget_template = {
            {
                {
                    {
                        {
                            id     = 'icon_role',
                            widget = wibox.widget.imagebox,
                        },
                        margins = 2,
                        widget  = wibox.container.margin,
                    },
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left  = 10,
                right = 10,
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
    },
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
            {-- Middle widget
                layout = wibox.layout.fixed.horizontal,
                s.mytasklist,
            },
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                widget.mpd,
                arrow(colors.color1, colors.color11),
                widget.diskfree,
                arrow(colors.color11, colors.color12),
                widget.cputemp,
                arrow(colors.color12, colors.color13),
                widget.gputemp,
                arrow(colors.color13, colors.color14),
                widget.sysload,
                arrow(colors.color14, colors.color15),
                widget.clock,
                arrow(colors.color15, colors.color1),
                wibox.widget.systray(),
                s.mylayoutbox,
            },
        }
    })
end)

--}}

--- {{{ Set keybindings and mousebuttons (keys.lua)
awful.keyboard.append_global_keybindings(keys.globalkeys)
client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings(keys.clientkeys)
end)
client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings(keys.clientbuttons)
end)
--- }}}

--- {{{ Set client rules (rules.lua)
ruled.client.connect_signal("request::rules", function()
    ruled.client.append_rules(rules)
end)

-- Detect clients that spawn without a class
-- (c) https://github.com/elenapan
client.connect_signal("request::manage", function(c)
    if not c.class then
        c.minimized = true
        c:connect_signal("property::class", function()
            c.minimized = false
            ruled.client.apply(c)
        end)
    end
end)
--- }}}


-- {{{ Titlebars
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = {
        awful.button({ }, 1, function()
            c:activate({ context = "titlebar", action = "mouse_move" })
        end),
        awful.button({ }, 3, function()
            c:activate({ context = "titlebar", action = "mouse_resize" })
        end),
    }
    local tb = awful.titlebar(c, {
    size = dpi(28)
    })
    tb.widget = {
        { -- Left
            wibox.container.margin(awful.titlebar.widget.closebutton(c), dpi(6), dpi(6), dpi(6), dpi(6)),
            wibox.container.margin(awful.titlebar.widget.ontopbutton(c), dpi(6), dpi(6), dpi(6), dpi(6)),
            wibox.container.margin(awful.titlebar.widget.floatingbutton(c), dpi(6), dpi(6), dpi(6), dpi(6)),
            --awful.titlebar.widget.iconwidget(c),
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
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal
        },
        layout = wibox.layout.align.horizontal
    }
end)
-- }}}

-- {{{ Notifications
ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule({
        rule       = { },
        properties = {
            screen           = awful.screen.preferred,
            implicit_timeout = 5,
        }
    })
end)

naughty.connect_signal("request::display", function(n)
    naughty.layout.box({ notification = n })
end)
-- }}}

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:activate({ context = "mouse_enter", raise = false })
end)

if laptopmode then
    awful.keyboard.append_global_keybindings({
    awful.key({                     }, "XF86AudioRaiseVolume",  function() awful.spawn("pactl set-sink-volume 0 +5%", false) end,
            { description="raise music volume", group="media" }),
    awful.key({                     }, "XF86AudioLowerVolume",  function() awful.spawn("pactl set-sink-volume 0 -5%", false) end,
            { description = "lower music volume", group = "media" })
    })
else
    awful.keyboard.append_global_keybindings({
        awful.key({                     }, "XF86AudioRaiseVolume",  function() awful.spawn("mpc volume +5", false) end,
                { description="raise music volume", group="media" }),
        awful.key({                     }, "XF86AudioLowerVolume",  function() awful.spawn("mpc volume -5", false) end,
                { description = "lower music volume", group = "media" }),
    })
end
