require 'cairo'
require 'conky-volume.lua'
require 'conky-battery.lua'
require 'conky-cpu.lua'
require 'conky-mpd.lua'
require 'conky-date.lua'
require 'conky-weather.lua'

perWidth  = 0
perHeight = 0

win_hei = 0
win_wid = 0

font_ricty = "Ricty"
font_takao = "TakaoGothic"
-- font = "Bitstream Vera Sans"
-- font = "xfc"
font_adam = "ADAM.CG PRO"
font_logos = "OpenLogos"
-- font = "staff"
font_size = 32

-- xpos, ypox = 100, 100
-- red, green, blue, alpha = 1, 1, 1, 1
red, green, blue, alpha = 1, 1, 1, 1
font_slant = CAIRO_FONT_SLANT_NORMAL
font_face = CAIRO_FONT_WEIGHT_NORMAL

function circleGraph( cr, x, y, size, per )
  local angle1 = -90.0 * ( math.pi/180 )
  local angle2 = ( 360-90 ) * ( math.pi/180 )

  local dist = angle1 - angle2

  -- cairo_arc( cr, win_wid * (3*4), win_hei/2 + 20, size, angle1, angle2 + dist - ( dist * per ) )
  cairo_arc( cr, x, y, size, angle1, angle2 + dist - ( dist * per ) )
  cairo_stroke( cr )
end


function putSideBar( cr, BarX, per )
  local barWid = 70 * perWidth

  local BarTop    = win_hei*0.2
  local BarBottom = win_hei - win_hei*0.1
  local BarLen = BarBottom - BarTop

  cairo_set_line_width( cr, barWid )

  cairo_move_to( cr, BarX, BarBottom )
  cairo_line_to( cr, BarX, BarBottom - ( BarLen * per ) )
  cairo_stroke( cr )
end

function SideBarText( cr, volBarX, text )
  local BarBottom = win_hei - win_hei*0.1

  cairo_select_font_face( cr, font_takao, font_slant, font_face )

  cairo_set_source_rgb( cr, 1, 1, 1 )
  cairo_move_to( cr, volBarX - (#text)*4, BarBottom + 25 * perWidth )
  -- cairo_move_to( cr, volBarX - (#text)*4, BarBottom )
  cairo_set_font_size( cr, 16 )
  cairo_show_text( cr, text )
  cairo_stroke( cr )
end

function leftArc( cr, arcWidth, size, per )
  local angle1 = 135.0 * ( math.pi/180 )
  local angle2 = 225.0 * ( math.pi/180 )

  local dist = angle1 - angle2

  cairo_set_line_width( cr, arcWidth * perWidth )
  cairo_arc( cr, win_wid/2, win_hei/2 + 20, size, angle1, angle2 + dist - ( dist * per ) )
  cairo_stroke( cr )
end

function rightArc( cr, arcWidth, size, per )
  local angle1 = 315.0 * ( math.pi/180 )
  local angle2 = 405.0 * ( math.pi/180 )

  local dist = angle1 - angle2

  cairo_set_line_width( cr, arcWidth * perWidth )
  cairo_arc( cr, win_wid/2, win_hei/2 + 20, size, angle1, angle2 + ( dist - ( dist * per ) ) )

  cairo_stroke( cr )
end

cs, cr = nil
function conky_cairo_main()
  -- Start of initialize

  if conky_window == nil then
    return
  end
  local cs = cairo_xlib_surface_create(conky_window.display,
  conky_window.drawable,
  conky_window.visual,
  conky_window.width,
  conky_window.height)

  perWidth  = ( conky_window.width / 1920  )
  perHeight = ( conky_window.height / 1080 )
  win_hei = conky_window.height
  win_wid = conky_window.width

  cr = cairo_create( cs )

  cairo_select_font_face( cr, font_takao, font_slant, font_face )
  cairo_set_font_size( cr, font_size )
  cairo_set_source_rgba( cr, red, green, blue, alpha )

  -- End of initialize
  cairo_set_font_size( cr, 16 )
  cairo_set_source_rgb( cr, 1, 1, 1 )
  cairo_move_to( cr, 30, 30 )
  cairo_show_text( cr, tostring( win_hei ) )

  cairo_move_to( cr, 30, 45 )
  cairo_show_text( cr, tostring( win_wid ) )
  cairo_stroke( cr )

  -- volumeGraph( cr )
  -- batteryGraph( cr )
  volumeCircleGraph( cr )
  batteryCircleGraph( cr )
  CPUGraph( cr )
  putTime( cr )
  putWeather( cr )
  -- MpdStatus( cr )

  cairo_destroy(cr)
  cairo_surface_destroy(cs)

  cr=nil
end


