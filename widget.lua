local awfulw = require("awful.widget")
local wiboxw = require("wibox.widget")
--local match, format = string.match, string.format

local _M = {}

local interval = 2

-- Clock wibar widget
_M.clock = wiboxw.textclock("%d/%m %H:%M")

-- Cpu temperature wibar widget
_M.cputemp = awfulw.watch(
    "sensors -u", interval, function(widget, stdout)
        -- We will assume that the first temp1_input entry is the cpu temp
        local out = stdout.match(stdout, "temp1_input: (%d+)%.")
        -- Apparently the stdout object has string operation methods, string.foo not needed
        -- out = format("cpu: %dc", out)
        out = out.format("cpu: %dc", out)
        widget:set_text(out)
    end
)

-- Nvidia gpu temperature wibar widget
_M.gputemp = awfulw.watch(
    "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader", interval, function(widget, stdout)
        local out = stdout.format("gpu: %dc", stdout)
        widget:set_text(out)
    end
)

-- Load average wibar widget
_M.sysload = awfulw.watch(
    "cat /proc/loadavg", interval, function(widget, stdout)
        local out = stdout.match(stdout, "([^%s]+ [^%s]+ [^%s]+)")
        widget:set_text(out)
    end
)

-- Disk space widget
_M.diskfree = awfulw.watch(
    --"sh -c 'df -h --output=avail /home | sed -r '1d;s/\\s+//g''", interval, function(widget, stdout)
    "df -h --output=avail /home", interval, function(widget, stdout)
        local out = stdout.match(stdout, "(%d+G)")
        out = out.format("df: %s", out)
        widget:set_text(out)
    end
)

return _M
