Calendar = {}

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

Calendar.calendarCircle = function( cr )
  local i = 0
  local today_last  = Archive.command( "LC_ALL=C date +'%d' -d \"1 days ago `date +%Y%m01 -d '+1 month'`\"" )
  local before_last = Archive.command( "LC_ALL=C date +'%d' -d \"2 days ago `date +%Y%m01 -d '+1 month'`\"" )

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
    local weekName= tostring( Archive.command( "LC_ALL=C date +'%a' -d '" .. tostring( i - 3 ) .. " days'" ) )
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
    local day = tostring( tonumber( tostring( Archive.command( "LC_ALL=C date +'%d' -d '" .. tostring( i - 3 ) .. " days'" ) ) ) )
    local weekName= tostring( Archive.command( "LC_ALL=C date +'%a' -d '" .. tostring( i - 3 ) .. " days'" ) )

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
  local year = Archive.command( "LC_ALL=C date '+%Y'" )
  local month = Archive.command( "LC_ALL=C date '+%B'" )
  -- local month = Archive.command( "LC_ALL=C date '+%B' -d '4 month'" )
  cairo_move_to( cr, calWid-8.5*#year, calHei )
  cairo_show_text( cr, year )

  cairo_move_to( cr, calWid-8.5*#month, calHei+36 )
  cairo_show_text( cr, month )

  cairo_stroke( cr )

end

return Calendar

