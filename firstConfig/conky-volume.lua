Volume = {}

function volumeCircleDraw ( cr, x, y, size, per )
  local angle1 = -90.0 * ( math.pi/180 )
  local angle2 = ( 360-90 ) * ( math.pi/180 )

  -- local dist = angle1 - angle2
  local dist = angle2 - angle1

  -- cairo_arc( cr, win_wid * (3*4), win_hei/2 + 20, size, angle1, angle2 + dist - ( dist * per ) )
  cairo_arc( cr, x, y, size, angle1 + dist - ( dist * per ), angle2 )
  -- cairo_arc( cr, x, y, size, angle1, angle2 + dist - ( dist * per ) )
  cairo_stroke( cr )
end

function volumeCircleText( cr, x, y, text )
  text = text.."%"
  local afterText = "VOLUME"

  cairo_select_font_face( cr, font_adam, font_slant, font_face )
  -- cairo_select_font_face( cr, font_logos, font_slant, font_face )

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

-- function volumeCircleGraph( cr )
Volume.volumeCircleGraph = function( cr )
  local xpos = win_wid*(4/5)
  local ypos = win_hei * 0.8

  local vol = tostring( conky_parse( '${exec amixer -c 0 get Master | grep Mono: | cut -d " " -f6}' ) )
  vol = tonumber( string.match( vol, "([%d]+)" ) )
  local per = vol * 1/100
  local size = 80

  cairo_set_source_rgba( cr, 0.4, 0.4, 0.4, 0.1 )
  cairo_set_line_width( cr, 5 )
  volumeCircleDraw( cr, xpos, ypos, size, 1 )

  cairo_set_source_rgba( cr, 0.6, 0.6, 0, 0.2 )
  cairo_set_line_width( cr, 10 )
  volumeCircleDraw( cr, xpos, ypos, size*(6/7), per )

  cairo_set_source_rgba( cr, 0.6, 0.6, 0, 0.2 )
  cairo_set_line_width( cr, 1 )

  cairo_move_to( cr, xpos, ypos - 80 - 5 )
  cairo_line_to( cr, xpos, ypos - 80 - 60 )
  cairo_line_to( cr, win_wid, ypos - 80 - 60 )

  cairo_stroke( cr )

  volumeCircleText( cr, xpos + size/2, ypos - 80 - 60 + 40, vol )

end

-- function volumeGraph( cr )
Volume.volumeGraph = function( cr )
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

return Volume

