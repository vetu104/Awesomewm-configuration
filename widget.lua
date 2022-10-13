local beautiful = require("beautiful")
local awful = require("awful")
local wibox = require("wibox")
local colors = require("colors")
local dpi = beautiful.xresources.apply_dpi

local _M = {}

local interval = 2

-- Clock wibar widget
_M.clock = {
    {
        {
            widget = wibox.widget({
                format = "<span foreground='#2E3440' size='large'> %d/%m %H:%M </span>",
                widget = wibox.widget.textclock
            })
        },
        left    = dpi(4),
        right   = dpi(4),
        widget  = wibox.container.margin,
    },
    bg          = colors.color15,
    widget      = wibox.container.background,
}

-- Cpu temperature wibar widget
_M.cputemp = {
    {
        {
            widget = awful.widget.watch(
                "sensors -u", interval, function(widget, stdout)
                    local out = stdout.match(stdout, "temp1_input: (%d+)%.")
                    out = out.format("<span foreground='%s' size='large'> cpu: %dc </span>", colors.color0, out)
                    widget:set_markup(out)
                end)
        },
        left    = dpi(4),
        right   = dpi(4),
        widget  = wibox.container.margin,
    },
    bg          = colors.color12,
    widget      = wibox.container.background,
}

-- Nvidia gpu temperature wibar widget
_M.gputemp = {
    {
        {
            widget = awful.widget.watch(
                "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader", interval, function(widget, stdout)
                    local out = stdout.format(
                        "<span foreground='%s' size='large'> gpu: %dc </span>", colors.color0, stdout)
                    widget:set_markup(out)
                end)
        },
        left    = dpi(4),
        right   = dpi(4),
        widget  = wibox.container.margin,
    },
    bg          = colors.color13,
    widget      = wibox.container.background,
}

-- Load average wibar widget
_M.sysload = {
    {
        {
            widget = awful.widget.watch(
                "cat /proc/loadavg", interval, function(widget, stdout)
                    local out = stdout.match(stdout, "([^%s]+ [^%s]+ [^%s]+)")
                    out = out.format("<span foreground='%s' size='large'> %s </span>", colors.color0, out)
                    widget:set_markup(out)
                end)
        },
        left    = dpi(4),
        right   = dpi(4),
        widget  = wibox.container.margin,
    },
    bg          = colors.color14,
    widget      = wibox.container.background,
}

-- Disk space widget
_M.diskfree = {
    {
        {
            widget = awful.widget.watch(
                "df -h --output=avail /home /media/hdd0", interval, function(widget, stdout)
                    local hd0,hd1 = stdout.match(stdout, "(%d+G)%s+(%d+G)")
                    local out = string.format("<span foreground='%s' size='large'> sdd: %s hdd: %s </span>", colors.color0, hd0, hd1)
                    widget:set_markup(out)
                end)
        },
        left    = dpi(4),
        right   = dpi(4),
        widget  = wibox.container.margin,
    },
    bg          = colors.color11,
    widget      = wibox.container.background,
}

return _M
