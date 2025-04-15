library(shiny)
library(bslib)
library(ggplot2)
library(colourpicker)
library(shinyFiles)
library(shinycssloaders)

spell_list_ui <- fluidPage(
  titlePanel("Multi-CSV Viewer"),
  sidebarLayout(
    sidebarPanel(
      fileInput(
        "csv_files", 
        "Upload CSV Files", 
        multiple = TRUE, 
        accept = ".csv"
      ),
      shinyDirButton(
        "folder", 
        "Select Folder", 
        "Choose a folder containing CSV files"
      )
    ),
    mainPanel(
      tabsetPanel(
        id = "csv_tabs",
        type = "tabs"
      ),
      style = "position: absolute; bottom: 0; right: 0; left: 20; height: 50%; overflow: auto;"
    )
  )
)

spell_list_server <- function(input, output, session) {
  shinyDirChoose(
    input, 
    "folder", 
    roots = c(home = "~"), 
    filetypes = c("csv")
  )
  
  observeEvent(input$folder, {
    req(input$folder)
    folder_path <- parseDirPath(c(home = "~"), input$folder)
    csv_files <- list.files(folder_path, pattern = "\\.csv$", full.names = TRUE)
    
    # Remove previous tabs if new files are uploaded
    removeUI(selector = "#csv_tabs .tab-content .tab-pane")
    removeUI(selector = "#csv_tabs .nav-tabs .nav-item")
    
    for (i in seq_along(csv_files)) {
      file_name <- basename(csv_files[i])
      file_path <- csv_files[i]
      
      # Dynamically add a tab for each file
      appendTab(
        inputId = "csv_tabs",
        tabPanel(
          title = file_name,
          dataTableOutput(outputId = paste0("table", i))
        )
      )
      
      # Render data table for each file
      local({
        file_index <- i
        output[[paste0("table", file_index)]] <- renderDataTable({
          read.csv(file_path)
        })
      })
    }
  })
  
  observeEvent(input$csv_files, {
    req(input$csv_files)
    
    # Remove previous tabs if new files are uploaded
    removeUI(selector = "#csv_tabs .tab-content .tab-pane")
    removeUI(selector = "#csv_tabs .nav-tabs .nav-item")
    
    for (i in seq_along(input$csv_files$name)) {
      file_name <- input$csv_files$name[i]
      file_path <- input$csv_files$datapath[i]
      
      # Dynamically add a tab for each uploaded file
      appendTab(
        inputId = "csv_tabs",
        tabPanel(
          title = file_name,
          dataTableOutput(outputId = paste0("table", i))
        )
      )
      
      # Render data table for each file
      local({
        file_index <- i
        output[[paste0("table", file_index)]] <- renderDataTable({
          read.csv(file_path)
        })
      })
    }
  })
}

shinyApp(ui, server)
