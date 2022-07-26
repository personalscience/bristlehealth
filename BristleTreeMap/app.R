#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(treemap)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Bristle Health Oral Microbiome"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
          fileInput("ask_bristle_filename", label = "Choose Bristle File (xlsx)", accept = ".xlsx")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("bristlePlot"),
           plotOutput("bristleTree")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  ## filepath_bristle ----
  filepath_bristle<- reactive({
    validate(
      need(input$ask_bristle_filename,"Please select a valid Bristle xlsx file")
    )
    input$ask_bristle_filename}
  )

  bristle_raw <- reactive({filepath_bristle()$datapath})

  raw_bristle_data <- reactive(readxl::read_xlsx(file.path(bristle_raw())))

    # readxl::read_xlsx(file.path("../BristleHealthRaw.xlsx"))

    output$bristlePlot <- renderPlot({

      raw_bristle_data() %>% transmute(genus,species,abundance=`relative abundance`/100) %>%
        group_by(genus) %>% summarize(sum=sum(abundance)) %>%
        arrange(desc(sum)) %>% slice_max(order_by=sum, prop=.5) %>% # summarize(total=sum(sum))# %>%
        ggplot(aes(x=reorder(genus,-sum), y=sum)) + geom_col() +
        theme(axis.text.x=element_text(angle = 90, vjust = 0.5)) +
        labs(y="Abundance (%)", x = "Genus", title = "Bristle Health Result")
    })

    output$bristleTree <- renderPlot({

      raw_bristle_data() %>% transmute(genus,species,abundance=`relative abundance`/100) %>%
        treemap::treemap(dtf=., index = c("genus","species"),
                         vSize="abundance",
                         title = "My Mouth Microbes")
      })




}

# Run the application
shinyApp(ui = ui, server = server)
