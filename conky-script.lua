require 'cairo'
-- require 'rsvg2'

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

function volumeCircleText( cr, x, y )
  local vol = tostring( conky_parse( '${exec amixer -c 0 get Master | grep Mono: | cut -d " " -f6}' ) )
  volStatus = string.match( vol, "([%d]+)" )
  local text = volStatus.."%"

  cairo_select_font_face( cr, font_adam, font_slant, font_face )
  -- cairo_select_font_face( cr, font_logos, font_slant, font_face )

  cairo_set_source_rgb( cr, 1, 1, 1 )
  cairo_move_to( cr, x, y )
  cairo_set_font_size( cr, 32 )
  cairo_show_text( cr, text )
  cairo_stroke( cr )
end

function volumeCircleGraph( cr )
  local xpos = win_wid*(4/5)
  local ypos = win_hei * 0.8

  local vol = tostring( conky_parse( '${exec amixer -c 0 get Master | grep Mono: | cut -d " " -f6}' ) )
  vol = tonumber( string.match( vol, "([%d]+)" ) )
  local per = vol * 1/100
  local size = 80

  cairo_set_source_rgba( cr, 0.4, 0.4, 0.4, 0.1 )
  cairo_set_line_width( cr, 5 )
  circleGraph( cr, xpos, ypos, size, 1 )

  cairo_set_source_rgba( cr, 0.6, 0.6, 0, 0.2 )
  cairo_set_line_width( cr, 10 )
  circleGraph( cr, xpos, ypos, size*(6/7), per )

  cairo_set_source_rgba( cr, 0.6, 0.6, 0, 0.2 )
  cairo_set_line_width( cr, 1 )

  cairo_move_to( cr, xpos, ypos - 80 )
  cairo_line_to( cr, xpos, ypos - 80 - 60 )
  cairo_line_to( cr, win_wid, ypos - 80 - 60 )

  cairo_stroke( cr )

  volumeCircleText( cr, xpos + size/2 + 50, ypos - 80 - 60 + 40 )

end

function batteryCircleGraph( cr )
  local angle1 = -90.0 * ( math.pi/180 )
  local angle2 = ( 360-90 ) * ( math.pi/180 )

  local xpos = win_wid*(1/5)
  local ypos = win_hei * 0.8

  local dist = angle1 - angle2
  local size = 80

  local batt_stat = tostring( conky_parse( '${battery BAT0}' ) )
  local battPer = tonumber( conky_parse( '${battery_percent BAT0}' ) )
  local per = battPer * 1/100

  cairo_set_source_rgba( cr, 0.4, 0.4, 0.4, 0.1 )
  cairo_set_line_width( cr, 5 )
  -- cairo_arc( cr, win_wid/2, win_hei/2 + 20, size, angle1, angle2 + dist - ( dist * per ) )
  cairo_arc( cr, xpos, ypos, size, 0, 2 * math.pi )
  cairo_stroke( cr )

  cairo_set_source_rgba( cr, 0.1, 0.8, 0.3, 0.1 )
  cairo_set_line_width( cr, 10 )

  cairo_arc( cr, xpos, ypos, size*(6/7), angle1, angle2 + dist - ( dist * per ) )
  cairo_stroke( cr )

  cairo_set_source_rgba( cr, 0.1, 0.8, 0.3, 0.2 )
  cairo_set_line_width( cr, 1 )

  cairo_move_to( cr, xpos, ypos - size )
  cairo_line_to( cr, xpos, ypos - size - 60 )
  cairo_line_to( cr, 0, ypos - size - 60 )

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

function volumeGraph( cr )
  local barWid = 70 * perWidth

  local vol = tostring( conky_parse( '${exec amixer -c 0 get Master | grep Mono: | cut -d " " -f6}' ) )
  vol = string.match( vol, "([%d]+)" )

  if( vol == nil ) then
    vol = 1
  end

  local volPer = ( vol / 100 )

  local volBarX  = ( win_wid * 0.10 ) + ( barWid/2 )

  -- under bar
  cairo_set_source_rgba( cr, 0.4, 0.4, 0.4, 0.1 )
  putSideBar( cr, volBarX, 1 )

  -- volume % bar
  -- cairo_set_source_rgba( cr, 0.1, 0.3, 0.8, 0.2 )
  cairo_set_source_rgba( cr, 1, 1, 1, 0.2 )
  putSideBar( cr, volBarX, volPer )

  SideBarText( cr, volBarX, "Volume "..vol.."%" )
end

