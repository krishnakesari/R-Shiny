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

            



