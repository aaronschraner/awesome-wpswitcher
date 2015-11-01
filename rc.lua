-- Standard awesome library
gears = require("gears")
awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
wibox = require("wibox")
-- Theme handling library
beautiful = require("beautiful")
-- Notification library
naughty = require("naughty")
menubar = require("menubar")
require("hostname")
naughty.config.presets.normal.opacity = 0.8
naughty.config.presets.low.opacity = 0.8
naughty.config.presets.critical.opacity = 0.8
-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}
-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/usr/share/awesome/themes/1337/theme.lua") --change this
-- This is used later as the default terminal and editor to run.
terminal = "xterm -rv -en UTF-8"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
--altwp= "/home/aaron/Pictures/plneon.jpg"
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
icodir = "/usr/share/icons/hicolor/32x32/apps/"
kuhler ={--ignore aaaaaallll this shit.
	colors = {
		high= "-r255",
		low = "-g255 -b255",
		a = {
			h = {
				r=" 255",
				g=" 0",
				b=" 0",
				modeline =function () return "-r"..r.." -g"..g.." -b"..b..'' end,
				toggle = function(m) 
					if m=='r' then if r==" 0" then r=" 255" else r=" 0" end end
					if m=='g' then if g==" 0" then g=" 255" else g=" 0" end end
					if m=='b' then if b==" 0" then b=" 255" else b=" 0" end end
					kuhler.setstate({power="high"})
				end,
	
			},
			l = {
				r=" 0",
				g=" 255",
				b=" 255",
				modeline =function () return "-r"..r.." -g"..g.." -b"..b end,
				toggle = function(m) 
					if m=='r' then if r==" 0" then r=" 255" else r=" 0" end end
					if m=='g' then if g==" 0" then g=" 255" else g=" 0" end end
					if m=='b' then if b==" 0" then b=" 255" else b=" 0" end end
					kuhler.setstate({power="low"})
				end,
			},
		},
	},
	setstate = function(m) 
		if m.modeline then
			awful.util.spawn_with_shell("sudo kuhler_ctl "..m.modeline);
			naughty.notify({text="Cooler updated. "..m.modeline});
		else if m.power=="high" then 
			if m.r then kuhler.colors.a.h.r=m.r end
			if m.g then kuhler.colors.a.h.g=m.g end
			if m.b then kuhler.colors.a.h.b=m.b end
			awful.util.spawn("sudo kuhler_ctl -m2 "..kuhler.colors.a.h.modeline());
			naughty.notify({text="Cooler updated."..kuhler.colors.a.h.modeline()})
		else if m.power=="low" then
			if m.r then kuhler.colors.a.l.r=m.r end
			if m.g then kuhler.colors.a.l.g=m.g end
			if m.b then kuhler.colors.a.l.b=m.b end
			awful.util.spawn("sudo kuhler_ctl -m0 "..kuhler.colors.a.l.modeline())
			naughty.notify({text="Cooler updated."..kuhler.colors.a.l.modeline()})
		end end end
	end,

}
myawesomemenu = {
   { "wallpapers",
   	{ 
		{"tron", function () wpdir="/home/aaron/wallpapers/tron"; loadwps() end},
		{"5760x1080", function () wpdir="/home/aaron/wallpapers/5760x1080"; loadwps() end}, --change these to set wallpaper sets on the fly
		{"misc", function () wpdir="/home/aaron/wallpapers/misc"; loadwps() end}, --change these to set wallpaper sets on the fly
	}
	},
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit },
   { "keymap", 
   	{
		{ "Dvorak", function() awful.util.spawn("setxkbmap dvorak") end },
		{ "Default",function() awful.util.spawn("setxkbmap us"    ) end },
	}
   }
}
myappmenu = {
	{ "firefox", "firefox", icodir .. "firefox.png"},
	{ "terminal", terminal },
	{ "blender", "blender" ,icodir .. "blender.png"},
	{ "gimp", "gimp" ,icodir .. "gimp.png"},
	{ "email", "thunderbird" ,icodir .. "thunderbird.png"},
	{ "mixer", "xterm -rv -e alsamixer -D hw:0"},
	{ "EQ", "xterm -rv -e alsamixer -D equal"},
	{ "ncmpcpp", "xterm -rv -e ncmpcpp"},
	{ "visualizer", "xterm -rv -e ncmpcpp -s visualizer", "/usr/share/icons/oxygen/32x32/actions/view-media-visualization.png"},
	{ "Gparted", "gksudo gparted", icodir .. "gparted.png"},
	{ "Calculator", "xcalc", icodir .. "../../../oxygen/32x32/apps/accessories-calculator.png"},
	{ "Libreoffice", "libreoffice", icodir .. "libreoffice-main.png"},
	{ "Minecraft", "minecraft"}
}
pbicodir="/usr/share/icons/gnome/32x32/actions/"
playbackmenu = {
	{ "toggle", "mpc toggle"},
	{ "play", "mpc play", pbicodir .. "media-playback-start.png"},
	{ "pause", "mpc pause", pbicodir .. "gtk-media-pause.png"},
	{ "skip", "mpc next", pbicodir .. "stock_media-next.png"},
	{ "skip back", "mpc prev", pbicodir .. "gtk-media-previous-ltr.png"},
	{ "stop", "mpc stop", pbicodir .. "stock_media-stop.png" }
}
powermenu = {
	{ "shutdown", "systemctl poweroff"},
	{ "reboot", "systemctl reboot"},
	{ "sleep", "systemctl suspend"},
	{ "lock", "xlock -mode clock"},
	{ "CPU fan", {
			{"High", function() kuhler.setstate({modeline="-m2 "..kuhler.colors.high}) end},
			{"Low",  function() kuhler.setstate({modeline="-m0 "..kuhler.colors.low }) end},
			{"Kuhlerd", "sudo kuhlerd"},
			{ "Colors", {
				{"High", {
						{"Red",   function() kuhler.setstate({modeline='-m2 -r255'}); end},
						{"Green", function() kuhler.setstate({modeline='-m2 -g255'}); end},
						{"Blue",  function() kuhler.setstate({modeline='-m2 -b255'}); end},
					}
				},
				{"Low", {
						{"Red" ,  function() kuhler.setstate({modeline='-m0 -r255'}); end},
						{"Green", function() kuhler.setstate({modeline='-m0 -g255'}); end},
						{"Blue",  function() kuhler.setstate({modeline='-m0 -b255'}); end},
					}
					
					
				},
			}},
		},
	}
}
mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal },
				    { "programs", myappmenu },
				    { "playback", playbackmenu },
				    { "power", powermenu }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
