library(shiny)

ui <- shinyUI(pageWithSidebar(
              headerPanel("Analytics App"),
              sidebarPanel(
                dateRangeInput(inputId = "dateRange",
                               label = "Date Range",
                               start = "2013-04-01",
                               max = Sys.Date()
                ),

                sliderInput(inputId = "minimumTime",
                          label = "Hours of interest - minimum",
                          min = 0,
                          max = 23,
                          value = 0,
                          step = 1
                ),

                sliderInput(inputId = "maximumTime",
                          label = "Hours of interest - maximum",
                          min = 0,
                          max = 23,
                          value = 23,
                          step = 1
                ),

                checkboxInput(inputId = "smoother",
                            label = "Add smoother?",
                            value = FALSE
                ),

                checkboxGroupInput(inputId = "domainShow",
                                 label = "Show NHS and other domain
                                          (defaults to all)?",
                                 choices = list("NHS users" = "NHS",
                                                "Other" = "Other")
                ),

                radioButtons(inputId = "outputType",
                           label = "Output required",
                           choices = list("Visitors" = "visitors",
                                          "Bounce rate" = "bounceRate",
                                          "Time on site" = "timeOnSite"))
                ),
            
              mainPanel(
                tabsetPanel(
                  tabPanel("Summary", textOutput("textDisplay")),
                  tabPanel("Monthly figures", plotOutput("monthGraph")),
                  tabPanel("Hours figures", plotOutput("hourGraph"))
                )
              )
            ))

load("Analytics.Rdata")

server <- shinyServer(function(input, output) {

    passData <- reactive({
      analytics <- analytics[analytics$Date %in%
                      seq.Date(input$dateRange[1],
                               input$dateRange[2], by = "days"),]
      
      analytics <- analytics[analytics$Hour %in%
                      as.numeric(input$minimumTime):
                      as.numeric(input$maximumTime),]
      
      if(class(input$domainShow)=="character") {
        analytics <- analytics[analytics$Domain %in%
                               unlist(input$domainShow),]
      }
      analytics
    })

    output$monthGraph <- renderPlot({
            graphData <- ddply(passData(), .(Domain, Date), numcolwise(sum))
        
        if(input$outputType == "visitors"){
          theGraph <- ggplot(graphData, aes(x = Date, y = visitors, group = Domain, color = Domain)) +
                      geom_line() +
                      ylab ("Unique visitors")
        }

        if(input$outputType == "bounceRate") {
          theGraph <- ggplot(graphData, aes(x = Date, y = bounces /visits * 100, group = Domain,
                      colour = Domain)) +
                      geom_line() + ylab("Bounce rate %")
        }

        if(input$outputType == "timeOnSite") {
          theGraph <- ggplot(graphData, aes(x = Date, y = timeOnSite /visits, group = Domain,
                      colour = Domain)) +
                      geom_line() + ylab("Average time on site")
        }

        if(input$smoother){
          theGraph <- theGraph + geom_smooth()
        }
        print(theGraph)
    })

    output$textDisplay <- renderText({
            paste(
              length(seq.Date(input$dateRange[1], input$dateRange[2], by = "days")),
              " days are summarized. There were", sum(passData()$visitors),
              "visitors in this time period."
            )
    })


})

shinyApp(ui, server)