library(shiny)

ui <- fluidPage(
  
  
  titlePanel("RPG Shop"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload CSV", accept = ".csv"),
      numericInput("numItems", "Number of Items", value = 1, min = 1),
      actionButton("selectBtn", "Select Random Items")
    ),
    
    mainPanel(
      tableOutput("itemTable")
    )
  )
)

server <- function(input, output) {
  
  # Reactive expression to read the CSV
  data <- reactive({
    req(input$file)
    read.csv(input$file$datapath)
  })
  
  # Observe event for the button to select random items
  observeEvent(input$selectBtn, {
    req(data())
    n <- input$numItems
    selected_items <- data()[sample(nrow(data()), n), ]
    
    # Output the selected items
    output$itemTable <- renderTable({
      selected_items[, c(1, 2, 3, 4)]  # Columns: Item, DEF, Price, Currency
    })
  })
 
}

shinyApp(ui = ui, server = server)
a