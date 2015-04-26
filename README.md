### Usage of run_analysis.R script to generate the tidy data set  

The script has been designed and tested to minimize user intervention. This implementation is optimized for Windows in my environment with some security restrictions. A small change in the script may be needed for Linux or Mac to download the zip file using the https with curls protocol.

The user has to first set the working directory, for example:

`setwd("./Getting and Cleaning Data/Project")`

In the working directory copy the run_analysis.R script.

At the R console enter command:

`source("run_analysis.R")`

The script will donwload the data, process it to generate the tidy data set and save it in the local directory as tidy.txt. 

To view the tidy data set type at the console:

`View(tidy)`


