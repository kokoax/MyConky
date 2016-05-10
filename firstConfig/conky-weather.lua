Weather = {}

function weatherDiscliption( cr, x, y, day )
  local Discription = tostring( Archive.command( "~/scripts/weatherScripts/weather -"..day.." -c" ) )
  local LargeTemp = Archive.command( "~/scripts/weatherScripts/weather -"..day.." -lt" )
  local SmallTemp = Archive.command( "~/scripts/weatherScripts/weather -"..day.." -st" )

  local localYear, localMonth, localDay = string.match( Archive.command( "~/scripts/weatherScripts/weather -"..day.." -day" ), "(%d%d%d%d)(%d%d)(%d%d)" )

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

-- function putWeather( cr )
Weather.putWeather = function( cr )
  local image_today = cairo_image_surface_create_from_png( "~/scripts/weatherScripts/.WeatherIcon/png/64/"..Archive.command( "~/scripts/weatherScripts/weather -0 -i" )..".png" )
  local image_tomorrow = cairo_image_surface_create_from_png( "~/scripts/weatherScripts/.WeatherIcon/png/64/"..Archive.command( "~/scripts/weatherScripts/weather -1 -i" )..".png" )
  local image_day_after = cairo_image_surface_create_from_png( "~/scripts/weatherScripts/.WeatherIcon/png/64/"..Archive.command( "~/scripts/weatherScripts/weather -2 -i" )..".png" )

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

return Weather

