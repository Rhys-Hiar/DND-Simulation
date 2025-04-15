library(shiny)

ui <- fluidPage(
  titlePanel("Hello, Shiny!"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("num", "Choose a number:", 1, 100, 50)
    ),
    mainPanel(
      textOutput("text")
    )
  )
)

server <- function(input, output) {
  output$text <- renderText({
    paste("You selected", input$num)
  })
}

shinyApp(ui = ui, server = server, options = list(host = "0.0.0.0", port = 3838))
