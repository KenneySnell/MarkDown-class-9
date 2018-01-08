#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
# - Predict Old Faithful Eruption duration
library(shiny)
shinyUI(fluidPage(
  titlePanel("Predict Duration (min) of next Old Faithful Eruption"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("sliderDUR", "What is the wait time of the last eruption?", 47, 91, value = 80),
      checkboxInput("showModel1", "Show/Hide Model 1", value = TRUE),
      checkboxInput("showModel2", "Show/Hide Model 2", value = TRUE),
      submitButton("Submit") # new
    ),
    mainPanel(
      plotOutput("plot1"),
      h4("Predicted Duration (min) from LM - Mode 1:"),
      textOutput("pred1"),
      h4("Predicted Duration (min) from ML - Model 2:"),
      textOutput("pred2")
    )
  )
))

