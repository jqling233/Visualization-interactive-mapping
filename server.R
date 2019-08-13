
options(shiny.maxRequestSize=30*1024^2)
library(shiny)
library(leaflet)
library(dplyr) 
library(DescTools)



# Define server that analyzes the patterns of crimes in DC
shinyServer(function(input, output) {
  
  # Create an output variable for problem description
  output$text <- renderText({
    
    "This project uses the dataset 'Recommended Fishing Rivers, Streams, Lakes and Ponds'. This data displays the locations of top rivers, streams, lakes and ponds for fishing in New York State, as determined by fisheries biologists working for the New York State Department of Environmental Conservation." 
  
  })
  
  
  # Create a bar plot for different number of 
  output$plot1 <- renderPlot({
    
    # Connect to the sidebar of file input
    inFile <- input$file

    if(is.null(inFile))
      return("Please Upload A File For Analysis")
    
    # Read input file
    mydata <- read.csv(inFile$datapath)
    attach(mydata)
    
    
    # Filter the data for different fish species and different public access
    target1 <- c(input$Fish_Species)
    target2 <- c(input$Public_Access)
    waterbody_df <- filter(mydata, (Fish_Species_Present_at_Waterbody %like% paste(target1,"%")|Fish_Species_Present_at_Waterbody %like% paste("%",target1,"%")|Fish_Species_Present_at_Waterbody %like% paste("%",target1)) & (Types_of_Public_Access %like% paste(target2,"%")|Types_of_Public_Access %like% paste("%",target2,"%")|Types_of_Public_Access %like% paste("%",target2)))
    
    # Create a table for waterbody name and Number_of_species
    df <- subset(waterbody_df,select=c("Waterbody_Name","Number_of_species"))
    df <- df[order(-df$Number_of_species),]
    
    hist(df$Number_of_species,
         main = "Number of species",
         col = "#75AADB", border = "white")
  })
  
  
  # Create a table lists the raw data
  output$table2 <- renderPrint({
    
    # Connect to the sidebar of file input
    inFile <- input$file
    
    if(is.null(inFile))
      return("Please Upload A File For Analysis")
    
    # Read input file
    mydata <- read.csv(inFile$datapath)
    attach(mydata)
    
    
    # Filter the data for different fish species and different public access
    target1 <- c(input$Fish_Species)
    target2 <- c(input$Public_Access)
    waterbody_df <- filter(mydata, (Fish_Species_Present_at_Waterbody %like% paste(target1,"%")|Fish_Species_Present_at_Waterbody %like% paste("%",target1,"%")|Fish_Species_Present_at_Waterbody %like% paste("%",target1)) & (Types_of_Public_Access %like% paste(target2,"%")|Types_of_Public_Access %like% paste("%",target2,"%")|Types_of_Public_Access %like% paste("%",target2)))
    
    # Create a table for waterbody name and Number_of_species
    df <- subset(waterbody_df,select=c("Waterbody_Name","Fish_Species_Present_at_Waterbody"))
    return(df)
  })
  
  
  # Create a map output variable
  output$map <- renderLeaflet({
    
    # Connect to the sidebar of file input
    inFile <- input$file
    
    if(is.null(inFile))
      return(NULL)
    
    # Read input file
    mydata <- read.csv(inFile$datapath)
    attach(mydata)
 
    # Filter the data for different fish types and public access
    target1 <- c(input$Fish_Species)
    target2 <- c(input$Public_Access)
    map_df <- filter(mydata, (Fish_Species_Present_at_Waterbody %like% paste(target1,"%")|Fish_Species_Present_at_Waterbody %like% paste("%",target1,"%")|Fish_Species_Present_at_Waterbody %like% paste("%",target1)) & (Types_of_Public_Access %like% paste(target2,"%")|Types_of_Public_Access %like% paste("%",target2,"%")|Types_of_Public_Access %like% paste("%",target2)))
    
    # Create colors with a categorical color function
    color <- colorFactor(rainbow(13), map_df$Number_of_species)
    
    # Create the leaflet function for data
    leaflet(map_df) %>%
      
      # Set the default view
      setView(lng = -76.41, lat = 43.33, zoom = 5) %>%
      
      # Provide tiles
      addProviderTiles("CartoDB.Positron", options = providerTileOptions(noWrap = TRUE)) %>%
      
      # Add circlesdf
      addCircleMarkers(
        radius = 2,
        lng= map_df$Longitude,
        lat= map_df$Latitude,
        stroke= FALSE,
        fillOpacity=0.1,
        color=color(Number_of_species)
      ) %>%
      
      # Add legends for number of fish species
      addLegend(
        "bottomleft",
        pal=color,
        values=Number_of_species,
        opacity=0.5,
        title="Number of fish species"
      ) %>%
      
      #Add Markers
      addMarkers(
        ~Longitude, ~Latitude, 
        popup = ~as.character(Waterbody_Name), 
        label = ~as.character(Waterbody_Name)
      )
  })
})