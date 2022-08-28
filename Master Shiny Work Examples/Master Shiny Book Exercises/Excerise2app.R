#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram

#ui <- fluidPage(

    # Application title
    #titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    #sidebarLayout(
      #  sidebarPanel(
          #  sliderInput("bins",
         #               "Number of bins:",
        #                min = 1,
       #                 max = 50,
      #                  value = 30)
     #   ),

    #    # Show a plot of the generated distribution
   #     mainPanel(
  #         plotOutput("distPlot")
 #       )
#    )
#)

# Define server logic required to draw a histogram
#server <- function(input, output) {

    #output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        #x    <- faithful[, 2]
       # bins <- seq(min(x), max(x), length.out = input$bins + 1)

      #  # draw the histogram with the specified number of bins
    #    hist(x, breaks = bins, col = 'darkgray', border = 'white',
   #          xlab = 'Waiting time to next eruption (in mins)',
  #           main = 'Histogram of waiting times')
 #   })
#}

# Run the application 
#shinyApp(ui = ui, server = server)



ui <- fluidPage(
  textInput("name", "What's your name?"),
  textOutput("greeting")
)

server <- function(input, output, session) {
  # Create a reactive expression
  output$greeting <- renderText({
    paste0("Hello ", input$name)
  })
}  
  


shinyApp(ui, server)


ui <- fluidPage(
  radioButtons("rb", "Choose one:",
               choiceNames = list(
                 icon("angry"),
                 icon("smile"),
                 icon("sad-tear")
               ),
               choiceValues = list("angry", "happy", "sad")
  )
)

## 1. 
textInput("text", "", placeholder = "Your name")
##2.
sliderInput(
  "dates",
  "When should we deliver?",
  min = as.Date("2019-08-09"),
  max = as.Date("2019-08-16"),
  value = as.Date("2019-08-10")
)


## Using too many {} due to the breaks can be rewritten

ui <- fluidPage(
  textOutput("text"),
  verbatimTextOutput("code")
)
server <- function(input, output, session) {
  output$text <- renderText({
    "Hello friend!"
  })
  output$code <- renderPrint({
    summary(1:10)
  })
}

## As: 
server <- function(input, output, session) {
  output$text <- renderText("Hello friend!")
  output$code <- renderPrint(summary(1:10))
}