function batteryGraph( cr )
  local barWid = 70 * perWidth

  local batt_stat = tostring( conky_parse( '${battery BAT0}' ) )
  local battPer = tonumber( conky_parse( '${battery_percent BAT0}' ) )

  local battBarX  = ( win_wid * 0.9 ) - ( barWid/2 )

  -- under bar
  cairo_set_source_rgba( cr, 0.4, 0.4, 0.4, 0.1 )
  putSideBar( cr, battBarX, 1 )

  -- battery % bar
  -- cairo_set_source_rgba( cr, 0.1, 0.8, 0.3, 0.2 )
  -- cairo_set_source_rgba( cr, 0.6, 0.6, 0, 0.2 )
  if( battPer >= 75 ) then
    cairo_set_source_rgba( cr, 0.6, 0.6, 0, 0.2 )
  elseif( battPer <= 25 ) then
    cairo_set_source_rgba( cr, 0.6, 0, 0, 0.3 )
  end

  putSideBar( cr, battBarX, battPer * (1/100) )

  SideBarText( cr, battBarX, "Battery "..battPer.."%" )
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

function CPUText( cr, x, y, text )
  cairo_select_font_face( cr, font_takao, font_slant, font_face )

  cairo_set_source_rgb( cr, 1, 1, 1 )
  cairo_move_to( cr, x, y )
  cairo_set_font_size( cr, 16 )
  cairo_show_text( cr, text )
  cairo_stroke( cr )
end

function CPUGraph( cr )
  -- CPU 1
  cairo_set_source_rgba( cr, 0.4, 0.4, 0.4, 0.1 )
  leftArc( cr, 40, 250, 1 )
  cairo_set_source_rgba( cr, 0.4, 0.4, 0.4, 0.1 )
  CPUText( cr, win_wid/2 - ( ( 40/2 + 250 ) * 1/math.sqrt(2) ) + 20, win_hei/2 + 20 + ( ( 40/2 + 250 ) * 1/math.sqrt(2) ), "CPU1" )
  -- CPUText( cr, win_wid/2 - ( ( 40/2 + 250 * perWidth ) * 1/math.sqrt(2) ) + 20, win_hei/2 + 20 + ( ( 40/2 + 250 ) * 1/math.sqrt(2) ), "CPU1" )

  -- CPU 2
  cairo_set_source_rgba( cr, 0.4, 0.4, 0.4, 0.1 )
  leftArc( cr, 70, 250 + 70*perWidth, 1 )
  CPUText( cr, win_wid/2 - ( ( 70/2 + 320 ) * 1/math.sqrt(2) ) + 25, win_hei/2 + 20 + ( ( 70/2 + 320 ) * 1/math.sqrt(2) ) - 10, "CPU2" )
  -- CPUText( cr, win_wid/2 - ( ( 70/2 + 320 * perWidth ) * 1/math.sqrt(2) ) + 25, win_hei/2 + 20 + ( ( 70/2 + 320 ) * 1/math.sqrt(2) ) - 10, "CPU2" )
  -- CPUText( cr )

  -- CPU 3
  cairo_set_source_rgba( cr, 0.4, 0.4, 0.4, 0.1 )
  rightArc( cr, 40, 250, 1 )
  CPUText( cr, win_wid/2 + ( ( 40/2 + 250 ) * 1/math.sqrt(2) ) - 50, win_hei/2 + 20 - ( ( 40/2 + 250 ) * 1/math.sqrt(2) ) + 13, "CPU3" )
  -- CPUText( cr, win_wid/2 + ( ( 40/2 + 250 * perWidth ) * 1/math.sqrt(2) ) - 50, win_hei/2 + 20 - ( ( 40/2 + 250 ) * 1/math.sqrt(2) ) + 13, "CPU3" )
  -- CPUText( cr )

  -- CPU 4
  cairo_set_source_rgba( cr, 0.4, 0.4, 0.4, 0.1 )
  rightArc( cr, 70, 250 + 70*perWidth, 1 )
  CPUText( cr, win_wid/2 + ( ( 70/2 + 320 ) * 1/math.sqrt(2) ) - 57, win_hei/2 + 20 - ( ( 70/2 + 320 ) * 1/math.sqrt(2) ) + 23, "CPU4" )
  -- CPUText( cr, win_wid/2 + ( ( 70/2 + 320 * perWidth) * 1/math.sqrt(2) ) - 57, win_hei/2 + 20 - ( ( 70/2 + 320 ) * 1/math.sqrt(2) ) + 23, "CPU4" )
  --- CPUText( cr )

  local cpu1 = tonumber( conky_parse( '${cpu cpu1}' ) )
  local cpu2 = tonumber( conky_parse( '${cpu cpu2}' ) )
  local cpu3 = tonumber( conky_parse( '${cpu cpu3}' ) )
  local cpu4 = tonumber( conky_parse( '${cpu cpu4}' ) )

  -- CPU1
  cairo_set_source_rgba( cr, 0.1, 0.3, 0.8, 0.2 )
  if( cpu1 > 0 ) then
    leftArc( cr, 40, 250, 1/cpu1 )
  end

  -- CPU2
  cairo_set_source_rgba( cr, 0.1, 0.3, 0.8, 0.2 )
  if( cpu2 > 0 ) then
    leftArc( cr, 70, 250 + 70*perWidth, 1/cpu2 )
  end

  -- CPU3
  cairo_set_source_rgba( cr, 0.1, 0.3, 0.8, 0.2 )
  if( cpu3 > 0 ) then
    rightArc( cr, 40, 250, 1/cpu3 )
  end

  -- CPU4
  cairo_set_source_rgba( cr, 0.1, 0.3, 0.8, 0.2 )
  if( cpu4 > 0 ) then
    rightArc( cr, 69, 250 + 70*perWidth, 1/cpu4 )
  end

  CPUText( cr )