wpdir="/home/aaron/wallpapers/5760x1080/" --set this to a directory containing wallpapers. I'll send you details on the directory structure.
altwpf = io.popen("ls " .. wpdir )
safewpstate=true
wptable={}
wpdexs=1
wpdex=10
uhdex=1
--{{ LAPTOP EXCLUSIVE KEYS
laptopkeys=awful.util.table.join(
	awful.key({ modkey}, "/", function() naughty.notify({text="lappykey"}) end ))
--}}

--{{ DESKTOP EXCLUSIVE KEYS
desktopkeys=awful.util.table.join(
	awful.key({ modkey}, "/", function() naughty.notify({text="TANKS"}) end ))
--}}
for str in altwpf:lines() do
	wptable[wpdexs]=str
	wpdexs = wpdexs + 1
end
wpdexs = wpdexs - 1
function loadwps() --refresh wallpaper
	altwpf:close()
	    altwpf=io.popen("ls \"" .. wpdir .. "\"" )
	    local i=1
	    for str in altwpf:lines() do
		    wptable[i]=str
		    i = i + 1
		    wpdexs=i-1
	    end
	    if wpdex > wpdexs then
		    wpdex=0
	    end

end
safewp = "/usr/share/awesome/themes/1337/background.png" --change this
-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
local blingbling = require("blingbling") --delete this
calendar = blingbling.calendar()
calendar:set_link_to_external_calendar(true)

