library(shiny)
library(leaflet)
library(shinythemes)

# Define UI for application that analyzes the Diversity of Places for Fishing in NY State
shinyUI(fluidPage(
  
  # Change the theme to flatly
  theme = shinytheme("flatly"),
  
  # Application title
  titlePanel("Diversity of Places for Fishing in NY State"),
  
  # Three sidebars for uploading files, selecting fish types and public access
  sidebarLayout(
    sidebarPanel(
      
      # Create a file input
      fileInput("file","Choose A CSV File Please",
                multiple = TRUE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
      
      # Create a multiple checkbox input for fish species
      checkboxGroupInput("Fish_Species","Fish_Species:",
                         c("Atlantic Salmon","Brook Trout","Brown Trout","Carp",
                           "Chain Pickerel","Channel Catfish","Chinook Salmon",
                           "Coho Salmon", "Crappie","Lake Trout","Largemouth Bass",
                           "Muskellunge","Norhtern Pike","Rainbow Trout",
                           "Smallmouth Bass","Steelhead","Striped Bass",
                           "Sunfish","Tiger Musky","Walleye","Yellow Perch")
      ),
      
      hr(),
      helpText("Please Select The Fish Type You Want To Analyze For Diversity"),
      helpText("You Can Choose More Than One"),
      
      hr(),
      hr(),
      
      # Create a multiple checkbox input for public access
      checkboxGroupInput("Public_Access","Public_Access:",
                          c("Boat Launch",
                            "Shore Fishing",
                            "Footpath",
                            "Public Fishing Rights")
      ),
      
      hr(),
      helpText("Please Select The Public Access You Want To Analyze For Diversity"),
      helpText("You Can Choose Only One")
    ),
    
    # Make the sidebar on the right of the webpage
    position = "right",
    fluid = TRUE,
    
    
    
    # Create two tabs
    mainPanel(
      hr(),
      tabsetPanel(type="tabs",
                  
                  #Add a tab for problem description
                  tabPanel("Problem Description", textOutput("text")),
                  
                  #Add a tab for decriptive table
                  tabPanel("Descriptive Analysis",
                           
                           #Add two subtabs
                           tabsetPanel(
                             tabPanel("Histgram",plotOutput("plot1",
                                                            height = "400px",
                                                            width = "400px")),
                             tabPanel("Raw Data",verbatimTextOutput("table2"))
                           )
                  ),
                                       
                  
                  #Tab for the Leaflet Map
                  tabPanel("Map", leafletOutput("map", height=630))
      )
    )
  )
))

