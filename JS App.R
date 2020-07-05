library(shiny)

ui <- shinyUI(pageWithSidebar(
            headerPanel("Text based animation"),

            sidebarPanel(
                h3("Let's animate something!"),
                p("People enjoy the animation responsibly"),
                tags$textarea(id="textArea", "Please enter text here"),
                tags$input(type = "button", id = "animate", value="Animate !", onClick = "buttonClick()")
            ),

            mainPanel(
                tags$canvas(id="myCanvas", width="500", height="250"),
                includeHTML("textSend.js"),
                textOutput("textDisplay")
            )
        ))


server <- shinyServer(function(input, output)) {
                output$textDisplay <- renderText({
                    paste0("You said '", input$textArea,
                    "'. There are ", nchar(input$textArea),
                    " characters in this."
                    )
                })
            }

shinyApp(ui, server)