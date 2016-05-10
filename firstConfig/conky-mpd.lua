MPD = {}

MPD.MpdArtist = function( cr )
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

return MPD