end

function bigTime( cr )
  local Hour   = tostring( conky_parse( '${time %H}' ) )
  local Minute = tostring( conky_parse( '${time %M}' ) )

  cairo_select_font_face( cr, font_takao, font_slant, font_face )

  -- cairo_set_source_rgba( cr, 0, 0.55, 0, 0.8 )
  -- cairo_set_source_rgba( cr, 1, 1, 1, 0.5 )
  -- cairo_set_source_rgba( cr, 0.4, 0.4, 0.4, 0.5 )
  cairo_set_source_rgba( cr, 100/255, 100/255, 100/255, 0.5 )
  -- cairo_move_to( cr, win_wid/2 - (85*#Minute)/2 + 0, win_hei/2 - 40 + 60 ) 1920 depend
  -- cairo_move_to( cr, win_wid/2 - (80*#Hour  )/2 - 60, win_hei/2 - 60 + 60 )
  cairo_move_to( cr, win_wid/2 - (80*#Hour  )/2 - 30, win_hei/2 - 40 - 200 )
  cairo_set_font_size( cr, 160 )
  cairo_show_text( cr, Hour )

  -- cairo_set_source_rgba( cr, 0, 0.6, 0.7, 0.8 )
  cairo_set_source_rgba( cr, 1, 1, 1, 0.5 )
  -- cairo_move_to( cr, win_wid/2 - (85*#Minute)/2 + 0, win_hei/2 + 40 + 60 ) 1920 depend
  -- cairo_move_to( cr, win_wid/2 - (80*#Minute)/2 + 60, win_hei/2 + 60 + 60 )
  cairo_move_to( cr, win_wid/2 - (80*#Minute)/2 + 30, win_hei/2 + 40 - 200 )
  cairo_set_font_size( cr, 160 )
  cairo_show_text( cr, Minute )

  cairo_stroke( cr )
end

function putTime( cr )
  local Time = tostring( conky_parse( '${time %H:%M}' ) )

  cairo_select_font_face( cr, font_takao, font_slant, font_face )

  cairo_set_source_rgba( cr, 255/255, 255/255, 255/255, 0.5 )

  cairo_move_to( cr, win_wid/2 - (60*#Time )/2 - 10, win_hei/2 - 40 - 200 )
  cairo_set_font_size( cr, 120 )
  cairo_show_text( cr, Time )
end

function MpdStatus( cr )
  local MpdAlbum  = conky_parse( '${mpd_album}' )
  local MpdArtist = conky_parse( '${mpd_artist}' )
  local MpdStatus= conky_parse( '${mpd_status}' )
  local MpdBar    = conky_parse( '${mpd_bar 300, 400}' )

  cairo_set_source_rgba( cr, 1, 1, 1, 1 )
  cairo_set_font_size( cr, 30)

  cairo_move_to( cr, win_wid/2 - ( 15*#MpdStatus )/2, win_hei - win_hei*0.95 )
  cairo_show_text( cr, MpdStatus )
  -- cairo_show_text( cr, MpdAlbum )
  -- cairo_show_text( cr, MpdArtist )
  cairo_stroke( cr )
end

function putWeather( cr )
  local image = cairo_image_surface_create_from_png( "~/.WeatherIcon/png/02.png" );

  widImage = cairo_image_surface_get_width( image )
  heiImage = cairo_image_surface_get_height( image )

  cairo_scale( cr, 256.0/widImage, 256.0/heiImage )

  cairo_set_source_surface( cr, image, 40, 40 )
  cairo_paint( cr )
  cairo_surface_destroy( image )
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
  local updates  = tonumber( conky_parse( '${updates}' ) )

  local nodeName = tostring( conky_parse( '${nodename}' ) )
  local sysName  = tostring( conky_parse( '${sysname}' ) )
  local kernel   = tostring( conky_parse( '${kernel}' ) )
  local machine  = tostring( conky_parse( '${machine}' ) )

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


