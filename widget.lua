local awfulw = require("awful.widget")
local wiboxw = require("wibox.widget")

local _M = {}

local interval = 2

-- Clock wibar widget
_M.clock = wiboxw.textclock("%d/%m %H:%M")

-- Cpu temperature wibar widget
_M.cputemp = awfulw.watch(
    "sh -c 'sensors -u'", interval, function(widget, stdout)
        local out = stdout.match(stdout, "temp1_input: (%d+)%.")
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


return _M
