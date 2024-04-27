library(shiny)
library(tidyverse)
library(ggplot2)
library(plotly)
library(shinydashboard)
library(haven)


## Data
cleaned_wvs <- read_csv("data/cleaned_wvs.csv")
countries <- unique(cleaned_wvs$country)





## Functions for tables and charts

### 1. Democracy - table ###
democracy_table <- function(data = NULL){
  
  # empty data frame
  column_names <- c("Question", "Very often(%)", "Fairly often(%)", "Not often(%)", "Not at all often(%)")
  demo_tab <- data.frame(matrix(nrow = 0, ncol = length(column_names)))
  
  # filter based on country
  demo_data <- data[2:10]
  
  if(all(is.na(unlist(demo_data)))) {
    return("The data for the selected country is unavailable. Please select another country.")
  }
  demo_data <- na.omit(demo_data)
  
  # iterate through each democracy variable
  for (i in 1:9){
    
    # proportion table
    prop_table <- as.vector(round(prop.table(table(demo_data[i])), 4))
    prop_table_row <- c(names(demo_data[i]), prop_table)
    demo_tab <- rbind(demo_tab, prop_table_row)
    names(demo_tab) <- column_names
  }
  
  return(as.data.frame(demo_tab))
}



### 1. Democracy - chart ###
democracy_chart <- function(data = NULL){
  
  # filter based on country
  demo_data <- data[2:10]
  
  if(all(is.na(unlist(demo_data)))) {
    return(list("a", "b", "c", "d", "e", "f", "g", "h", "i"))
  }
  demo_data <- na.omit(demo_data)
  
  plots <- list()
  
  # iterate
  for (i in 1:9){
    prop_table <- as.data.frame(prop.table(table(demo_data[i])))
    colnames(prop_table) <- c("Category", "Proportion")
    category_labels <- c("Very often", "Fairly often", "Not often", "Not at all often")
    prop_table$Category <- category_labels
    prop_table$Category <- factor(prop_table$Category, levels = rev(category_labels))
    
    demo_plot <- ggplot(prop_table, aes(x=Proportion, y=Category)) +
      geom_bar(stat = "identity", fill = "skyblue") +
      labs(title = names(demo_data)[i],
           x = "Proportion") +
      theme_minimal() +
      theme(axis.title.y = element_blank())
    
    plots[[i]] <- demo_plot
  }
  return(plots)
}



### 2. News - table ###
news_table <- function(data = NULL){
  
  # empty data frame
  column_names <- c("Question", "Daily(%)", "Weekly(%)", "Monthly(%)", "Less than monthly(%)", "Never(%)")
  news_tab <- data.frame(matrix(nrow = 0, ncol = length(column_names)))
  
  # filter based on country
  news_data <- data[11:18]
  
  if(all(is.na(unlist(news_data)))) {
    return("The data for the selected country is unavailable. Please select another country.")
  }
  news_data <- na.omit(news_data)
  
  # iterate through each democracy variable
  for (i in 1:8){
    
    # proportion table
    prop_table <- as.vector(round(prop.table(table(news_data[i])), 4))
    prop_table_row <- c(names(news_data[i]), prop_table)
    news_tab <- rbind(news_tab, prop_table_row)
    names(news_tab) <- column_names
  }
  
  return(as.data.frame(news_tab))
}



### 2. News - chart ###
news_chart <- function(data = NULL){
  
  # filter based on country
  news_data <- data[11:18]
  if(all(is.na(unlist(news_data)))) {
    return(list("a", "b", "c", "d", "e", "f", "g", "h"))
  }
  news_data <- na.omit(news_data)
  
  plots <- list()
  
  # iterate
  for (i in 1:8){
    prop_table <- as.data.frame(prop.table(table(news_data[i])))
    colnames(prop_table) <- c("Category", "Proportion")
    category_labels <- c("Daily", "Weekly", "Monthly", "Less than monthly", "Never")
    prop_table$Category <- category_labels
    prop_table$Category <- factor(prop_table$Category, levels = rev(category_labels))
    
    
    news_plot <- ggplot(prop_table, aes(x=Proportion, y=Category)) +
      geom_bar(stat = "identity", fill = "skyblue") +
      labs(title = names(news_data)[i],
           x = "Proportion") +
      theme_minimal() +
      theme(axis.title.y = element_blank())
    
    plots[[i]] <- news_plot
  }
  return(plots)
}



