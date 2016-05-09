require 'cairo'

require 'conky-cpu'
-- require 'conky-volume'
-- require 'conky-battery'
-- require 'conky-weather'
-- require 'conky-calendar'
-- require 'conky-time'

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
font_logoGothic ="07ロゴたいぷゴシックCondense"
font_smartFont="03スマートフォン卜UI"
-- font = "staff"
font_size = 32

-- xpos, ypox = 100, 100
-- red, green, blue, alpha = 1, 1, 1, 1
red, green, blue, alpha = 1, 1, 1, 1
font_slant = CAIRO_FONT_SLANT_NORMAL
font_face = CAIRO_FONT_WEIGHT_NORMAL

function command( cmd )
  local handle = io.popen( cmd )
  local content = handle:read( "*all" )
  handle:close()
  return string.gsub( content, "\n", "" )
end

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

function batteryCircleText( cr, x, y, text )
  cairo_select_font_face( cr, font_adam, font_slant, font_face )
  -- cairo_select_font_face( cr, font_logos, font_slant, font_face )
  afterText = "Battery"

  text = text.."%"

  cairo_set_source_rgb( cr, 1, 1, 1 )
  cairo_move_to( cr, x - #tostring( text )*20 - #afterText*5, y )
  cairo_set_font_size( cr, 32 )
  cairo_show_text( cr, text )

  cairo_set_source_rgb( cr, 1, 1, 1 )
  cairo_move_to( cr, x - #tostring( text )*5, y )
  cairo_set_font_size( cr, 12 )
  cairo_show_text( cr, afterText )

  cairo_stroke( cr )
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

  cairo_move_to( cr, xpos, ypos - size - 5 )
  cairo_line_to( cr, xpos, ypos - size - 60 )
  cairo_line_to( cr, 0, ypos - size - 60 )
  cairo_stroke( cr )

  -- volumeCircleText( cr, xpos + size/2 + 50, ypos - 80 - 60 + 40, vol )
  batteryCircleText( cr, xpos - size, ypos - 80 - 60 + 40, battPer )

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

function volumeCircleText( cr, x, y, text )
  text = text.."%"
  local afterText = "VOLUME"

  cairo_select_font_face( cr, font_adam, font_slant, font_face )
  -- cairo_select_font_face( cr, font_logos, font_slant, font_face )

  -- cairo_set_source_rgb( cr, 1, 1, 1 )
  -- cairo_move_to( cr, x, y )
  -- cairo_set_font_size( cr, 32 )
  -- cairo_show_text( cr, text.." VOL" )

  cairo_set_source_rgb( cr, 1, 1, 1 )
  cairo_move_to( cr, x, y )
  cairo_set_font_size( cr, 32 )
  cairo_show_text( cr, text )

  cairo_set_source_rgb( cr, 1, 1, 1 )
  cairo_move_to( cr, x + #tostring( text )*23, y )
  cairo_set_font_size( cr, 12 )
  cairo_show_text( cr, afterText )

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

  cairo_move_to( cr, xpos, ypos - 80 - 5 )
  cairo_line_to( cr, xpos, ypos - 80 - 60 )
  cairo_line_to( cr, win_wid, ypos - 80 - 60 )

  cairo_stroke( cr )

  volumeCircleText( cr, xpos + size/2, ypos - 80 - 60 + 40, vol )

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

function bigTime( cr )
  local Hour   = tostring( conky_parse( '${time %H}' ) )
  local Minute = tostring( conky_parse( '${time %M}' ) )

  cairo_select_font_face( cr, font_takao, font_slant, font_face )
  -- cairo_select_font_face( cr, font_logoGothic, font_slant, font_face )

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
  -- cairo_select_font_face( cr, font_logoGothic, font_slant, font_face )
  -- cairo_select_font_face( cr, font_smartFont, font_slant, font_face )

  cairo_set_source_rgba( cr, 255/255, 255/255, 255/255, 0.5 )

  cairo_move_to( cr, win_wid/2 - (60*#Time )/2 - 5, win_hei/2 - 40 - 200 )
  cairo_set_font_size( cr, 120 )
  cairo_show_text( cr, Time )

  cairo_stroke( cr )
end

function weatherDiscliption( cr, x, y, day )
  local Discription = tostring( command( "~/scripts/weather -"..day.." -c" ) )
  local LargeTemp = command( "~/scripts/weather -"..day.." -lt" )
  local SmallTemp = command( "~/scripts/weather -"..day.." -st" )

  local localYear, localMonth, localDay = string.match( command( "~/scripts/weather -"..day.." -day" ), "(%d%d%d%d)(%d%d)(%d%d)" )

  -- print( localMonth )
  -- print( localDay )

  localMonth = tostring( tonumber( localMonth ) )
  localDay = tostring( tonumber( localDay ) )

  cairo_select_font_face( cr, font_takao, font_slant, font_face )
  cairo_set_source_rgb( cr, 1, 1, 1 )

  -- date
  -- cairo_set_source_rgb( cr, 0, 0.5, 0.7 )
  cairo_set_source_rgb( cr, 1, 1, 1 )
  cairo_move_to( cr, x+64 + 15, y+17 )
  cairo_set_font_size( cr, 16 )
  cairo_show_text( cr, localMonth.."/"..localDay)
  -- cairo_show_text( cr, "Today" )

  -- weather discription
  -- cairo_set_source_rgb( cr, 0, 0.7, 0.5 )
  -- cairo_set_source_rgb( cr, 0.7, 0.7, 0.5 )
  cairo_set_source_rgb( cr, 1, 1, 1 )
  cairo_move_to( cr, x+64 + 27, y+17 + 22*1 )
  cairo_set_font_size( cr, 16 )
  cairo_show_text( cr, Discription )

  -- Large temp / Samll temp
  -- cairo_set_source_rgb( cr, 0, 0.7, 0.5 )
  -- cairo_set_source_rgb( cr, 0.7, 0.7, 0.5 )
  cairo_set_source_rgb( cr, 1, 1, 1 )
  cairo_move_to( cr, x+64 + 27, y+17+22*2 )
  cairo_set_font_size( cr, 16 )
  cairo_show_text( cr, LargeTemp.."℃".." / "..SmallTemp.."℃" )

  cairo_stroke( cr )
end

function putWeather( cr )
  local image_today = cairo_image_surface_create_from_png( "/home/kokoax/.WeatherIcon/png/64/"..command( "~/scripts/weather -0 -i" )..".png" )
  local image_tomorrow = cairo_image_surface_create_from_png( "/home/kokoax/.WeatherIcon/png/64/"..command( "~/scripts/weather -1 -i" )..".png" )
  local image_day_after = cairo_image_surface_create_from_png( "/home/kokoax/.WeatherIcon/png/64/"..command( "~/scripts/weather -2 -i" )..".png" )

  local widToday = cairo_image_surface_get_width( image_today)
  local heiToday = cairo_image_surface_get_height( image_today)
  local widTomo  = cairo_image_surface_get_width( image_tomorrow )
  local heiTom   = cairo_image_surface_get_height( image_tomorrow )
  local widDA    = cairo_image_surface_get_width( image_day_after )
  local heiDA    = cairo_image_surface_get_height( image_day_after )

  -- today
  cairo_set_source_surface( cr, image_today,    win_wid*0.8 - widToday, win_hei/4.5 )
  cairo_paint( cr )

  -- tomorrow
  cairo_set_source_surface( cr, image_tomorrow, win_wid*0.8 - widTomo, win_hei/4.5 + 64 + 30 )
  cairo_paint( cr )

  -- day after tomorrow
  cairo_set_source_surface( cr, image_day_after, win_wid*0.8 - widTomo, win_hei/4.5 + 64*2 + 30*2 )
  cairo_paint( cr )

  -- today discription
  weatherDiscliption( cr, win_wid*0.8 - widToday, win_hei/4.5,               "0" )

  -- tomorrow discription
  weatherDiscliption( cr, win_wid*0.8 - widToday, win_hei/4.5 + 64 + 30,     "1" )

  -- day after tomorrow discription
  weatherDiscliption( cr, win_wid*0.8 - widToday, win_hei/4.5 + 64*2 + 30*2, "2" )

  -- tomorrow discription
  -- weatherDiscliption( cr, win_wid*0.8 - widToday, win_hei/4.5 )

  cairo_surface_destroy( image_today )
  cairo_surface_destroy( image_tomorrow )
end

function cvAngSin( angle )
  return math.sin( angle * math.pi)
end

function cvAngCos( angle )
  return math.cos( angle * math.pi )
end

function setWeekColor( weekName, alpha )
  if( weekName == "Sun" ) then
    -- cairo_set_source_rgba( cr, 1, 0.6, 0.1, alpha )
    cairo_set_source_rgba( cr, 255/255, 145/255, 1/255, alpha )
  elseif( weekName == "Mon" ) then
    -- cairo_set_source_rgba( cr, 1, 1, 1, alpha )
    cairo_set_source_rgba( cr, 195/255, 195/255, 195/255, alpha )
  elseif( weekName == "Tue" ) then
    -- cairo_set_source_rgba( cr, 0.8, 0.2, 0.2, alpha )
    cairo_set_source_rgba( cr, 235/255, 29/255, 0/255, alpha )
  elseif( weekName == "Wed" ) then
    -- cairo_set_source_rgba( cr, 0.2, 0.2, 0.8, alpha )
    cairo_set_source_rgba( cr, 110/255, 140/255, 190/255, alpha )
  elseif( weekName == "Thu" ) then
    -- cairo_set_source_rgba( cr, 1, 1, 1, alpha )
    cairo_set_source_rgba( cr, 73/255, 198/255, 96/255, alpha )
  elseif( weekName == "Fri" ) then
    -- cairo_set_source_rgba( cr, 1, 0.9, 0, alpha )
    cairo_set_source_rgba( cr, 195/255, 195/255, 1/255, alpha )
  elseif( weekName == "Sat" ) then
    -- cairo_set_source_rgba( cr, 1, 0.5, 0.1, alpha )
    cairo_set_source_rgba( cr, 177/255, 104/255, 51/255, alpha )
  end
end

function calendarCircle( cr )
  local i = 0
  local today_last  = command( "LANG=C date +'%d' -d \"1 days ago `date +%Y%m01 -d '+1 month'`\"" )
  local before_last = command( "LANG=C date +'%d' -d \"2 days ago `date +%Y%m01 -d '+1 month'`\"" )

  local calWid = win_wid/8
  local calHei = win_hei/2.5

  local calBubble = {
    { x = calWid + cvAngSin( 360/7*5 ) *120, y = calHei + cvAngCos( 360/7*5 + 90/2 )*120 },
    { x = calWid + cvAngSin( 360/7*1 ) *120, y = calHei + cvAngCos( 360/7*1 + 90/2 )*120 },
    { x = calWid + cvAngSin( 360/7*4 ) *120, y = calHei + cvAngCos( 360/7*4 + 90/2 )*120 },
    { x = calWid + cvAngSin( 360/7*0 ) *120, y = calHei + cvAngCos( 360/7*0 + 90/2 )*120 },
    { x = calWid + cvAngSin( 360/7*3 ) *120, y = calHei + cvAngCos( 360/7*3 + 90/2 )*120 },
    { x = calWid + cvAngSin( 360/7*6 ) *120, y = calHei + cvAngCos( 360/7*6 + 90/2 )*120 },
    { x = calWid + cvAngSin( 360/7*2 ) *120, y = calHei + cvAngCos( 360/7*2 + 90/2 )*120 },
  }

  cairo_set_line_width( cr, 1 )
  cairo_set_source_rgba( cr, 1, 1, 1, 0.1 )
  cairo_arc( cr, calWid, calHei, 142, 0, 2 * math.pi )
  cairo_stroke( cr )

  -- cairo_move_to( cr, win_hei/2, win_wid/2 )
  -- cairo_set_line_width( cr, 40 )
  cairo_set_line_width( cr, 40 )
  cairo_set_source_rgba( cr, 1, 1, 1, 0.2 )
  cairo_stroke( cr )

  i = 0
  for index, item in ipairs( calBubble ) do
    local weekName= tostring( command( "LANG=C date +'%a' -d '" .. tostring( i - 3 ) .. " days'" ) )
    if( i == 3 ) then
      -- cairo_set_source_rgba( cr, 1, 1, 1, 0.4 )
      setWeekColor( weekName, 0.4 )
      cairo_arc( cr, item["x"], item["y"]+10, 10, 0, 2 * math.pi )
    elseif( i < 3 ) then
      -- cairo_set_source_rgba( cr, 0.7, 0.7, 0.7, 0.1 )
      setWeekColor( weekName, 0.1 )
      cairo_arc( cr, item["x"], item["y"], 1, 0, 2 * math.pi )
    elseif( i > 3 ) then
      -- cairo_set_source_rgba( cr, 0.7, 0.7, 0.7, 0.3 )
      setWeekColor( weekName, 0.1 )
      cairo_arc( cr, item["x"], item["y"], 1, 0, 2 * math.pi )
    end
    cairo_stroke( cr )
    i = i + 1
  end

  cairo_stroke( cr )
  -- cairo_select_font_face( cr, font_takao, font_slant, font_face )
  -- cairo_select_font_face( cr, font_logoGothic, font_slant, font_face )
  cairo_select_font_face( cr, font_smartFont, font_slant, font_face )

  cairo_set_font_size( cr, 16 )
  cairo_set_source_rgb( cr, 1, 1, 1 )

  i = 0
  for index, item in ipairs( calBubble ) do
    local day = tostring( tonumber( tostring( command( "LANG=C date +'%d' -d '" .. tostring( i - 3 ) .. " days'" ) ) ) )
    local weekName= tostring( command( "LANG=C date +'%a' -d '" .. tostring( i - 3 ) .. " days'" ) )

    if( i == 3 ) then
      cairo_set_font_size( cr, 24 )
      -- cairo_set_source_rgba( cr, 0, 0, 0, 1 )
      cairo_set_source_rgba( cr, 0.7, 0.7, 0.7, 0.5 )
      cairo_move_to( cr, item["x"]-6*#day, item["y"]-8/3 +10 )
      cairo_show_text( cr, day )

      cairo_set_font_size( cr, 16 )
      -- setWeekColor( weekName, 1 )
      cairo_move_to( cr, item["x"]-4*#weekName, item["y"]+8/3*6 +10 )
      cairo_show_text( cr, weekName)
    elseif( i < 3 ) then
      cairo_set_font_size( cr, 16 )
      -- cairo_set_source_rgba( cr, 0, 0, 0, 1 )
      cairo_set_source_rgba( cr, 0.7, 0.7, 0.7, 0.5 )
      cairo_move_to( cr, item["x"]-4*#day, item["y"]-7 + 7 )
      cairo_show_text( cr, day )

      cairo_set_font_size( cr, 12 )
      -- setWeekColor( weekName, 0.3 )
      cairo_move_to( cr, item["x"]-3*#weekName, item["y"]+5 + 7 )
      cairo_show_text( cr, weekName )
    elseif( i > 3 ) then
      cairo_set_font_size( cr, 16 )
      -- cairo_set_source_rgba( cr, 0, 0, 0, 1 )
      -- cairo_set_source_rgba( cr, 0.0, 0.0, 0.0, 0.6 )
      cairo_set_source_rgba( cr, 0.7, 0.7, 0.7, 0.5 )
      cairo_move_to( cr, item["x"]-4*#day, item["y"]-7 + 7 )
      cairo_show_text( cr, day )

      cairo_set_font_size( cr, 12 )
      -- setWeekColor( weekName, 0.6 )
      cairo_move_to( cr, item["x"]-3*#weekName, item["y"]+5 + 7 )
      cairo_show_text( cr, weekName)
    end
    cairo_stroke( cr )
    i = i + 1
  end

  -- year month
  -- cairo_arc( cr, item["x"], item["y"]+10, 10, 0, 2 * math.pi )
  -- cairo_select_font_face( cr, font_logoGothic, font_slant, font_face )
  cairo_select_font_face( cr, font_smartFont, font_slant, font_face )
  cairo_set_font_size( cr, 36 )
  cairo_set_source_rgba( cr, 0.7, 0.7, 0.7, 0.8 )
  -- setWeekColor( weekName, 0.6 )
  local year = command( "LANG=C date '+%Y'" )
  local month = command( "LANG=C date '+%B'" )
  -- local month = command( "LANG=C date '+%B' -d '4 month'" )
  cairo_move_to( cr, calWid-8.5*#year, calHei )
  cairo_show_text( cr, year )

  cairo_move_to( cr, calWid-8.5*#month, calHei+36 )
  cairo_show_text( cr, month )

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

  local updates = tonumber( conky_parse( "${updates}" ) )

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
  if( updates > 5 ) then
    putTime( cr )
    CPUGraph( cr )
    volumeCircleGraph( cr )
    batteryCircleGraph( cr )
    putWeather( cr )
    calendarCircle( cr )
  end
  -- MpdStatus( cr )

  cairo_set_source_rgb( cr, 1, 1, 1 )

  cairo_destroy(cr)
  cairo_surface_destroy(cs)

  cr=nil
end


