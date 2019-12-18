server <- function(input, output, session){
  options(shiny.maxRequestSize = 30*1024^2,
          shiny.usecairo = TRUE)
# dataset -----------------------------------------------------------------
  dataset <- reactive({
    req(input$gene)
    result$data[[input$gene]]$freq %>% 
       filter(!is.na(Freq)) 
    })
  
# reactive allele selection -----------------------------------------------
  output$ALLLELE <- renderUI({
    req(dataset())
    tmp <- dataset()$Allele %>% unique()
    pickerInput("allele", "Select allele", tmp,
                choicesOpt = list(style = rep(("color: black;"), length(tmp))))
  })
  
# Selected Allel
output$allele_name <- renderText({input$allele})

# gene-filtered data --------------------------------------------------------------------
output$DT_table_rawdata <- renderDataTable({
  req(input$gene)
  req(input$allele)
  
  dataset() %>%
    select(Country = country, Alpha2code=country_taq, Allele, Frequency = Freq, `Cohort size`=size, PMID, Source) %>% 
    datatable(.)
  })

output$DT_table <- renderDataTable({
  req(input$gene)
  req(input$allele)
  
  drop_colums <- switch(input$average,
                        "median" = "Weighted",
                        "weighted median"  = "Frequency")
  
  summarized_data() %>% 
    select(Alpha2code = country_taq, 
           Country = country, Allele, 
           `Frequency [Median]` = Frequency, 
           `Frequency CI [95%]`= Frequency_CI,
           `Weighted Frequency [Median]` = Weighted, 
           `Weighted Median Absolute Deviation` = Weighted_MAD,
           `Number of studies` =Number_of_studies,
           `Studies [PMID]`= Studies)  %>% 
    select(-starts_with(drop_colums)) %>%
    datatable(.,extensions = 'Buttons',
              rownames = FALSE,
              escape = FALSE, 
              filter =  list(position = 'top', clear = TRUE),
              selection = 'none',
              style  = "bootstrap",
              options =  list(pageLength = 25, 
                              search = list(regex = TRUE),
                              columnDefs = list(list(width = '200px', targets = 6)),
                              dom = 'Bfrtip',
                              buttons = c('copy', 'csv', 'excel', 'pdf')))})

# summarized data ---------------------------------------------------------
  summarized_data <- reactive({
    req(input$gene)
    req(input$allele)
    
     dataset() %>% 
      filter(Allele == input$allele) %>%  
      group_by(country_taq, Allele) %>%
      summarise(Frequency = round(median(Freq, na.rm = T),1),
                Number_of_studies = n(),
                Frequency_CI =suppressWarnings(wilcox.test(Freq, conf.int = T, exact = F)) %>% 
                  tidy %>% 
                  select(starts_with("conf")) %>%
                  mutate_all(round, 2) %>% 
                  paste(., collapse = "-") %>% 
                  paste0("CI=(", .,")"),
                Weighted = matrixStats::weightedMedian(Freq, size, na.rm = T) %>% round(., 1),
                Weighted_MAD = matrixStats::weightedMad(Freq, size, na.rm = T, constant = 1) %>% round(., 2),
                Studies = toString(unique(PMID)),
                country = toString(unique(unlist(str_split(country, ", "))))) %>%
      ungroup() %>%
      filter(!is.na(Frequency))
     
  })

  # create the plot
  thePlot <- reactive({
    req(input$gene)
    req(input$allele)
    
    
    drop_colums <- switch(input$average,
                          "median" = "Weighted",
                          "weighted median"  = "Frequency")
    
   summarized_data() %>% 
      select(-starts_with(drop_colums)) %>%
      select(country_taq, country, Frequency=matches("Weighted\\b|Frequency\\b")) %>% 
      gvisGeoChart(., locationvar='country_taq', colorvar='Frequency', hovervar = "country",
                   options=list(region= df_regions %>% filter(region == input$region) %>% pull(code),
                                projection= input$projection,
                                width = round((input$dimension[1]-100)/12*9),
                                height= round(input$dimension[2]/1.8),
                                keepAspectRatio =F,
                                datalessRegionColor = input$no_value,
                                backgroundColor= input$background,
                                colorAxis=paste0("{minValue: 0,colors:['",input$col_min, "','", input$col_mid1,"','",input$col_mid2,"','", input$col_max,"']}")))
  })
  
  # render the plot
  output$world_map <- renderGvis({thePlot()})
 
  # reset color -------------------------------------------------------------

  observeEvent(input$RESET_COLORS,{
    updateColourInput(session, "col_min", value =  COLORS[1])
    updateColourInput(session, "col_mid1", value = COLORS[2])
    updateColourInput(session, "col_mid2", value = COLORS[3])
    updateColourInput(session, "col_max", value =  COLORS[4])
    updateColourInput(session, "no_value", value = "#f5f5f5")
    updateColourInput(session, "background", value = "white")
  })
  
  
  
  output$mapping <- renderDT({
    read_excel("mapping_file_country_code.xlsx", 1) %>%
      mutate(Population = tolower(Population)) %>% 
      select(Population, Country =country, Alpha2code=country_taq) %>% 
    datatable(.)
  })
    
  
   
 output$rmethod_text <- renderUI({
   p(method_text,style="font-size: 20px;")
  })
  
  
  
} # end server