mytextclock = awful.widget.textclock()
--[[local calendar = nil
    local offset = 0

    function remove_calendar()
        if calendar ~= nil then
            naughty.destroy(calendar)
            calendar = nil
            offset = 0
        end
    end

    function add_calendar(inc_offset)
        local save_offset = offset
        remove_calendar()
        offset = save_offset + inc_offset
        local datespec = os.date("*t")
        datespec = datespec.year * 12 + datespec.month - 1 + offset
        datespec = (datespec % 12 + 1) .. " " .. math.floor(datespec / 12)
        local cal = awful.util.pread("cal -m " .. datespec)
        cal = string.gsub(cal, "^%s*(.-)%s*$", "%1")
        calendar = naughty.notify({
            text = string.format('<span font_desc="%s">%s</span>', "monospace", os.date("%a, %d %B %Y") .. "\n" .. cal),
            timeout = 0, hover_timeout = 0.5,
            width = 160,
        })
    end
-- change clockbox for your clock widget (e.g. mytextclock)
    mytextclock:add_signal("mouse::enter", function()
      add_calendar(0)
    end)
    mytextclock:add_signal("mouse::leave", remove_calendar)
 
    mytextclock:buttons(awful.util.table.join(
        button({ }, 4, function()
            add_calendar(-1)
        end),
        button({ }, 5, function()
            add_calendar(1)
        end)

    )) --]]
-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))
local vicious = require("vicious")
  -- Top widgets:
  cpu_graph = blingbling.line_graph({ height = 18, --this whole thing probably won't work out of the box.
                                      width = 160,
                                      show_text = true,
                                      label = "Cpu: $percent %",
                                      rounded_size = 0.3,
                                                                                                                                                        background_color = blingbling.helpers.rgba(47,28,28,0.0),
                                      graph_background_color = blingbling.helpers.rgba(47,28,28,0.0),
                                      font = "Droid Sans Mono"
                                     })
  vicious.register(cpu_graph, vicious.widgets.cpu,'$1',2)

  mem_graph = blingbling.line_graph({ height = 18,
                                      width = 160,
                                      show_text = true,
                                      label = "Mem: $percent %",
                                      rounded_size = 0.3,
                                      graph_background_color = "#30303000",--blingbling.helpers.rgba(9,15,43,0.0),
                                      text_background_color = "#000000",
                                                                                                                                                        font = "Droid Sans Mono"
                                     })

        vicious.register(mem_graph, vicious.widgets.mem, '$1', 2)
        root_fs_usage=blingbling.value_text_box({height = 14, width = 40, v_margin = 4})
        --root_fs_usage:set_height(16)
        --root_fs_usage:set_width(40)
        --root_fs_usage:set_v_margin(2)
        root_fs_usage:set_text_background_color("#222222")
        root_fs_usage:set_values_text_color({{blingbling.helpers.rgb(59,162,117),0}, --all value > 0 will be displaying using this color
                                  {blingbling.helpers.rgb(96,149,197), 0.5},
                                                                                                                {blingbling.helpers.rgb(181,136,88),0.77}})
        --There is no maximum number of color that users can set, just put the lower values at first. 
        root_fs_usage:set_text_color(beautiful.textbox_widget_as_label_font_color)
        root_fs_usage:set_rounded_size(0.4)
        root_fs_usage:set_font_size(8)
        root_fs_usage:set_background_color("#00000000")
        root_fs_usage:set_label("root: $percent %")

        vicious.register(root_fs_usage, vicious.widgets.fs, "${/ used_p}", 120 )
        shutdown=blingbling.system.shutdownmenu() --icons have been set in theme
        reboot=blingbling.system.rebootmenu() --icons have been set in theme
        lock=blingbling.system.lockmenu() --icons have been set in theme
        logout=blingbling.system.logoutmenu()
        mytag={}
        --test = blingbling.text_box()

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
	left_layout:add(wibox.layout.margin(mytag[s],0,0,2,2))
                --left_layout:add(wibox.layout.margin(mytaglist[s],0,0,1,1))
    		left_layout:add(mypromptbox[s])
                left_layout:add(cpu_graph)
                left_layout:add(mem_graph)
    		left_layout:add(root_fs_usage)
    
    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    --right_layout:add(volume_bar)
                --right_layout:add(mytextclock)
                right_layout:add(calendar)
   		right_layout:add(mylayoutbox[s])
                right_layout:add(reboot)
                right_layout:add(shutdown)
                right_layout:add(logout)
                right_layout:add(lock)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}
