library(shiny)
library(ggplot2)

ui <- shinyUI(pageWithSidebar(
                headerPanel("Text area"),
                sidebarPanel(
                    radioButtons("area", "Service area",
                            c("Armadillo", "Baboon",
                              "Camel", "Deer", "Elephant"),
                            selected = "Armadillo")
                ),
                mainPanel(
                    h3("Total Posts"),
                    HTML("<p>Cumulative <em> totals </em> over time</p>"),
                    plotOutput("plotDisplay"),
                    htmlOutput("outputLink")
                )
            ))

