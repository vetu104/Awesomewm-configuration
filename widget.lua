local awful = require("awful")
local wibox = require("wibox")
--local match, format = string.match, string.format

local _M = {}

local interval = 2

-- Clock wibar widget
_M.clock = wibox.widget({
    format = "<span foreground='#2E3440' size='large'> %d/%m %H:%M </span>",
    widget = wibox.widget.textclock
})

-- Cpu temperature wibar widget
_M.cputemp = awful.widget.watch(
    "sensors -u", interval, function(widget, stdout)
        local out = stdout.match(stdout, "temp1_input: (%d+)%.")
        out = out.format("<span foreground='%s' size='large'> cpu: %dc </span>", x.nord0, out)
        widget:set_markup(out)
    end
)

-- Nvidia gpu temperature wibar widget
_M.gputemp = awful.widget.watch(
    "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader", interval, function(widget, stdout)
        local out = stdout.format("<span foreground='%s' size='large'> gpu: %dc </span>", x.nord0, stdout)
        widget:set_markup(out)
    end
)

-- Load average wibar widget
_M.sysload = awful.widget.watch(
    "cat /proc/loadavg", interval, function(widget, stdout)
        local out = stdout.match(stdout, "([^%s]+ [^%s]+ [^%s]+)")
        out = out.format("<span foreground='%s' size='large'> %s </span>", x.nord0, out)
        widget:set_markup(out)
    end
)

-- Disk space widget
_M.diskfree = awful.widget.watch(
    --"sh -c 'df -h --output=avail /home | sed -r '1d;s/\\s+//g''", interval, function(widget, stdout)
    "df -h --output=avail /home", interval, function(widget, stdout)
        local out = stdout.match(stdout, "(%d+G)")
        out = out.format("<span foreground='%s' size='large'> df: %s </span>", x.nord0, out)
        widget:set_markup(out)
    end
)

return _M
