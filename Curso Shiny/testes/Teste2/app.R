library(shiny)
library(shinydashboard)

ui <-  dashboardPage(
  dashboardHeader(title = "IMRS Demografia"),
  
  dashboardSidebar(sidebarMenu(id = 'barra_lateral',
                               menuItem("Opção 1", tabName = 'opcao1'),
                               menuItem("Opção 2", tabName = 'opcao2')
  )
  ),
  
  dashboardBody(radioButtons(inputId = 'input1',
                             choices = c("A", "B"),
                             label = "Escolha uma das opções:",
                             selected = "A"),
                conditionalPanel(condition = "input.input1 == 'A'",
                                 dateRangeInput(inputId = 'input6',
                                                label = "dateRangeInput",
                                                min = "2022-01-01", 
                                                format = "dd-mm-yyyy")
                ),
                conditionalPanel(condition = "input.input1 == 'B'",
                                 sliderInput(inputId = 'input6',
                                                label = "Escolha um valor",
                                                min = 1,
                                                max = 100,
                                                value = 10)
                )
  )
  
  
)

server <- function(input, output) {
  
}

shinyApp(ui = ui, server = server)