### 3. Science - table ###
science_table <- function(data = NULL){
  
  # empty data frame
  column_names <- c("Question", "Average value")
  science_tab <- data.frame(matrix(nrow = 0, ncol = length(column_names)))
  
  # filter based on country
  science_data <- data[19:24]
  if(all(is.na(unlist(science_data)))){
    return("The data for the selected country is unavailable. Please select another country.")
  }
  science_data <- na.omit(science_data)
  
  # iterate through each democracy variable
  for (i in 1:6){
    
    # average table
    mean <- round(mean(unlist(science_data[i])), 4)
    prop_table_row <- c(names(science_data[i]), mean)
    science_tab <- rbind(science_tab, prop_table_row)
    names(science_tab) <- column_names
  }
  
  return(as.data.frame(science_tab))
}



### 3. Science - chart ###
science_chart <- function(data = NULL){
  
  # empty data frame
  column_names <- c("Question", "Average")
  science_tab <- data.frame(matrix(nrow = 0, ncol = length(column_names)))
  
  # filter based on country
  science_data <- data[19:24]
  science_data <- na.omit(science_data)
  
  # iterate through each democracy variable
  for (i in 1:6){
    
    # average table
    mean <- round(mean(unlist(science_data[i])), 4)
    prop_table_row <- c(names(science_data[i]), mean)
    science_tab <- rbind(science_tab, prop_table_row)
    names(science_tab) <- column_names
    science_tab <- as.data.frame(science_tab)
  }
  
  plot <- ggplot(science_tab, aes(x=Question, y=Average, group=1)) +
    geom_point(color = "black") +
    geom_line(color = "blue") +
    coord_flip() +
    labs(title = "Average values of the questions in attitudes to science",
         y = "Average Value",
         x = "Questions") +
    theme_minimal()
  return(plot)
}





## Shiny

ui <- dashboardPage(
  ## Header ##
  dashboardHeader(title = "World Values Study (WVS)",
                  titleWidth = 300),
  
  ## Slidebar ##
  dashboardSidebar(
    width = 300,
    
    # input
    selectInput("country", "Country:", choices = countries),
    # sidebar menu
    sidebarMenu(
      menuItem("Overview", tabName = "Overview", icon = icon("dashboard")),
      menuItem("Democracy", tabName = "Democracy", icon = icon("building-columns")),
      menuItem("News Consumption", tabName = "News_Consumption", icon = icon("newspaper")),
      menuItem("Attitudes to Science", tabName = "Attitudes_to_Science", icon = icon("flask"))
    )
  ),
  
  ## Dashboard Body ##
  dashboardBody(
    tags$head(
      tags$style(HTML(".main-sidebar { font-size: 23px; }"))
    ),
    
    tabItems(
      
      # First tab content
      tabItem(
        tabName = "Overview",
        h1("Overview of the Application"),
        h2("Introduction"),
        h3("This application is designed to delve into data sourced from the World Value Study (WVS). Users can navigate through attitudes toward democracy, news consumption patterns, and attitudes toward science on a country-by-country basis by using the country drop-down menu located in the sidebar."),
        h2("Section Information"),
        h3("The application is structured around four main tabs: Overview, Democracy, News Consumption, and Attitudes to Science. These tabs are easily accessible through the sidebar menu. In some cases, data may not be available for certain countries. When these countries are selected, only the tables and graphs on the entire WVS sample will be provided"),
        
        tags$ul(
          style = "font-size: 23px; list-style-type: disc",
          tags$li("The 'Democracy' section provides insights into attitudes toward democracy, referencing variables V228A-V228I from the WVS."),
          tags$li("In the 'News Consumption' section, users can explore how people consume news from various sources such as TV news, radio news, etc., referencing data from V217-V224 in the WVS."),
          tags$li("The 'Attitudes to Science' section offers insights into people's opinions and attitudes toward science, from variables V192-V197 in WVS.")
          ),
        
        h3("Each of these sections contain plots and tables displaying averages of questions, alongside a comprehensive table with the information on the entire WVS sample.")
      ),
      
      # Second tab content
      tabItem(
        tabName = "Democracy",
        h1("Attitudes to Democracy"),
        
        fluidPage(
          tags$style(type="text/css", ".dataTables_wrapper table { font-size: 22px !important; }"),
          
          h2("Overall"),
          h3("Table of the average values of the questions with the entire WVS sample:"),
          dataTableOutput("table_overall_democracy"),
          
          
          h2(uiOutput("selected_country_democracy")),
          h3("Table of the average values of the questions:"),
          dataTableOutput("table_democracy"),
          
          h3("Plots of the average values of the questions:"),
          fluidRow(
            column(4, plotlyOutput("plot_democracy1")),
            column(4, plotlyOutput("plot_democracy2")),
            column(4, plotlyOutput("plot_democracy3"))
          ),
          
          fluidRow(
            column(4, plotlyOutput("plot_democracy4")),
            column(4, plotlyOutput("plot_democracy5")),
            column(4, plotlyOutput("plot_democracy6"))
          ),
          
          fluidRow(
            column(4, plotlyOutput("plot_democracy7")),
            column(4, plotlyOutput("plot_democracy8")),
            column(4, plotlyOutput("plot_democracy9"))
          )
        ) 
      ),
      
      # Third tab content
      tabItem(
        tabName = "News_Consumption",
        h1("News Consumption"),
        
        fluidPage(
          tags$style(type="text/css", ".dataTables_wrapper table { font-size: 22px !important; }"),
          h2("Overall"),
          h3("Table of the average values of the questions with the entire WVS sample:"),
          dataTableOutput("table_overall_news"),
          
          h2(uiOutput("selected_country_news")),
          h3("Table of the average values of the questions:"),
          dataTableOutput("table_news"),

          h3("Plots of the average values of the questions:"),          
          fluidRow(
            column(4, plotlyOutput("plot_news1")),
            column(4, plotlyOutput("plot_news2")),
            column(4, plotlyOutput("plot_news3"))
          ),

          fluidRow(
            column(4, plotlyOutput("plot_news4")),
            column(4, plotlyOutput("plot_news5")),
            column(4, plotlyOutput("plot_news6"))
          ),

          fluidRow(
            column(4, plotlyOutput("plot_news7")),
            column(4, plotlyOutput("plot_news8")),
          )
        )
      ),

      # Fourth tab content
      tabItem(
        tabName = "Attitudes_to_Science",
        h1("Attitudes to Science"),
        
        fluidPage(
          tags$style(type="text/css", ".dataTables_wrapper table { font-size: 22px !important; }"),
          h2("Overall"),
          h3("Table of the average values of the questions with the entire WVS sample:"),
          dataTableOutput("table_overall_science"),
          
          h2(uiOutput("selected_country_science")),
          h3("Table of the average values of the questions:"),
          dataTableOutput("table_science"),
          
          h3("Plot of the average values of the questions:"),
          fluidRow(
            column(
              width = 8, offset = 2,
              plotlyOutput("plot_science", width = "100%", height = "600px"),
            )
          )
        )
      )
    )
  )
)





