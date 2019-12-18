suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(googleVis))
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(DT))
suppressPackageStartupMessages(library(colourpicker))  
suppressPackageStartupMessages(library(broom))
suppressPackageStartupMessages(library(shinyWidgets))
suppressPackageStartupMessages(library(shinycssloaders))
suppressPackageStartupMessages(library(shinydashboard))
suppressPackageStartupMessages(library(Cairo))
suppressPackageStartupMessages(library(glue))
suppressPackageStartupMessages(library(readxl))

# weighted median function https://stackoverflow.com/questions/2748725/is-there-a-weighted-median-function

# Data --------------------------------------------------------------------
# check mathing country names with geo target and 
# https://en.wikipedia.org/wiki/ISO_3166-1
COLORS <- viridis::viridis(4, direction = -1) %>% gsub("FF", "",.)
COLORS_40 <- c("#000000FF", "#333333FF", "#4D4D4DFF", "#666666FF", "#7F7F7FFF", "#999999FF", "#B3B3B3FF", "#E5E5E5FF",
               "#F5F5F5FF",  "#FFFFFFFF", "#27408BFF", "#000080FF", "#0000FFFF", "#1E90FFFF", "#63B8FFFF", "#97FFFFFF", "#00FFFFFF",
               "#00868BFF", "#008B45FF", "#458B00FF", "#008B00FF", "#00FF00FF", "#7FFF00FF", "#54FF9FFF", "#00FF7FFF",
               "#7FFFD4FF", "#8B4500FF", "#8B0000FF", "#FF0000FF", "#FF6A6AFF", "#FF7F00FF", "#FFFF00FF", "#FFF68FFF",
               "#F4A460FF", "#551A8BFF", "#8B008BFF", "#8B0A50FF", "#9400D3FF", "#FF00FFFF", "#FF1493FF")
# Map settings ------------------------------------------------------------
# region definitions according https://unstats.un.org/unsd/methodology/m49/
df_regions <- tibble(region=c("World", "Africa", "Europe" ,"Asia", "Northern America", "South America","Oceania", "Americas","Western Asia"), 
                     code = c("world", "002", "150", "142", "021", "005","009","019","145")) %>% 
  mutate(index=c(1, rep(2,n()-1))) %>% 
  arrange(index, region) 

result <- readRDS("Frequency_Table_18-12-2019.RDS")

method_text <- glue("Worldwide frequency data is gathered using genetic allele frequency data of the most important functional pharmacogenes available at Pharmgkb. 
First, data was downloaded (accessed {result$access}; https://www.pharmgkb.org/page/pgxGeneRef) and available population information was mapped to a specific country as shown in tab 'Raw data' for each study.   
Data of countries with more than one study available, can be aggregated using a median or a weighted median approach (matrixStats::weightedMedian) using the studies’ cohort sizes as weighting factor.
The shiny application was programmed using R version 3.6.1 (2019-07-05) with the addtional R packages {paste(sort(map_chr(sessionInfo()$otherPkgs, function(x) paste0(x$Package,'_',x$Version))), collapse =', ')}.") 

help_text <- helpText("Questions, bugs, comments?",a("Visit github",href="https://github.com/Jimbou/Worldalleles") ,"or",
                      a("Send me an email",href="mailto:roman.tremmel@ikp-stuttgart.de&subject=Worldalleles"))
cite <- HTML('<a href="https://zenodo.org/badge/latestdoi/228820220"><img src="https://zenodo.org/badge/228820220.svg" alt="DOI"></a>')
