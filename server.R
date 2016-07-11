#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(ggplot2)
library(shiny)
source("helpers.R")
# Define server logic required to draw a histogram
shinyServer(function(input, output, clientData, session) {
  
  
  
  
  temp <- reactive({
    # We'll use these multiple times, so use short var names for
    # convenience.
    transitionPeriod <- input$transitionPeriod
    type <- transition(transitionPeriod)
    interType <- input$interType
    temp <- interaction(interType)
    
    interactionType <- temp[1]
    g1 <- temp[2]
    g2 <- temp[3]
    
    meanings1 <- meaning(g1, type)
    group1 <- unname(meanings1[unique(data[data$interType == interactionType & data$period ==transitionPeriod,"group1"])])
    meanings2 <- meaning(g2, type)
    updateSelectInput(session, "group1", label = paste(g1, "Characteristic"),
                      choices = group1)
    return(list("meanings1" = meanings1, "meanings2" = meanings2, 
                "interactionType" = interactionType,
                "transitionPeriod" = transitionPeriod))
      })
  
  group2 <- reactive({
  all <- temp()
  meanings1 <- all[["meanings1"]]
  meanings2 <- all[["meanings2"]]
  interactionType <- all["interactionType"]
  transitionPeriod <- all[["transitionPeriod"]]
  gr1 <- names(meanings1)[meanings1 == input$group1]
  group2 <- unname(meanings2[unique(data[data$interType == interactionType &
                                           data$period ==transitionPeriod & 
                                           data$group1 ==gr1,"group2"])])
  updateSelectInput(session, "group2", label= paste(interaction(input$interType)[3], "Characteristic"), 
                    choices = group2)
  return(all)
  })

  outputFunc <- reactive({
    all <- group2()
    meanings1 <- all[["meanings1"]]
    meanings2 <- all[["meanings2"]]
    interactionType <- all["interactionType"]
    transitionPeriod <- all[["transitionPeriod"]]
    type <- transition(transitionPeriod)
    gr1 <- names(meanings1)[meanings1 == input$group1]
    gr2 <- names(meanings2)[meanings2 == input$group2]
    outputData <- data[data$interType == interactionType & data$group1 == gr1 & data$group2 == gr2 & data$period==transitionPeriod,
                       c("mob1", "mob2", "mob3", "mob1se", "mob2se", 'mob3se')]
    mob <- c()
    se <- c()
    mobType <- c()
    period <- c()
    interType <- c()
    Group1 <- c()
    Group2 <-c()
    outputD <- data.frame(mob, se, mobType, period, interType, Group1, Group2)
    if(dim(outputData)[1] != 0) {
      mob <- c(outputData$mob1, outputData$mob2, outputData$mob3)
      se <- c(outputData$mob1se, outputData$mob2se, outputData$mob3se)
      period <- rep(input$transitionPeriod,3)
      interType <- rep(input$interType, 3)
      Group1 <- rep(input$group1, 3)
      Group2 <- rep(input$group2, 3)
      if(type == "Elementary") {
        mobType <- c("Any mobility (left baseline school / outside school data)",
                     "Left the district, state, or public school system (outside district data)", 
                     "Left the state or public school system (outside state data, including dropouts)")
      }
      else {
        mobType <- c("Any mobility (left baseline school / outside school data)",
                     "Left the district, state, or public school system (outside district data)", 
                     "Left the state or public school system (outside state data, including dropouts)")
      }
      outputD <- data.frame(mob, se, mobType, period, interType, Group1, Group2)

    }
    outputD
  })

  output$plot <- renderPlot({
    data <- outputFunc()
    if(dim(data)[1] != 0) {
      data$mobType <- str_wrap(data$mobType)
      p1 <- ggplot(data) + geom_bar(aes(x=mobType, y= mob), stat="identity", fill="#9ad0f3") +
        xlab("") +
        geom_errorbar(aes(x=mobType,ymax = mob + se, ymin = mob - se), position = "dodge", width = 0.25) +
        scale_x_discrete(labels = function(x) str_wrap(x, width = 21)) +
        scale_color_manual(values=c("#9ad0f3"))
      return(p1)
    }
   return(NULL)
          
   })
  
  output$mytable = renderDataTable({
    outputFunc()
  })
})