server <- function(input, output){
  
  ### Data ###
  country_wvs <- reactive({
    req(input$country)
    cleaned_wvs %>% filter(country == input$country)
  })
  
  
  ### Democracy ###
  output$selected_country_democracy <- renderText({input$country})
  
  output$table_democracy <- renderDataTable({
    req(country_wvs())
    democracy_data <- democracy_table(country_wvs())
    validate(
      need(!is.character(democracy_data), "The data for the selected country is unavailable. Please select another country.")
    )
    return(democracy_data)
  })
  
  output$plot_democracy1 <- renderPlotly({
    req(country_wvs())
    democracy_data_plot1 <- democracy_chart(country_wvs())[[1]]
    validate(
      need(!is.character(democracy_data_plot1), "The data for the selected country is unavailable. Please select another country.")
    )
    return(democracy_data_plot1)
  })
  
  output$plot_democracy2 <- renderPlotly({
    req(country_wvs())
    democracy_data_plot2 <- democracy_chart(country_wvs())[[2]]
    validate(
      need(!is.character(democracy_data_plot2), "")
    )
    return(democracy_data_plot2)
  })
  
  output$plot_democracy3 <- renderPlotly({
    req(country_wvs())
    democracy_data_plot3 <- democracy_chart(country_wvs())[[3]]
    validate(
      need(!is.character(democracy_data_plot3), "")
    )
    return(democracy_data_plot3)
  })
  
  output$plot_democracy4 <- renderPlotly({
    req(country_wvs())
    democracy_data_plot4 <- democracy_chart(country_wvs())[[4]]
    validate(
      need(!is.character(democracy_data_plot4), "")
    )
    return(democracy_data_plot4)
  })
  
  output$plot_democracy5 <- renderPlotly({
    req(country_wvs())
    democracy_data_plot5 <- democracy_chart(country_wvs())[[5]]
    validate(
      need(!is.character(democracy_data_plot5), "")
    )
    return(democracy_data_plot5)
  })
  
  output$plot_democracy6 <- renderPlotly({
    req(country_wvs())
    democracy_data_plot6 <- democracy_chart(country_wvs())[[6]]
    validate(
      need(!is.character(democracy_data_plot6), "")
    )
    return(democracy_data_plot6)
  })
  
  output$plot_democracy7 <- renderPlotly({
    req(country_wvs())
    democracy_data_plot7 <- democracy_chart(country_wvs())[[7]]
    validate(
      need(!is.character(democracy_data_plot7), "")
    )
    return(democracy_data_plot7)
  })
  
  output$plot_democracy8 <- renderPlotly({
    req(country_wvs())
    democracy_data_plot8 <- democracy_chart(country_wvs())[[8]]
    validate(
      need(!is.character(democracy_data_plot8), "")
    )
    return(democracy_data_plot8)
  })
  
  output$plot_democracy9 <- renderPlotly({
    req(country_wvs())
    democracy_data_plot9 <- democracy_chart(country_wvs())[[9]]
    validate(
      need(!is.character(democracy_data_plot9), "")
    )
    return(democracy_data_plot9)
  })
  
  output$table_overall_democracy <- renderDataTable({
    democracy_table(cleaned_wvs)
  })
  
  
  ### News consumption ###
  output$selected_country_news <- renderText({input$country})
  
  output$table_news <- renderDataTable({
    req(country_wvs())
    news_data <- news_table(country_wvs())
    validate(
      need(!is.character(news_data), "The data for the selected country is unavailable. Please select another country.")
    )
    news_table(country_wvs())
  })
  
  output$plot_news1 <- renderPlotly({
    req(country_wvs())
    news_data_plot1 <- news_chart(country_wvs())[[1]]
    validate(
      need(!is.character(news_data_plot1), "The data for the selected country is unavailable. Please select another country.")
    )
    return(news_data_plot1)
  })
  
  output$plot_news2 <- renderPlotly({
    req(country_wvs())
    news_data_plot2 <- news_chart(country_wvs())[[2]]
    validate(
      need(!is.character(news_data_plot2), "")
    )
    return(news_data_plot2)
  })
  
  output$plot_news3 <- renderPlotly({
    req(country_wvs())
    news_data_plot3 <- news_chart(country_wvs())[[3]]
    validate(
      need(!is.character(news_data_plot3), "")
    )
    return(news_data_plot3)
  })
  
  output$plot_news4 <- renderPlotly({
    req(country_wvs())
    news_data_plot4 <- news_chart(country_wvs())[[4]]
    validate(
      need(!is.character(news_data_plot4), "")
    )
    return(news_data_plot4)
  })
  
  output$plot_news5 <- renderPlotly({
    req(country_wvs())
    news_data_plot5 <- news_chart(country_wvs())[[5]]
    validate(
      need(!is.character(news_data_plot5), "")
    )
    return(news_data_plot5)
  })
  
  output$plot_news6 <- renderPlotly({
    req(country_wvs())
    news_data_plot6 <- news_chart(country_wvs())[[6]]
    validate(
      need(!is.character(news_data_plot6), "")
    )
    return(news_data_plot6)
  })
  
  output$plot_news7 <- renderPlotly({
    req(country_wvs())
    news_data_plot7 <- news_chart(country_wvs())[[7]]
    validate(
      need(!is.character(news_data_plot7), "")
    )
    return(news_data_plot7)
  })
  
  output$plot_news8 <- renderPlotly({
    req(country_wvs())
    news_data_plot8 <- news_chart(country_wvs())[[8]]
    validate(
      need(!is.character(news_data_plot8), "")
    )
    return(news_data_plot8)
  })
  
  output$table_overall_news <- renderDataTable({
    news_table(cleaned_wvs)
  })
  

  ### Science ###
  output$selected_country_science <- renderText({input$country})
  
  output$table_science <- renderDataTable({
    req(country_wvs())
    science_data <- science_table(country_wvs())
    validate(
      need(!is.character(science_data), "The data for the selected country is unavailable. Please select another country.")
    )
    return(science_data)
  })
  
  output$plot_science <- renderPlotly({
    req(country_wvs())
    science_chart(country_wvs())
  })
  
  output$table_overall_science <- renderDataTable({
    science_table(cleaned_wvs)
  })
  
}



shinyApp(ui, server)



