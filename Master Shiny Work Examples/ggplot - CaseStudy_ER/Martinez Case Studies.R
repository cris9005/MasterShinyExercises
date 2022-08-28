# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(vroom)
library(tidyverse)



dir.create("neiss")
#> Warning in dir.create("neiss"): 'neiss' already exists
download <- function(name) {
  url <- "https://github.com/hadley/mastering-shiny/raw/master/neiss/"
  download.file(paste0(url, name), paste0("neiss/", name), quiet = TRUE)
}
download("injuries.tsv.gz")
download("population.tsv")
download("products.tsv")


injuries <- vroom::vroom("neiss/injuries.tsv.gz")
injuries

products <- vroom::vroom("neiss/products.tsv")
products


population <- vroom::vroom('neiss/population.tsv.')
population


## Exploration 
selected <- injuries %>% filter(prod_code == 649)
nrow(selected)  ## There are approx. 2993 cases for toilets

selected %>% count(location, wt = weight, sort = TRUE)


selected %>% count(body_part, wt = weight, sort = TRUE)

selected %>% count(diag, wt = weight, sort = TRUE)


summary <- selected %>% count(age, sex, wt = weight, sort = TRUE)
summary


summary %>%
  ggplot(aes(age, n, colour = sex)) +
  geom_line() +
  labs(y = "Estimated number of injuries")


## filtering data exploration 
summary <- selected %>%
  count(age, sex, wt = weight) %>%
  left_join(population, by = c("age", "sex")) %>%
  mutate(rate = n / population * 1e4)

summary %>%
  ggplot(aes(age, rate, colour = sex)) +
  geom_line(na.rm = TRUE) +
  labs(y = "Injuries per 10,000 people")


selected %>%
  sample_n(10) %>%
  pull(narrative)


prod_codes <- setNames(products$prod_code, products$title)
count_top <- function(df, var, n = 5) {

    df %>%
    mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = n)) %>%
    group_by({{ var }}) %>%
    summarise(n = as.integer(sum(weight)))
}


# Define UI for application that draws a histogram
ui <- fluidPage(
    fluidRow(
      column(6, 
             selectInput('code', "Product", choices = prod_codes)
             )
    ), 
    fluidRow(
      column(4, tableOutput('diag')), 
      column(4, tableOutput('body_part')),
      column(4, tableOutput("location"))
    ),
    fluidRow(
      column(12, plotOutput("age_sex"))
    )
  )



# Define server logic required to draw a histogram
server <- function(input, output, session) {
  selected <- reactive(injuries %>% filter(prod_code == input$code))
  
  output$diag <- renderTable(count_top(selected(), diag), width = "100%")
  output$body_part <- renderTable(count_top(selected(), body_part), width = "100%")
  output$location <- renderTable(count_top(selected(), location), width = "100%")
  
  
  summary <- reactive({
    selected() %>%
      count(age, sex, wt = weight) %>%
      left_join(population, by = c("age", "sex")) %>%
      mutate(rate = n / population * 1e4)
  })
  
  output$age_sex <- renderPlot({
    summary() %>%
      ggplot(aes(age, n, colour = sex)) +
      geom_line() +
      labs(y = "Estimated number of injuries")
  }, res = 96)
}
  

# Run the application 
shinyApp(ui = ui, server = server)
