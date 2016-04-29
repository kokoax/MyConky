function putWeather( cr )
  local image = cairo_image_surface_create_from_png( "~/.WeatherIcon/png/02.png" );

  widImage = cairo_image_surface_get_width( image )
  heiImage = cairo_image_surface_get_height( image )

  cairo_scale( cr, 256.0/widImage, 256.0/heiImage )

  cairo_set_source_surface( cr, image, 40, 40 )
  cairo_paint( cr )
  cairo_surface_destroy( image )
end


