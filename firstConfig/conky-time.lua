Time = {}

-- つかってない   ど真ん中に時間を表示する
Time.bigTime = function( cr )
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

-- 現在使ってるほう 真ん中の上の方に時間を表示する
Time.putTime = function( cr )
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

return Time

