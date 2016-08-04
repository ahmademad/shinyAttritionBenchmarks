# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.  Find out more about
# building applications with Shiny here: http://shiny.rstudio.com/
library(ggplot2)
library(shiny)
source("helpers.R")
# Define server logic required to draw a histogram
shinyServer(function(input, output, clientData, session) {
  
  temp <- reactive({
    # We'll use these multiple times, so use short var names for
    # convenience.
    transitionPeriod <- input$transitionPeriod
    if (length(transitionPeriod) == 0) {
      transitionPeriod <- c("1")
    }
    type <- transition(transitionPeriod)
    interType <- input$interType
    temp <- interaction(interType)
    interactionType <- temp[1]
    g1 <- temp[2]
    g2 <- temp[3]
    
    meanings1 <- meaning(g1, type)
    group1 <- unname(meanings1[unique(data[data$interType == interactionType & 
                                             data$period == transitionPeriod, "group1"])])
    meanings2 <- meaning(g2, type)
    updateSelectInput(session, "group1", label = paste(g1, "Characteristic"), 
                      choices = group1)
    return(list(meanings1 = meanings1, meanings2 = meanings2, interactionType = interactionType, 
                transitionPeriod = transitionPeriod))
  })
  
  group2 <- reactive({
    all <- temp()
    meanings1 <- all[["meanings1"]]
    meanings2 <- all[["meanings2"]]
    interactionType <- all["interactionType"]
    transitionPeriod <- all[["transitionPeriod"]]
    gr1 <- names(meanings1)[meanings1 == input$group1]
    group2 <- unname(meanings2[unique(data[data$interType == interactionType & 
                                             data$period == transitionPeriod & data$group1 == gr1, "group2"])])
    updateSelectInput(session, "group2", label = paste(interaction(input$interType)[3], 
                                                       "Characteristic"), choices = group2)
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
    outputData <- data[data$interType == interactionType & data$group1 == 
                         gr1 & data$group2 == gr2 & data$period %in% transitionPeriod, 
                       c("mob1", "mob2", "mob3", "period", "group1", "group2")]
    
    if (nrow(outputData) == 0) {
      return(outputData)
    }
    outputData <- reshape(outputData, varying = c("mob1", "mob2", "mob3"), 
                          v.names = "mob", timevar = "mobType", times = c("mob1", "mob2", 
                                                                          "mob3"), new.row.names = 1:1000, direction = "long")
    outputData <- outputData[, names(outputData) != "id"]
    
    se <- data[data$interType == interactionType & data$group1 == gr1 & 
                 data$group2 == gr2 & data$period %in% transitionPeriod, c("mob1se", 
                                                                           "mob2se", "mob3se", "period", "group1", "group2")]
    se <- reshape(se, varying = c("mob1se", "mob2se", "mob3se"), v.names = "se", 
                  timevar = "mobType", times = c("mob1", "mob2", "mob3"), new.row.names = 1:1000, 
                  direction = "long")
    se <- se[, names(se) != "id"]
    
    outputData <- merge(outputData, se, by = names(outputData)[!names(outputData) %in% 
                                                                 c("mob", "se")])
    if (type == "Elementary") {
      mobType <- c("Any mobility (left baseline school / outside school data)", 
                   "Left the district, state, or public school system (outside district data)", 
                   "Left the state or public school system (outside state data, including dropouts)")
    } else {
      mobType <- c("Any mobility (left baseline school / outside school data)", 
                   "Left baseline school and transferred to another school within the state", 
                   "Left the state or public school system (outside state data, including dropouts)")
    }
    outputData$mobType <- mobType
    outputData$group1[outputData$group1 == gr1] <- input$group1
    outputData$group2[outputData$group2 == gr2] <- input$group2
    outputData
  })
  
  output$plot <- renderPlot({
    data <- outputFunc()
    if (nrow(data) == 0) {
      return("Please make a selection")
    }
    if (dim(data)[1] != 0) {
      data$mobType <- str_wrap(data$mobType)
      data$mob <- round(data$mob * 100, 1)
      data$se <- round(data$se * 100, 2)
      just <- -2
      if (input$seCheck) {
        just <- -3.5
      }
      if (input$transitionPeriod == "1 to 5") {
        gplotYlim <- c(0, 80)
      } else {
        gplotYlim <- c(0, 50)
      }
      data$Label <- paste(data$mob, "%", sep=" ")
      data$Label[data$mob == -9900] <- "Suppressed"
      data$mob[data$mob == -9900] <- 0
      labels <- data$Label
      if (nrow(data) == 3) {
        p1 <- ggplot(data) + geom_bar(aes(x = mobType, y = mob, width=0.7), 
                                      stat = "identity", fill = "#0072B2") + xlab("") + scale_x_discrete(labels = function(x) str_wrap(x, 
                                                                                                                                       width = 21)) + geom_text(aes(x = mobType, y = mob, ymax = mob, 
                                                                                                                                                                    label = labels, vjust = ifelse(sign(mob) > 0, just, 0)), 
                                                                                                                                                                position = position_dodge(width = 2)) + ylim(c(0, max(data$mob) + 
                                                                                                                                                                                                                 5)) + theme(text = element_text(size = 17)) + ylab("Percent of Students") + 
          ylim(gplotYlim)
        
        if (input$seCheck) {
          p1 <- p1 + geom_errorbar(aes(x = mobType, ymax = mob + 
                                         2 * se, ymin = mob - 2 * se), position = "dodge", width = 0.25)
        }
      }
      if (nrow(data) > 3) {
        p1 <- ggplot(data) + geom_bar(aes(x = period, y = mob, 
                                          fill = mobType), stat = "identity")
      }
      return(p1)
    }
    return(NULL)
    
  })
  
  output$mytable = renderDataTable({
    data <- outputFunc()
    data$mob <- round(data$mob * 100, 1)
    data$se <- round(data$se * 100, 2)
    data$mob[data$mob == -9900] <- "Suppressed"
    data$se[data$se == -9900] <- "Suppressed"
    names(data) <- c("Transition Period", "Group 1", "Group 2", "Mobility Type", 
                     "Mobility Value", "Standard Error")
    if (nrow(data) == 0) {
      return("Please make a selection")
    }
    
    data
  })
  
})
