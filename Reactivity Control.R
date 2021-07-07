# Building a conditional panel
conditionalPanel(
        condition = "input.smother == true",
        selectInput("linear model", "Linear or smoothed",
                    list("lm", "loess"))
)

# Building a tab panel elements
tabsetPanel(id = "theTabs",
            tabPanel("Summary", textOutput("textDisplay"),
                    value = "Summary"),
            tabPanel("Monthly figures",
                    plotOutput("MonthGraph"),
                    value = "monthly"),
            tabPanel("Hourly figures",
                    plotOutput("hourGraph"),
                    value = "hourly")
            )

passData <- reactive({
        if(input$theTabs != "hourly") {
                analytics <- analytics[analytics$Date %in%
                               seq.Date(input$dateRange[1], input$dateRange[2],
                               by = "days"),]
        }
        if(input$theTabs != "monthly") {
                analytics <- analytics[analytics$Hour %in%
                                as.numeric(input$minimumTime) :
                                as.numeric(input$maximumTime),]
        }
        analytics <- analytics[analytics$Domain %in%
                        unlist(input$domainShow),]
        analytics
})


# Building a complex conditional panel
