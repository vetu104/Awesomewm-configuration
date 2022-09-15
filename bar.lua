local awful = require("awful")
local keys = require("keys")
local beautiful = require("beautiful")
local wibox = require("wibox")
local lain = require("lain")
local dpi = beautiful.xresources.apply_dpi

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

screen.connect_signal("request::desktop_decoration", function(s)
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
