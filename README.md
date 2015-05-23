# Data_gathering_proj
Project for gathering and cleaning data class on coursera

##Overview
The run_analysis.R file is a script produced for the Gathering and Cleaning 
Data class on coursera.  We were given the task of demonstrating our 
understanding of tidying, cleaning, and preping, a large data set for
further analysis.  The data set, along with information on said dataset, can be found [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

The script runs five different functions
	1. getData()
		..* makes the working directory, data, and unzips the downloaded data into this directory
	2. dataMerge()
		..* merges training and test data
	3. dataExtract()
		..* subsets the data frame returned by (2)
		..* renames the columns using the names provided in features.txt
	4. dataExport()
		..* writes the final data frame to a txt file in "./data"
		..* Note, that the text file has single space deliminiters
		..* To read into R type dataset <- read.table("./data/tidy_data", sep = " ")
	5. run_analysis()
		..* This is the main function, and calls the other 4 functions in the necessary order



