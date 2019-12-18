header <- dashboardHeader(title= tagList(icon("globe"), "Worldalleles"))
sidebar <-  dashboardSidebar(
  pickerInput("gene", "Select pharmacogene", sort(result$genes),
              choicesOpt = list(style = rep(("color: black;"),length(result$genes)))),
  uiOutput("ALLLELE"),
  prettyRadioButtons("average", "Aggregating method", choices = c("median", "weighted median")),
   sidebarMenu(
                menuItem("Map & Data", tabName = "Map_Data",icon = icon("far fa-map")),
                menuItem("Raw data", tabName = "raw_data",icon = icon("database")),
                menuItem("Method", tabName = "Method", icon = icon("wrench")))
  )

body <- dashboardBody(
  tags$head(tags$script('var dimension = [0, 0];
                          $(document).on("shiny:connected", function(e) {
                           dimension[0] = window.innerWidth;
                           dimension[1] = window.innerHeight;
                           Shiny.setInputValue("dimension", dimension,  {priority: "event"});});
                          $(window).resize(function(e) {
                           dimension[0] = window.innerWidth;
                           dimension[1] = window.innerHeight;
                           Shiny.setInputValue("dimension", dimension,  {priority: "event"});});')),
  tabItems(
    tabItem(tabName = "Map_Data",
            fluidRow(
              tabBox(width = 12,
                     title = h3(textOutput("allele_name")),
                tabPanel(tagList(icon("globe"), "Map"), 
                         dropdownButton(
                                     selectizeInput("region", "Zoom region", df_regions$region, selected = "World"),
                                     selectizeInput("projection", "Projection type", c("mercator", "albers", "lambert" ,"kavrayskiy-vii")),
                                     h5(strong("Select colors",  style =  "color: #646464;")),
                                     fluidRow(shiny::column(width =3, colourInput("col_min",  h6("Min"),   COLORS[1], showColour = "background")),
                                              shiny::column(width =3, colourInput("col_mid1", h6("Mid1"),  COLORS[2],showColour = "background")),
                                              shiny::column(width =3, colourInput("col_mid2", h6("Mid2"),  COLORS[3],showColour = "background")),
                                              shiny::column(width =3, colourInput("col_max",  h6("Max"),   COLORS[4], showColour = "background"))),
                                     fluidRow(shiny::column(width =3, colourInput("no_value", h6("NA"), "#F5F5F5",
                                                                                  palette = "limited",allowedCols = COLORS_40, showColour = "background")),
                                              shiny::column(width =3, colourInput("background", h6("Background"), "white",
                                                                                  palette = "limited", showColour = "background")),
                                              shiny::column(width =4, br(),br(), actionButton("RESET_COLORS", "Reset"))),
                                                  circle = TRUE, status = "info",
                                                  icon = icon("gear"), width = "300px",

                                                  tooltip = tooltipOptions(title = "Change map settings")),
                         htmlOutput("world_map") %>% withSpinner()),
                tabPanel(tagList(icon("list-alt"), "Data"),
                         dataTableOutput("DT_table")
                         )))),
    tabItem(tabName = "raw_data",
            box(title = tagList(icon("server"),"Raw data"),
                status = "primary",width = 12,solidHeader = T, collapsible = T,
                dataTableOutput("DT_table_rawdata")),
            box(title = tagList(icon("code"), "Mapping population - country"),
                status = "primary",width = 12,solidHeader = T, collapsible = T,
                dataTableOutput("mapping"))), 
  tabItem(tabName = "Method",box(width = 12, 
                                 htmlOutput("rmethod_text"),
                                 help_text))
  ) 
  
)

ui <- dashboardPage(skin = "blue",header, sidebar, body)
