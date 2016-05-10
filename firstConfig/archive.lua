Archive = {}

Archive.command = function( cmd )
  local handle = io.popen( cmd )
  local content = handle:read( "*all" )
  handle:close()
  return string.gsub( content, "\n", "" )
end


Archive.putSideBar = function( cr, BarX, per )
  local barWid = 70 * perWidth

  local BarTop    = win_hei*0.2
  local BarBottom = win_hei - win_hei*0.1
  local BarLen = BarBottom - BarTop

  cairo_set_line_width( cr, barWid )

  cairo_move_to( cr, BarX, BarBottom )
  cairo_line_to( cr, BarX, BarBottom - ( BarLen * per ) )
  cairo_stroke( cr )
end

Archive.SideBarText = function( cr, volBarX, text )
  local BarBottom = win_hei - win_hei*0.1

  cairo_select_font_face( cr, font_takao, font_slant, font_face )

  cairo_set_source_rgb( cr, 1, 1, 1 )
  cairo_move_to( cr, volBarX - (#text)*4, BarBottom + 25 * perWidth )
  -- cairo_move_to( cr, volBarX - (#text)*4, BarBottom )
  cairo_set_font_size( cr, 16 )
  cairo_show_text( cr, text )
  cairo_stroke( cr )
end

return Archive

