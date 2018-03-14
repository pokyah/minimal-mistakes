# load the required librairies
library(raster)
library(rgdal)
library(dplyr)
library(leaflet)
library(htmlwidgets)

# Create the list of all existing coordiante refence systems (more about projected data and coordinate reference systems : https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/OverviewCoordinateReferenceSystems.pdf)
crs_data.df = rgdal::make_EPSG()

# Get the DEM data of belgium as a raster layer
bel_ele.ras = getData("alt", country = "BE", mask = TRUE)

# Let's make the data projected 
bel_ele_proj.ras <- projectRaster(bel_ele.ras, crs = toString((filter(crs_data.df, code=="3812"))$prj4))
rm(bel_ele.ras)

# create a color palette for the legend
pal <- colorNumeric(
  palette = "Reds",
  domain = values(bel_ele_proj.ras),
  na.color = "transparent")

# As R leaflet does not export mobile ready map, we need an HTML tag to make the map mobile friendly. We store it as a character variable
mobile_html_tag.chr = "\'<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\'"

# let's construct the leaflet map with the following features : 
# - default basemap = stamen toner + alternative basemap = satellite imagery
# - menu for selecting layers to display
# - menu to change the basemap
# - display the rain radar data provided by the KNMI WMS
# - button to find your location 
# - https://stackoverflow.com/questions/46575204/leaflet-custom-bin-legend-for-raster

demo.map <- leaflet() %>% 
  addProviderTiles(group = "Stamen",
                   providers$Stamen.Toner,
                   options = providerTileOptions(opacity = 0.25)
  ) %>% 
  addProviderTiles(group = "Satellite",
                   providers$Esri.WorldImagery,
                   options = providerTileOptions(opacity = 1)
  ) %>% 
  addRasterImage(group = "DEM",
                 bel_ele_proj.ras, 
                 color = pal,
                 opacity = 0.8
  ) %>%
  addLegend("bottomright",
            pal = pal,
            values = values(bel_ele_proj.ras),
            title = "Elevation"
  ) %>%
  addWMSTiles(group="KNMI rain radar", 
              baseUrl="https://geoservices.knmi.nl/cgi-bin/RADNL_OPER_R___25PCPRR_L3.cgi",
              layers = "RADNL_OPER_R___25PCPRR_L3_COLOR",
              options = WMSTileOptions(format = "image/png", transparent = TRUE, opacity=0.5),
              attribution= "Rain Data : <a href='http://adaguc.knmi.nl/contents/webservices/WebServices_RADNL_OPER_R___25PCPRR_L3.html'>KNMI</a>"
  ) %>%
  addLayersControl(baseGroups = c("Stamen", "Satellite"),
                   overlayGroups = c("KNMI rain radar", "DEM"),
                   options = layersControlOptions(collapsed = TRUE)
  ) %>%
  addEasyButton(easyButton(
    icon="fa-crosshairs", title="Locate Me",
    onClick=JS("function(btn, map){ map.locate({setView: true}); }"))) %>%
  htmlwidgets::onRender(paste0("
    function(el, x) {
      $('head').append(",mobile_html_tag.chr,");
    }"))

# Export this map object as an HTML webpage
saveWidget(widget=demo.map,
           file= ("./demo-map.html"),
           selfcontained = FALSE
           )
