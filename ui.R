# This is the user-interface definition of a Shiny web application. You
# can run the application by clicking 'Run App' above.  Find out more
# about building applications with Shiny here:
# http://shiny.rstudio.com/
library(stringr)
library(shiny)
source("helpers.R")

shinyUI(fluidPage(titlePanel("", windowTitle = "SALT"), navbarPage(title = div(img(src = "AIR.png", id = "img1"), "", id = "title1"), 
                   theme = "style.css", tabPanel("Main Page", h3("STUDENT ATTRITION LOOKUP TOOL (SALT)"), 
                                                 h3("Introduction"), p("This site provides empirical estimates of student mobility rates to 
                                                                       help researchers plan for student attrition when conducting studies 
                                                                       in U.S. public schools. Student-level, school-based longitudinal 
                                                                       evaluations often encounter study attrition when students move away 
                                                                       from, or drop out of, study schools. In some cases, this 
                                                                       mobility-induced attrition simply decreases sample size, weakening 
                                                                       the study’s power to detect a treatment effect. At worst, attrition 
                                                                       introduces bias into an otherwise well-designed study and threatens
                                                                       the study’s internal and external validity."), 
                                                 p("With SALT, researchers can get student mobility estimates for 
                                                   different student and school subpopulations and for different 
                                                   transition periods from kindergarten to grade 12. Mobility rates 
                                                   are broken down by three types of mobility that correspond to different 
                                                   types of data collection:"), 
                                                 tags$ol(tags$li("Any move out of the student’s original school (attrition 
                                                                 when only collecting data from specific study schools)"), 
                                                         tags$li("Move to a different school in a different school district 
                                                                 (attrition when only collecting data from specific school 
                                                                 districts)"), 
                                                         tags$li("Move outside the state public school system, including moves 
                                                                 to a private school or dropping out of school (attrition when only 
                                                                 collecting data from specific states)")), 
                                                 h3("Why use SALT?"), p("SALT can help researchers proactively plan for student attrition during the study design phase. 
                                                                        For example, researchers should take student attrition into account when conducting
                                                                        a power analysis. Without good assumptions about student attrition, a 
                                                                        study may be underpowered. SALT can also inform decisions about the 
                                                                        breadth of data collection efforts. By comparing rates across the 
                                                                        three types of mobility, researchers can determine whether, for 
                                                                        example, the use of a statewide database rather than a district 
                                                                        database will retaining enough students in the study to warrant 
                                                                        the extra efforts required to secure access to the statewide data."), 
                                                 p("Researchers can also use SALT as a relative benchmark for the degree of student 
                                                   attrition in a given study. If a study’s attrition rate is larger than 
                                                   the expected student mobility rate, it is a warning sign that attrition 
                                                   may threaten the study’s internal and/or external validity. If, however, 
                                                   the study’s attrition rate is smaller than the expected student mobility 
                                                   rate, it may be a sign that attrition was the result of normative student 
                                                   mobility and not factors associated with the study. However, one should be 
                                                   careful to not over-interpret such post hoc comparisons with SALT. Threats 
                                                   to internal and external validity should not be ruled out simply because 
                                                   the attrition rate falls below a particular mobility benchmark.")), 
                   tabPanel("Tool Page", h3("How to use this tool"), p(paste("Please use the menus on the left to select your options.
                                                                             To begin the process, identify the transition period of interest. 
                                                                             Then choose the type of subgroup interactions you want to look at. You can then choose
                                                                             the different school and student characteristics.When the selection process is 
                                                                             complete, results will be displayed in a table and a plot on screen."), 
                                                                       sidebarLayout(sidebarPanel(selectInput("transitionPeriod", "Select Transition Period", 
                                                                                                              choices = transitions, selectize = FALSE, selected = "K to 1"), 
                                                                                                  selectInput("interType", "Select Interaction Type", choices = c("school-by-student interaction", 
                                                                                                                                                                  "school-by-school interaction", "student-by-student interaction"), 
                                                                                                              selectize = FALSE, selected = "school-by-student interaction"), 
                                                                                                  selectInput("group1", "Group 1", choices = "", selectize = FALSE), 
                                                                                                  selectInput("group2", "Group 2", choices = "", selectize = FALSE), 
                                                                                                  checkboxInput("seCheck", "Include Confidence Interval", value = FALSE)), 
                                                                                     mainPanel(plotOutput("plot"), tabPanel("data", dataTableOutput("mytable")))))), 
                   tabPanel(title = "FAQ", h3("Where do the mobility rate benchmarks come from?"), 
                            p("We used four restricted-use longitudinal data sets from the
                              National Center for Education Statistics (NCES) to calculate
                              student mobility:"), 
                            tags$ul(tags$li("The Early Childhood Longitudinal Study–Kindergarten Class of 1998 (ECLS-K:98)"), 
                                    tags$li("The Early Childhood Longitudinal Study–Kindergarten (ECLS-K:10)"), 
                                    tags$li("Education Longitudinal Study (ELS)"), tags$li("High School Longitudinal Study (HSLS)")), 
                            p("The use of multiple nationally representative data sets allowed 
                              us to examine student mobility rates across a range of grade 
                              levels—with two data sets covering mobility during the elementary 
                              school years and two data sets covering mobility during the high 
                              school years—and present findings across different populations 
                              relevant to applied education researchers."), 
                            h3("How to cite this work"), p("Rickles, J., Zeiser, K., & Emad, A. (2016). Student Attrition Lookup Tool (SALT).
                                                           American Institutes for Research: Washington, DC."), 
                            h3("Acknowledgements"), p("This study is funded with research grant R305D150026 from the U.S. 
                                                      Department of Education’s Institute of Education Sciences. The 
                                                      opinions expressed are those of the authors and do not represent 
                                                      the views of the Institute or the U.S. Department of Education.")))))