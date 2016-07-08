#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
source("helpers.R")
# Define server logic required to draw a histogram
shinyServer(function(input, output, clientData, session) {
  
  observe({
    # We'll use these multiple times, so use short var names for
    # convenience.
    transitionPeriod <- input$transitionPeriod
    if(transitionPeriod %in%  c("10 to 12", "9 to 11")) {
      transitionPeriod <- "High School"
    }
    else {
      transitionPeriod <- "Elementary"
    }
    overall <-  unique(description$Meaning[description$Level == "Overall" & description$Type == transitionPeriod])
    # Text =====================================================
    # Change both the label and the text
    updateSelectizeInput(session, "interType",
                    choices = overall)
  })
  
})
