library(shiny)
library(ggplot2)

ui <- page_sidebar(
  title = "Penguins dashboard",
  sidebar = color_by,
  theme = bs_theme(
    
    bootswatch = "darkly",
    base_font = font_google("Inter"),
    navbar_bg = "#25443B"
  ),
  !!!cards
)

# Enable thematic
thematic::thematic_shiny(font = "auto")

# Change ggplot2's default "gray" theme
theme_set(theme_bw(base_size = 16))

# New server logic (removes the `+ theme_bw()` part)
server <- function(input, output) {
  gg_plot <- reactive({
    ggplot(penguins) +
      geom_density(aes(fill = !!input$color_by), alpha = 0.2) +
      theme(axis.title = element_blank())
  })
  
  output$bill_length <- renderPlot(gg_plot() + aes(bill_length_mm))
  output$bill_depth <- renderPlot(gg_plot() + aes(bill_depth_mm))
  output$body_mass <- renderPlot(gg_plot() + aes(body_mass_g))
}

shinyApp(ui, server)