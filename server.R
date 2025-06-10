#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(DT)
# Define server logic required to draw a histogram
function(input, output, session) {
    # Initialize reactive values to store match data
    rv <- reactiveValues(
      match_data = data.frame(
        Innings = numeric(),
        Over = numeric(),
        Ball = numeric(),
        Batter = character(),
        NonStriker = character(),
        Bowler = character(),
        Runs = numeric(),
        Extras = character(),
        Wicket = character(),
        stringsAsFactors = FALSE
      ),
      current_innings = 1,
      total_runs = 0,
      wickets = 0,
      overs_completed = 0
    )
    
    # Observe "Next Ball" button
    observeEvent(input$newBall, {
      # Validate inputs
      if (is.na(input$num1)) {
        showNotification("Please enter a valid over number", type = "error")
        return()
      }
      
      # Create new row with ball data
      new_row <- data.frame(
        Innings = rv$current_innings,
        Over = input$num1,
        Ball = input$num2,
        Batter = input$bat,
        NonStriker = input$off,
        Bowler = input$bwlr,
        Runs = as.numeric(input$result),
        Extras = ifelse(length(input$extras) > 0, paste(input$extras, collapse = ","), NA),
        Wicket = ifelse(length(input$wckts) > 0, paste(input$wckts, collapse = ","), NA),
        stringsAsFactors = FALSE
      )
      
      # Add to match data
      rv$match_data <- rbind(rv$match_data, new_row)
      
      # Update match statistics
      rv$total_runs <- rv$total_runs + as.numeric(input$result)
      if (length(input$wckts) > 0) rv$wickets <- rv$wickets + 1
      if (input$num2 == 6) rv$overs_completed <- rv$overs_completed + 1
      
      # Reset ball input for next entry
      updateNumericInput(session, "num2", value = ifelse(input$num2 == 6, 1, input$num2 + 1))
      if (input$num2 == 6) {
        updateNumericInput(session, "num1", value = input$num1 + 1)
      }
    })
      
      # Observe "Next Innings" button
      observeEvent(input$nxtInn, {
        rv$current_innings <- rv$current_innings + 1
        rv$total_runs <- 0
        rv$wickets <- 0
        rv$overs_completed <- 0
        
        # Reset inputs
        updateNumericInput(session, "num1", value = 1)
        updateNumericInput(session, "num2", value = 1)
        showNotification(paste("Innings", rv$current_innings, "started"), type = "message")
      })
      
      # Proper CSV download handler
      output$downloadBtn <- downloadHandler(
        filename = function() {
          paste("cricket_match_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".csv", sep = "")
        },
        content = function(file) {
          # Ensure we have data to download
          req(nrow(rv$match_data) > 0)
          
          # Write CSV with proper formatting
          write.csv(rv$match_data, file, row.names = FALSE, na = "")
        }
      )
      
      # Observe "New Game" button
      observeEvent(input$newGame, {
        
        rv$match_data <- data.frame(
          Innings = numeric(),
          Over = numeric(),
          Ball = numeric(),
          Batter = character(),
          NonStriker = character(),
          Bowler = character(),
          Runs = numeric(),
          Extras = character(),
          Wicket = character(),
          stringsAsFactors = FALSE
        )
        rv$current_innings <- 1
        rv$total_runs <- 0
        rv$wickets <- 0
        rv$overs_completed <- 0
        
        # Reset all inputs
        updateNumericInput(session, "num1", value = 1)
        updateNumericInput(session, "num2", value = 1)
        updateSelectInput(session, "bat", selected = "Adi")
        updateSelectInput(session, "off", selected = "Aravind")
        updateSelectInput(session, "bwlr", selected = "Josh")
        updateCheckboxGroupInput(session, "extras", selected = character(0))
        updateCheckboxGroupInput(session, "wckts", selected = character(0))
        updateSelectInput(session, "result", selected = 0)
        
        showNotification("New match started", type = "message")
      })
      
      # Display current score
      output$score <- renderText({
        paste("Innings:", rv$current_innings,
              "| Runs:", rv$total_runs,
              "| Wickets:", rv$wickets,
              "| Overs:", rv$overs_completed)
      })
      
      # Display the match data table with most recent first
      output$mytable <- renderDT({
        # Reverse the order of rows to show newest first
        reversed_data <- rv$match_data[rev(seq_len(nrow(rv$match_data))), ]
        
        datatable(
          reversed_data,
          options = list(
            pageLength = 10,
            scrollX = TRUE,
            autoWidth = TRUE,
            ordering = FALSE,  # Disable sorting to maintain our manual order
            dom = 'tip'
          ),
          rownames = FALSE,
          class = 'cell-border stripe'
        ) %>%
          formatStyle(columns = c(0:8), fontSize = '14px')
      })
  }
  