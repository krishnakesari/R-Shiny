library(shiny)

ui <- shinyUI(pageWithSidebar(
            headerPanel("Minimal Example"),
            sidebarPanel(
                textInput(inputId = "comment",
                      label = "Say Something ?",
                      value = "")),
            mainPanel(
                h3("This is you saying it"),
                textOutput("textDisplay")
                )
        ))

server <- shinyServer(function(input, output) {
            output$textDisplay <- renderText({
                        paste0("You said ' ", input$comment,
                                " '. There are ", nchar(input$comment),
                        "characters in this.")
                        })
                    })

shinyApp(ui = ui, server = server)