wptp=nil
bars=true 
function putwp() --display whatever wallpaper you have selected. Most of this should work as long as you have 3 monitors.
	--to use this, split the wallpapers into 1920x1080 pictures titled 1.jpg, 2.jpg, 3.jpg (png also works) and put them in a folder.
		for s = 1, screen.count() do
		    if(io.popen("ls "..(wptp or beautiful.wallpaper.."/"..s..".jpg")):read()==(wptp or beautiful.wallpaper).."/"..s..".jpg") then
			    gears.wallpaper.maximized((wptp or beautiful.wallpaper).."/"..s..".jpg", (-s+2)%3+1, true)
		    elseif(io.popen("ls "..(wptp or beautiful.wallpaper.."/"..s..".png")):read()==(wptp or beautiful.wallpaper).."/"..s..".png") then
		    	    gears.wallpaper.maximized((wptp or beautiful.wallpaper).."/"..s..".png", (-s+2)%3+1, true)
		    else
		    	gears.wallpaper.maximized(wptp or beautiful.wallpaper, s, true)
		end
	    end
    end

-- {{{ Key bindings
globalkeys = awful.util.table.join(
--    awful.key({		          }, "#172", awful.util.spawn_with_shell("ncmpcpp toggle") ),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Shift"   }, "Return", function () awful.util.spawn("xterm -rv -e sudo su") end), --very useful
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),
    
    -- Custom key
    awful.key({	modkey,		  }, "i",     function () awful.util.spawn("xterm -rv -e sudo wicd-curses") end), --great wifi program once you get it working.
    awful.key({ modkey,		  }, "F2",    function () awful.util.spawn("firefox") end),
    awful.key({ modkey, 	  }, "F3",    function () awful.util.spawn("thunar")  end),
    awful.key({ modkey,		  }, "F4",    function () awful.util.spawn("blender") end),
    awful.key({ modkey, 	  }, "F5",    function () awful.util.spawn("xterm -rv -e alsamixer") end),
    awful.key({ modkey, 	  }, "F6",    function () awful.util.spawn("thunderbird") end),
    awful.key({}, "XF86AudioPlay", 	      function () awful.util.spawn("mpc toggle") end), --playback controls
    awful.key({}, "XF86AudioPrev", 	      function () awful.util.spawn("mpc prev") end),
    awful.key({}, "XF86AudioNext", 	      function () awful.util.spawn("mpc next") end),
    awful.key({ modkey, "Shift"	  }, ";",     function () awful.util.spawn("xlock -mode dclock") end),
    awful.key({ modkey,		  }, ";",     function () awful.util.spawn_with_shell("xlock -mode dclock & xset dpms force off") end), --lock and turn off screens. 
    awful.key({ modkey, 	  }, "c",     function () awful.util.spawn("xterm -rv calcurse") end),
    awful.key({ modkey, "Shift"   }, "m",     function () awful.util.spawn("xterm -rv ncmpcpp") end), 
    awful.key({ modkey, 	  }, "v",     function () awful.util.spawn("xterm -rv  -e ncmpcpp -c .ncmpcpp/nobar") end), 
    awful.key({ modkey, "Shift"   }, "t",     function () awful.util.spawn("xterm -rv htop") end), 
    awful.key({ modkey,           }, "e",     function () awful.util.spawn("xterm -rv -e alsamixer -D equal") end),
    awful.key({ modkey, 	  }, "q",     function () awful.util.spawn("xterm -rv -e qalc") end), 
    awful.key({ modkey,	"Shift"   }, "n",     function () awful.util.spawn("xterm -rv -e \"ssh mc@192.168.1.26\"") end), --ssh to NCS.
    awful.key({ modkey,           }, "u",     function () gears.wallpaper.maximized(beautiful.wallpaper,2,true) end), 
    awful.key({ modkey, 	  }, "s",     function () naughty.notify({text = "Current wallpaper: " .. beautiful.wallpaper .. " [" .. wpdex .. "]"}) end),--display current wallpaper
    awful.key({ modkey, "Control" }, "x",     function () awful.util.spawn_with_shell("pkill xcompmgr; xcompmgr") end),
    awful.key({ modkey, "Control" }, "s",     function () awful.util.spawn("scrot /home/aaron/scrots/scrot-fullscreen-%Y-%m-%d_%H:%M:%S.png -e \"xterm -rv -e scrotChName \\$n\"")  end),
    awful.key({ modkey, "Shift"   }, "s",     function () awful.util.spawn_with_shell("sleep 0.2;scrot -s /home/aaron/scrots/scrot-partial-%Y-%m-%d_%H:%M:%S.png -e \"xterm -rv -e scrotChName \\$n\"")  end), 
    awful.key({ modkey, "Control" }, ";",     function () awful.util.spawn("setxkbmap us") end),
    awful.key({ modkey, "Control" }, "z",     function () awful.util.spawn("setxkbmap dvorak") end), --switch keymap between dvorak and qwerty
    awful.key({ modkey, "Shift"   }, "p",     function () --toggle between wallpaper list and default wallpaper
	    if safewpstate == true then
		    if wpdex == -1 then
			    wpdex = wpdex + 1
		    end
		    beautiful.wallpaper = altwp or wpdir .. "/" .. wptable[wpdex+1]
		    safewpstate = false
	    else
		    beautiful.wallpaper = safewp or "/usr/share/awesome/themes/1337/background.png"
		    safewpstate = true
	    end
		putwp()
	 end
    ),
    awful.key({ modkey, "Control"   }, "w",	function ()
	   loadwps()--reload wallpaper set after change
    end),

    awful.key({ modkey, "Control"   }, "p",     function ()
	    safewpstate = false
	    wpdex=(wpdex+1)%(wpdexs)
	   beautiful.wallpaper=wpdir.."/"..wptable[wpdex+1]
	   putwp()--display next wallpaper
    end
    ),
    awful.key({ modkey, "Control", "Shift" }, "p",     function ()
	    safewpstate = false
	    wpdex=(wpdex+wpdexs-1)%(wpdexs)
	    beautiful.wallpaper=wpdir.."/"..wptable[wpdex+1]
		 putwp()--display previous wallpaper

    end
    ),
    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey, 	  }, "b",      function (c) awful.titlebar.toggle(c,top) end),--useful. Toggles bars on windows.
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      function (c) awful.client.movetoscreen(c,c.screen-1)        end),
    awful.key({ modkey, "Shift"	  }, "o",      function (c) awful.client.movetoscreen(c,c.screen+1) end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.movetotag(tag)
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.toggletag(tag)
                      end
                  end))
