#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(leaflet)
library(mapedit)
library(leafpm)
library(sf)

# Define UI for application that draws a histogram
ui <- fluidPage(

  titlePanel("Shinylive Leaflet Mapedit"),
  
  sidebarLayout(
    position = "right",
    sidebarPanel(actionButton('calc_xs', 'Calculate XS')),
    mainPanel(editModUI(id = "xs", 
                        height = "90vh"))
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  # Create the map  
  map <- leaflet() %>%
    addTiles() %>%
    setView(lng = -93.85, lat = 37.45, zoom = 4)
  
  draw_xs <- callModule(mapedit::editMod,
                        id = "xs",
                        leafmap = map,
                        editor = "leafpm",
                        editorOptions = list(
                          toolbarOptions = pmToolbarOptions(
                            drawMarker = FALSE,
                            drawPolygon = FALSE,
                            drawCircle = FALSE,
                            drawRectangle = FALSE,
                            cutPolygon = FALSE,
                            position = "topright")
                        ))
  
  observeEvent(input$calc_xs, {
    xs <- draw_xs()$finished
    assign('xs', xs, envir = .GlobalEnv)
    #sf::write_sf(xs, 'xs.geojson', delete_layer = TRUE, delete_dsn = TRUE)
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
