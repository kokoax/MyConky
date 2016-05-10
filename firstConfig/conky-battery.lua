Battery = {}

function batteryCircleDraw ( cr, x, y, size, per )
  local angle1 = -90.0 * ( math.pi/180 )       * 1
  local angle2 = ( 360-90 ) * ( math.pi/180 )  * 1

  -- local dist = angle2 - angle1
  local dist = angle1 - angle2

  -- cairo_arc( cr, win_wid * (3*4), win_hei/2 + 20, size, angle1, angle2 + dist - ( dist * per ) )
  cairo_arc( cr, x, y, size, angle1, angle2 + dist - ( dist * per ) )
  -- cairo_arc( cr, x, y, size, angle1 + dist - ( dist * per ), angle2 )
  cairo_stroke( cr )
end


-- Battery.batteryCircleText = function( cr, x, y, text )
function batteryCircleText ( cr, x, y, text )
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

Battery.batteryCircleGraph = function( cr )
  local xpos = win_wid*(1/5)
  local ypos = win_hei * 0.8

  local size = 80

  local batt_status = tostring( conky_parse( '${battery BAT0}' ) )
  local battPer = tonumber( conky_parse( '${battery_percent BAT0}' ) )
  local per = battPer * 1/100

  cairo_set_source_rgba( cr, 0.4, 0.4, 0.4, 0.1 )
  cairo_set_line_width( cr, 5 )
  batteryCircleDraw( cr, xpos, ypos, size, 1 )
  cairo_stroke( cr )
  cairo_set_source_rgba( cr, 0.1, 0.8, 0.3, 0.1 )
  cairo_set_line_width( cr, 10 )

  batteryCircleDraw( cr, xpos, ypos, size*(6/7), per )
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

Battery.batteryGraph = function( cr )
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

return Battery

