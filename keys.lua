local awful = require("awful")
local gt = require("gears.table")
local hotkeys_popup = require("awful.hotkeys_popup")

local _M = {}
local modkey = "Mod4"

_M.globalkeys = gt.join(
    -- General
    awful.key({ modkey              },          "s",            hotkeys_popup.show_help,
            { description = "show help", group = "awesome" }),
    awful.key({ modkey, "Control"   },          "r",            awesome.restart,
            { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Shift"     },          "e",            awesome.quit,
            { description = "quit awesome", group = "awesome" }),
    awful.key({ modkey              },        "Return",         function() awful.spawn(terminal) end,
            { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey              },          "d",            function() awful.spawn("rofi -show drun") end,
            { description = "open rofi", group = "launcher" }),
    -- Focus manipulation
    awful.key({ modkey              },          "j",            function() awful.client.focus.byidx(1) end,
            { description = "focus next by index", group = "client" }),
    awful.key({ modkey              },          "k",            function() awful.client.focus.byidx(-1) end,
            { description = "focus previous by index", group = "client" }),
    awful.key({ modkey, "Control"   },          "j",            function() awful.screen.focus_relative(1) end,
            { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey, "Control"   },          "k",            function() awful.screen.focus_relative(-1) end,
            { description = "focus the previous screen", group = "screen" }),
    awful.key({ modkey              },          "u",            awful.client.urgent.jumpto,
            { description = "jump to urgent client", group = "client" }),
    awful.key({ modkey              },         "Tab",           function()
        awful.client.focus.history.previous() if client.focus then client.focus:raise() end
    end,
            { description = "go back", group = "client" }),
    -- Client manipulation
    awful.key({ modkey, "Shift"     },          "j",            function() awful.client.swap.byidx(1) end,
            { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey,     "Shift" },          "k",            function () awful.client.swap.byidx(-1) end,
            { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey, "Control"   },          "n",            function()
        local c = awful.client.restore()
        if c then c:activate { raise = true, context = "key.unminimize" } end
    end,
            { description = "restore minimized", group = "client" }),
    -- Media
    awful.key({                     }, "XF86AudioRaiseVolume",  function() awful.spawn("spotify-volume.py raise") end,
            { description="raise music volume", group="media" }),
    awful.key({                     }, "XF86AudioLowerVolume",  function() awful.spawn("spotify-volume.py lower") end,
            { description = "lower music volume", group = "media" }),
    awful.key({                     },     "XF86AudioMute",     function()
        awful.spawn("pactl set-sink-mute 0 toggle")
    end,
            { description = "toggle mute", group = "media" }),
    awful.key({                     },     "XF86AudioPlay",     function() awful.spawn("playerctl play-pause") end,
            { description = "pause media", group = "media" }),
    awful.key({                     },     "XF86AudioNext",     function() awful.spawn("playerctl next") end,
            { description = "next media item", group = "media" } ),
    awful.key({                     },     "XF86AudioPrev",     function() awful.spawn("playerctl previous") end,
            { description = "previous media item", group = "media" }),
    awful.key({                     },         "Print",         function()
        awful.spawn.with_shell("scrot -s ~/Pictures/Screenshots/%Y-%m-%dT%H:%M:%S-screenshot.png")
    end,
            { description = "take a screenshot", group = "media" }),
    -- Layout manipulation
    awful.key({ modkey              },          "l",            function() awful.tag.incmwfact(0.05) end,
            { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey              },          "h",            function() awful.tag.incmwfact(-0.05) end,
            { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey,     "Shift" },          "h",            function() awful.tag.incnmaster(1, nil, true) end,
            { description = "increase the number of master clients", group = "layout" }),
    awful.key({ modkey, "Shift"     },          "l",            function() awful.tag.incnmaster(-1, nil, true) end,
            { description = "decrease the number of master clients", group = "layout" }),
    awful.key({ modkey, "Control"   },          "l",            function() awful.tag.incncol(1, nil, true) end,
            { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, "Control"   },          "h",            function() awful.tag.incncol(-1, nil, true) end,
            { description = "decrease the number of columns", group = "layout" }),
    awful.key({ modkey              },        "space",          function() awful.layout.inc(1) end,
            { description = "select next", group = "layout" }),
    awful.key({ modkey, "Shift"     },        "space",          function() awful.layout.inc(-1) end,
            { description = "select previous", group = "layout" }),
    -- Tag manipulation
    awful.key({
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
    }),
    awful.key({
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
    }),
    awful.key({
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
    })
)

_M.clientkeys = gt.join(
    awful.key({ modkey              },          "f",            function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end,
            { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey, "Shift"     },          "q",            function(c) c:kill() end,
            { description = "close", group = "client" }),
    awful.key({ modkey, "Control"   },         "space",         awful.client.floating.toggle,
            { description = "toggle floating", group = "client" }),
    awful.key({ modkey, "Control"   },        "Return",         function(c) c:swap(awful.client.getmaster()) end,
            { description = "move to master", group = "client" }),
    awful.key({ modkey              },          "o",            function(c) c:move_to_screen() end,
            { description = "move to screen", group = "client" }),
    awful.key({ modkey              },          "t",            function(c) c.ontop = not c.ontop end,
            { description = "toggle keep on top", group = "client" }),
    awful.key({ modkey              },          "n",            function(c) c.minimized = true end,
            { description = "minimize", group = "client" }),
    awful.key({ modkey              },          "m",            function(c)
        c.maximized = not c.maximized
        c:raise()
    end,
            { description = "(un)maximize", group = "client" }),
    awful.key({ modkey, "Control"   },          "m",            function(c)
        c.maximized_vertical = not c.maximized_vertical; c:raise()
    end,
            { description = "(un)maximize vertically", group = "client" }),
    awful.key({ modkey, "Shift"     },          "m",            function(c)
        c.maximized_horizontal = not c.maximized_horizontal; c:raise()
    end,
            { description = "(un)maximize horizontally", group = "client" })
)

_M.clientbuttons = gt.join(
    awful.button({}, 1, function(c)
        c:activate({ context = "mouse_click" })
    end),
    awful.button({ modkey }, 1, function(c)
        c:activate({ context = "mouse_click", action = "mouse_move" })
    end),
    awful.button({ modkey }, 3, function(c)
        c:activate({ context = "mouse_click", action = "mouse_resize"})
    end)
)

_M.taglistbuttons = gt.join(
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
    awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end)
)

_M.layoutindicatorbuttons = gt.join(
    awful.button({ }, 1, function() awful.layout.inc( 1) end),
    awful.button({ }, 3, function() awful.layout.inc(-1) end),
    awful.button({ }, 4, function() awful.layout.inc(-1) end),
    awful.button({ }, 5, function() awful.layout.inc( 1) end)
)

_M.tasklistbuttons = gt.join(
    awful.button({ }, 1, function(c)
        c:activate({ context = "tasklist", action = "toggle_minimization" })
    end),
    awful.button({ }, 3, function() awful.menu.client_list({ theme = { width = 250 } }) end),
    awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
    awful.button({ }, 5, function() awful.client.focus.byidx( 1) end)
)
return _M
