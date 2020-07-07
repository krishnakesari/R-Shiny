library(shiny)

shinyServer(function(input, ouput){
    output$dataset <- renderTable({
        theData = switch(input$dataset,
                        "iris" = iris,
                        "USPersonalExpenditure" =
                            USPersonalExpenditure,
                        "CO2" = CO2)
        
        head(theData)
    })

    ouput$datatext <- renderText({
        paste0("This is the", input$dataSet, " dataset")
    })

    output$hiddentext <- renderText({
        paste0("Dataset has ", nrow(switch(input$dataset,
                    "iris" = iris,
                    "USPersonalExpenditure" =
                     USPersonalExpenditure,
                    "CO2" = CO2)), " rows")
    })
})