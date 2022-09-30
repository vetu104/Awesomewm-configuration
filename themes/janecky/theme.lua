local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local rnotification = require("ruled.notification")
local dpi = xresources.apply_dpi
local gfs = require("gears.filesystem")
local themes_path = gfs.get_xdg_config_home() .. "awesome/themes/"
local wallpapers_path = gfs.get_xdg_data_home() .. "wallpapers/"
local colors = require("colors")

local theme = {}

theme.font          = "sans 11"

theme.bg_focus      = colors.color3
theme.bg_normal     = colors.color1
theme.bg_urgent     = colors.color11
theme.bg_minimize   = colors.color1
theme.bg_systray    = colors.color1
theme.fg_focus      = colors.color5
theme.fg_normal     = colors.color4
theme.fg_urgent     = colors.color6
theme.fg_minimize   = colors.color4

theme.titlebar_bg_focus     = colors.color4
theme.titlebar_bg_normal    = colors.color4
theme.titlebar_fg_focus     = colors.color0
theme.titlebar_fg_normal    = colors.color0

theme.useless_gap         = dpi(10)
theme.border_width        = dpi(0)

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"


-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."janecky/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_focus  = themes_path.."janecky/titlebar/redcircle.png"
theme.titlebar_close_button_normal = themes_path.."janecky/titlebar/redcircle.png"

theme.titlebar_ontop_button_focus_active  = themes_path.."janecky/titlebar/yellowcircle.png"
theme.titlebar_ontop_button_normal_active = themes_path.."janecky/titlebar/yellowcircle.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."janecky/titlebar/graycircle.png"
theme.titlebar_ontop_button_normal_inactive = themes_path.."janecky/titlebar/graycircle.png"

theme.titlebar_floating_button_focus_active  = themes_path.."janecky/titlebar/greencircle.png"
theme.titlebar_floating_button_normal_active = themes_path.."janecky/titlebar/greencircle.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."janecky/titlebar/graycircle.png"
theme.titlebar_floating_button_normal_inactive = themes_path.."janecky/titlebar/graycircle.png"

--theme.wallpaper = gfs.get_random_file_from_dir(wallpapers_path, { "jpg", "png" }, true)
theme.wallpaper = (wallpapers_path .. "0151.jpg")

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."janecky/layouts/fairhw.png"
theme.layout_fairv = themes_path.."janecky/layouts/fairvw.png"
theme.layout_floating  = themes_path.."janecky/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."janecky/layouts/magnifierw.png"
theme.layout_max = themes_path.."janecky/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."janecky/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."janecky/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."janecky/layouts/tileleftw.png"
theme.layout_tile = themes_path.."janecky/layouts/tilew.png"
theme.layout_tiletop = themes_path.."janecky/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."janecky/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."janecky/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."janecky/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."janecky/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."janecky/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."janecky/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- Set different colors for urgent notifications.
rnotification.connect_signal('request::rules', function()
    rnotification.append_rule {
        rule       = { urgency = 'critical' },
        properties = { bg = '#ff0000', fg = '#ffffff' }
    }
end)

return theme
