#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(stringr)
library(shiny)
source("helpers.R")

shinyUI(fluidPage(
  title = 'Attrition Benchmark Choices',
  sidebarLayout(
    sidebarPanel(
      selectInput(
        'transitionPeriod', 'Select Transition Period', choices = transitions,
        selectize = FALSE, selected = "K to 1"
      ),
      selectInput(
        'interType', 'Select Interaction Type',
        choices = c("school-by-student interaction", "school-by-school interaction", "student-by-student interaction"),
        selectize = FALSE, selected = "school-by-student interaction"
      ),
      selectInput(
        'group1', 'Group 1', choices = "", selectize = FALSE
      ),
      selectInput(
        'group2', 'Group 2', choices = "",selectize = FALSE
        
      )
     
          ),
    mainPanel(
      plotOutput("plot"),
      tabPanel('data',
               dataTableOutput("mytable"))
    )
    
      )
      )
)