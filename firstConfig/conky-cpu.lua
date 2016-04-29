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

