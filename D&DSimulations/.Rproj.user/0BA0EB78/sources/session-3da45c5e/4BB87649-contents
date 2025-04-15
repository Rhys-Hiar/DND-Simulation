library(shiny)
library(bslib)
library(ggplot2)
library(colourpicker)
library(shinyFiles)
library(shinycssloaders)

# Define UI for random distribution app ----
ui <- page_navbar(
  title = "My App",
  bg = "#2D89C8",
  inverse = TRUE,
  
##Sourcing scripts for UI## WILL BE IMPLEMENTED MAYBE SOON IT SEEMS LIKE A LOTTA WORK SORRY -DRUNK & HIGH RHYS
#source("Spell List Viewer Test.R", local = TRUE),
#source("UIimptest.R", local = TRUE),
  ####################NAV#PANEL#ONE###################################
  nav_panel(
    title = "Dice Roll Simulator",
    h3("Dice Roll Simulator"),
    sidebarLayout(
      sidebarPanel(
        selectInput(
          "dice_type", 
          label = "Select Dice Type:", 
          choices = c("d4" = 4, "d6" = 6, "d8" = 8, "d10" = 10, "d12" = 12, "d20" = 20), 
          selected = 6
        ),
        numericInput(
          "num_dice", 
          label = "Number of Dice to Roll:", 
          value = 10, 
          min = 1
        ),
        actionButton("roll_button", "Roll the Dice"),
        h4("Customize Colors:"),
        uiOutput("color_inputs")
      ),
      mainPanel(
        h3("Result:"),
        withSpinner(textOutput("dice_roll"), type = 6),
        h3("Roll Distribution:"),
        withSpinner(plotOutput("dice_histogram"), type = 6)
      )
    )
  ),
  ##################--END--#NAV#PANEL#ONE#--END--#####################
  
  ####################NAV#PANEL#TWO###################################
  nav_panel(
    title = "Random Encounter Tables",
    h3("Random Encounter Tables"),
    sidebarLayout(
      sidebarPanel(
        fileInput("file", "Upload CSV", accept = ".csv"),
        actionButton("roll_encounter", "Roll the Encounter"),
        br(),
        br(),
        verbatimTextOutput("result")
      ),
      mainPanel(
        h3("Result:"),
        verbatimTextOutput("result")
      )
  ),
),
  ##################--END--#NAV#PANEL#TWO#--END--#####################
  
  ####################NAV#PANEL#THREE###################################
  nav_panel(
    title = "Spell List Viewer", 
    h3("Spell List Viewer"),
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
    ),
  ##################--END--#NAV#PANEL#THREE#--END--####################
  nav_spacer(),
  nav_menu(
    title = "Links",
    align = "right",
    nav_item(tags$a("Posit", href = "https://posit.co")),
    nav_item(tags$a("Shiny", href = "https://shiny.posit.co"))
  )
)

# Define server logic ----
server <- function(input, output) {
  # Reactive value to store rolls
  rolls <- reactiveValues(results = NULL)
  
  # Generate dynamic UI for color inputs
  output$color_inputs <- renderUI({
    dice_type <- as.numeric(input$dice_type)
    lapply(1:dice_type, function(i) {
      colourInput(paste0("color_", i), paste("Color for ", i, ":"), value = sample(colors(), 1))
    })
  })
  
  # Handle dice roll
  observeEvent(input$roll_button, {
    dice_type <- as.numeric(input$dice_type)
    num_dice <- input$num_dice
    rolls$results <- sample(1:dice_type, num_dice, replace = TRUE) # Store results in reactiveValues
    
    output$dice_roll <- renderText({
      paste("You rolled:", paste(rolls$results, collapse = ", "), 
            "\nTotal:", sum(rolls$results))
    })
  })
  
  # Render histogram
  output$dice_histogram <- renderPlot({
    if (is.null(rolls$results)) return(NULL)
    
    dice_type <- as.numeric(input$dice_type)
    
    # Generate color mapping
    face_colors <- sapply(1:dice_type, function(i) {
      input[[paste0("color_", i)]]
    })
    
    ggplot(data.frame(Roll = rolls$results), aes(x = factor(Roll))) +
      geom_bar(stat = "count", aes(fill = factor(Roll))) +
      scale_fill_manual(values = face_colors) +
      labs(x = "Dice Face", y = "Frequency") +
      theme_minimal() +
      theme(legend.position = "none")
  })
  
  
  ##############CODE FOR RANDOM ENCOUNTERS
  # Function to roll a number and find the matching result
  roll_and_find <- function(chart) {
    # Roll a random number from 1 to 100
    roll <- sample(1:100, 1)
    
    # Find the matching row
    matching_row <- chart[sapply(chart$DiceRoll, function(range) {
      # Parse the range
      bounds <- as.numeric(unlist(strsplit(range, "-")))
      # Check if roll is within the range
      roll >= bounds[1] && roll <= bounds[2]
    }), ]
    
    # Return result message
    if (nrow(matching_row) == 1) {
      paste("You rolled", roll, ", the result is", matching_row$CreatureType, "!")
    } else {
      paste("No match found for roll", roll, "!")
    }
  }
  
  # Observe file upload and update chart data
  observeEvent(input$csv_file, {
    req(input$csv_file)
    # Read the uploaded CSV file
    new_data <- read.csv(input$csv_file$datapath, stringsAsFactors = FALSE)
    # Validate column structure
    if (all(c("DiceRoll", "CreatureType") %in% colnames(new_data))) {
      chart_data(new_data)
    } else {
      showNotification("Invalid file structure. Ensure columns are 'DiceRoll' and 'CreatureType'.", type = "error")
    }
  })
  
  # Action button for dice roll
  observeEvent(input$roll_encounter, {
    req(chart_data())
    output$result <- renderText({
      roll_and_find(chart_data())
    })
    # Display the current chart
    output$table_preview <- renderTable({
      chart_data()
    })
  })  
  #####END#CODE#FOR#RANDOM#ENCOUNTERS###################################
  
  ####################CODE FOR SPELL LIST###################################
  
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
  ################END CODE FOR SPELL LIST###################################
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
