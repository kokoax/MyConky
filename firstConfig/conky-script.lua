require 'cairo'

package.path = tostring( os.getenv( "HOME" ) ) .. "/scripts/firstConfig/?.lua"
-- package.preload [tostring( os.getenv( "HOME" ) ) .. "/scripts/firstConfig/?.lua"] = function () print "loading firstConfig archive" end
-- package.preload ["~/scripts/firstConfig/?.lua"] = function () print "loading firstConfig archive" end
-- package.preload ["~/scripts/firstConfig/archive"] = function () print "loading firstConfig archive" end

Archive  = require "archive"

CPU      = require "conky-cpu"
Volume   = require "conky-volume"
Battery  = require "conky-battery"
Time     = require "conky-time"
Calendar = require "conky-calendar"
MPD      = require "conky-mpd"
Weather  = require "conky-weather"

perWidth  = 0
perHeight = 0

win_hei = 0
win_wid = 0

font_ricty = "Ricty"
font_takao = "TakaoGothic"
font_adam = "ADAM.CG PRO"
font_logos = "OpenLogos"
font_logoGothic ="07ロゴたいぷゴシックCondense"
font_smartFont="03スマートフォン卜UI"

font_slant = CAIRO_FONT_SLANT_NORMAL
font_face = CAIRO_FONT_WEIGHT_NORMAL

local function putResolution( cr )
  cairo_select_font_face( cr, font_takao, font_slant, font_face )
  cairo_set_font_size( cr, 16 )
  cairo_set_source_rgb( cr, 1, 1, 1 )
  cairo_move_to( cr, 30, 30 )
  cairo_show_text( cr, tostring( win_hei ) )

  cairo_move_to( cr, 30, 45 )
  cairo_show_text( cr, tostring( win_wid ) )
  cairo_stroke( cr )
end

cs, cr = nil
function conky_cairo_main()
  -- Start of initializing

  if conky_window == nil then return end

  local cs = cairo_xlib_surface_create(
                                        conky_window.display,
                                        conky_window.drawable,
                                        conky_window.visual,
                                        conky_window.width,
                                        conky_window.height
                                      )

  perWidth  = ( conky_window.width / 1920  )
  perHeight = ( conky_window.height / 1080 )
  win_hei = conky_window.height
  win_wid = conky_window.width

  cr = cairo_create( cs )

  -- End of initializing

  local updates = tonumber( conky_parse( "${updates}" ) )

  putResolution( cr )

  -- volumeGraph( cr )
  -- batteryGraph( cr )
  if( updates > 5 ) then
    Time.putTime( cr )
    CPU.CPUGraph( cr )
    Volume.volumeCircleGraph( cr )
    Battery.batteryCircleGraph( cr )
    Weather.putWeather( cr )
    Calendar.calendarCircle( cr )
  end
  -- MpdStatus( cr )

  cairo_set_source_rgb( cr, 1, 1, 1 )

  cairo_destroy(cr)
  cairo_surface_destroy(cs)

  cr=nil
end

