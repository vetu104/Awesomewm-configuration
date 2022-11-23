local beautiful = require("beautiful")
local awful = require("awful")
local wibox = require("wibox")
local colors = require("colors")
local dpi = beautiful.xresources.apply_dpi
local lain = require("lain")

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
                    local out = string.format("<span foreground='%s' size='large'> ssd: %s hdd: %s </span>", colors.color0, hd0, hd1)
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

--MPD
--[[
local musicplr = awful.util.terminal .. " -title Music -g 130x34-320+16 -e ncmpcpp"
mpdicon:buttons(my_table.join(
    awful.button({ modkey }, 1, function () awful.spawn.with_shell(musicplr) end),
    awful.button({ }, 1, function ()
        os.execute("mpc prev")
        theme.mpd.update()
    end),
    awful.button({ }, 2, function ()
        os.execute("mpc toggle")
        theme.mpd.update()
    end),
    awful.button({ }, 3, function ()
        os.execute("mpc next")
        theme.mpd.update()
    end)))
--]]
_M.mpd = lain.widget.mpd({
    settings = function()
        if mpd_now.state == "play" then
            artist = " " .. mpd_now.artist .. " "
            title  = mpd_now.title  .. " "
            --mpdicon:set_image(theme.widget_music_on)
            widget:set_markup(lain.util.markup.font(awesome.font, lain.util.markup("#FF8466", artist) .. " " .. title))
        elseif mpd_now.state == "pause" then
            widget:set_markup(lain.util.markup.font(awesome.font, " mpd paused "))
            --mpdicon:set_image(theme.widget_music_pause)
        else
            widget:set_text("")
            --mpdicon:set_image(theme.widget_music)
        end
end})

return _M
