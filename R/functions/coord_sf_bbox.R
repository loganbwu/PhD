#' Supply output from st_bbox() to apply to the current map
coord_sf_bbox = function(sf, buffer=0, ...) {
  if (buffer != 0) {
    sf = st_buffer(sf, buffer)
  }
  bbox = st_bbox(sf)
  coord_sf(xlim = c(bbox$xmin, bbox$xmax), ylim = c(bbox$ymin, bbox$ymax), ...)
}