end
if hostname=="archtank" then
	globalkeys=awful.util.table.join(globalkeys, desktopkeys)
elseif hostname=="archtop" then
	globalkeys=awful.util.table.join(globalkeys, laptopkeys)
end
clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}
client.connect_signal("focus", function(c)
	c.border_color=beautiful.border_focus
	if(c.class=="XTerm") then
		c.opacity=.75
	end
end)
client.connect_signal("unfocus", function(c)
	c.border_color=beautiful.border_normal
	if(c.class=="XTerm")
	then
		c.opacity=.6
	end
end)
-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "conky" },
      properties = { floating = true, border_width = 0 } },
    { rule = { class = "XTerm" },
      properties = { opacity = 0.70 } }, --This is where xterm gets its transparency.
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = bars 
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c)) --arrow
        right_layout:add(awful.titlebar.widget.maximizedbutton(c)) --rocket
        right_layout:add(awful.titlebar.widget.stickybutton(c)) --plus
        right_layout:add(awful.titlebar.widget.ontopbutton(c)) --star
        right_layout:add(awful.titlebar.widget.closebutton(c)) --X

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
	awful.titlebar.hide(c,top)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
function run_once(cmd)
  local findme = cmd
  local firstspace = cmd:find(" ")
  if firstspace then
                findme = cmd:sub(0, firstspace-1)
        end
        awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end
--run_once("qjackctl")
run_once("volumeicon")
-- }}}
