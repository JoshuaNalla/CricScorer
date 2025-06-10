#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(DT)
# Define UI for application that draws a histogram
fluidPage(

  titlePanel("CricScorer"),
  sidebarLayout(
    sidebarPanel(
      # Input fields for new data
      fluidRow(
        column(6, numericInput("num1", "Over", value = 1, min = 1, max = 100)),
        column(6, numericInput("num2", "Ball", value = 1, min = 1, max = 6))
      ),
      selectInput("bat", "On Strike", choices = c("Adi", "Aravind", "Josh", "Pranay", "Dheeraj", "Caleb", "Suhas", "Lucky", "Chinnu", "Yatish", "Anish", "Ani")),
      selectInput("off", "Off Strike", choices = c("Adi", "Aravind", "Josh", "Pranay", "Dheeraj", "Caleb", "Suhas", "Lucky", "Chinnu", "Yatish", "Anish", "Ani", "")),
      selectInput("bwlr", "Bowler", choices = c("Adi", "Aravind", "Josh", "Pranay", "Dheeraj", "Caleb", "Suhas", "Lucky", "Chinnu", "Yatish", "Anish", "Ani")),
      fluidRow(
        column(6, checkboxGroupInput("extras",
                         label = "Extras:",
                         choices = c("Wide" = "W",
                                     "No Ball" = "NB",
                                     "Free Hit" = "FH",
                                     "Leg Bye" = "LB"))),
        column(6, checkboxGroupInput("wckts",
                         label = "Wickets",
                         choices = c("Caught (WK)" = "WCT",
                                     "Caught" = "CT",
                                     "Bowled" = "BWL",
                                     "Dropped" = "D")))
      ),
      selectInput("result", "Runs Scored", choices = c(0, 1, 2, 3, 4, 5, 6)),
      
      div(
        actionButton("newBall", "Next Ball", class = "btn-primary"),
        style = "margin-bottom: 15px;"  # Space below
      ),
      div(
        actionButton("nxtInn", "Next Innings", class = "btn-primary"),
        style = "margin-bottom: 15px;"  # Space below
      ),
      div(
        actionButton("newGame", "New Game", class = "btn-danger"),
        style = "margin-bottom: 15px;"  # Space below
      ),
      downloadButton("downloadBtn", "Download Match Data", class = "btn-success") 
    ),
    mainPanel(
      #Display the score
      tags$h3(textOutput("score")),
      # Display the table
      DTOutput("mytable")
    )
  )
)