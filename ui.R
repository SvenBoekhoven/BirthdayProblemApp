library(shiny)
shinyUI(pageWithSidebar(
        headerPanel("Birthday problem"),
        
        sidebarPanel(
                sliderInput('prob', 'Select probability',value = 0.5, min = 0.1, max = 0.95, step = 0.05,),
        
                sliderInput('coincident', 'Select number same birthdays',value = 2, min = 2, max = 5, step = 1,),
        
                sliderInput('sims', 'Select number of simulations',value = 100, min = 50, max = 250, step = 25,),
                
                helpText(a(href="https://github.com/SvenBoekhoven/BirthdayProblemApp/", target="_blank", "View code"))
        ),
        mainPanel(
                tabsetPanel(
                        tabPanel("plot", plotOutput('Tbday'), plotOutput('Sbday')),
                        tabPanel("help", htmlOutput("help"))
                )
        )
))