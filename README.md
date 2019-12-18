<!--
  Title: Worldalleles
  Description: Shiny App to visualize genetic variability across populations.
  Author: Roman Tremmel
<meta name='keywords' content='ADME, pharmacogenes, allele, frequency, SNP, variant, starallele, pharmvar, pharmgkb'>
  -->
  
## Introduction
Inter-individual variability in drug metabolism can result in adverse drug reactions (ADRs), toxicity or reduced therapy efficacy. Inherited genetic variants in drug-metabolizing enzymes or transporters can explain up to 50% of this variability. Since the occurrence or frequency of the genetic variants in worldwide population shows ethnical and geographical differences, a detailed map visualizing these differences can help to identify regions, countries or subpopulations on risk for ADRs or lack of drug efficacy.
***


## Application
This is a shiny app to visualize genetic variability across worldwide populations of clinically important pharmacogenes according to https://www.pharmgkb.org. Detailed methods are included within the app. 

To run the app, view the newest "stable" version on shinyapps.io:

https://roman-tremmel.shinyapps.io/Worldalleles

or run it via RStudio using:

    runGitHub("rom-trem/Worldalleles")

***

## Instructions
1. Start the app
2. Choose in the sidebar on the left side your desired pharmacogene.
3. Choose your allele of interest.
4. The map shows the aggregated (median or weighted median) frequencies published on https://www.pharmgkb.org/page/pgxGeneRef
5. Click on the blue button in the top left corner of the map to change parameters e.g. world regions, world projections or colors. (Update browser when plot is not occuring or freezed e.g. hitting 'F5') 
6. Under the tab "Data" you find the allelic data as downloadable table.
7. Raw data as well as method description also can be accessed via the tabs in the sidebar on the left. 
8. Limitation: Please be aware that the world frequency data is only as good as the data collected, reviewed and published from PharmGKB 
   (see PMID:2299266 for further details)
