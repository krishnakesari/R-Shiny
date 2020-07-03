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

PO <- read.csv("PO.csv", stringsAsFactors = FALSE)

PO$Area <- NA

PO$Area[grep("RHARY", PO$NACS, ignore.case = TRUE)] <- "Armadillo"
PO$Area[grep("RHAAR", PO$NACS, ignore.case = TRUE)] <- "Baboon"
PO$Area[grep("715", PO$NACS, ignore.case = TRUE)] <- "Camel"
PO$Area[grep("710i", PO$NACS, ignore.case = TRUE)] <- "Deer"
PO$Area[grep("700", PO$NACS, ignore.case = TRUE)] <- "Elephant"

PO$ToAdd <- 1

PO <- PO[!is.na(PO$TeamC),]
PO <- PO[nrow(PO):1,]

PO$SUm <- ave(PO$ToAdd, PO$TeamC, FUN = cumsum)
PO$Date <- as.Date(substr(PO$dtsubmitted, 1, 10),
                  format = "%Y-%m-%d")

server <- shinyServer(function(input, output) {
               output$plotDisplay <- renderPlot({
                    toPlot = PO[PO$TeamC == input$area,]
               print(ggplot(toPlot, aes(x = Date, y = sum))+
                     geom_line()
                     )
               })

               output$outputLink <- renderText({
                    link <- switch(input$area,
                            "Armadillo" = "http://www.patientopinion.org.uk/services/rhary",
                            "Baboon" = "http://www.patientopinion.org.uk/services/rhaar",
                            "Camel" = "http://www.patientopinion.org.uk/services/rha_715",
                            "Deer" = "http://www.patientopinion.org.uk/services/rha_710i",
                            "Elephant" = "http://www.patientopinion.org.uk/services/rha_700"
                            )
                    paste0('<form action="' , link, '"target="_blank">
                            <input type="submit" value="Go to main site">
                            </form>')

               })
      })

shinyApp(ui, server)