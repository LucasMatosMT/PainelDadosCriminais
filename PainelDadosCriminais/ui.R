library(shiny)
library(shinydashboard)
library(dashboardthemes)

ui <- dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    fluidRow( box(
      title = "Controls",
      sliderInput("slider", "Number of observations:", 1, 100, 50),
      width = 4
    ),
    box(plotOutput("plot1", height = 250),width = 8)
    )
  )
)

