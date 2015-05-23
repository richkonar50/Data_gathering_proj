
# This first funtion checks if the user has the necessary files
# if he/she does not this function downloads the file and puts
# it into a newly created directory.



getData <- function (){
  if(!file.exists("./data")){
    dir.create("./data")
    #setwd("data")
  }
  #setwd("data")
  if(file.exists("./getdata_projectfiles_UCI HAR Dataset.zip")){
    unzip("./getdata_projectfiles_UCI HAR Dataset.zip", overwrite = TRUE, exdir = "./data")
  }
  else if(file.exists("./data/UCI HAR Dataset")){
    print("You have the necessary files already")
  }
  else{
    destFile <- "./data/data.zip"
    if(!file.exists(destFile)){
      URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      download.file(URL, destfile = destFile, method = "curl")
    }
    unzip(destFile, overwrite = TRUE, exdir = "./data")
  }
  print("Data obtained")
}


# This function reads in all the necessary files and then
# merges all of them into one data frame
dataMerge <- function(){
  print("Merging data...")
  xTest <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
  yTest <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
  subTest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
  test.df <- cbind(xTest,subTest)
  test.df <- cbind(test.df, yTest)
  
  xTrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
  yTrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
  subTrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
  train.df <- cbind(xTrain,subTrain)
  train.df <- cbind(train.df, yTrain)
  
  final.df <- rbind(train.df, test.df)
  print("Data Merged.")
  return(final.df)
}

#this function cleans up the data and makes it more presentable

dataExtract <- function(final.df) {
  
  features <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
  feature_refine <- grep("*mean*|*std*", features[,2], ignore.case = TRUE)
  varRefine <- c()
  
#   This first for loop is to make a vector with the actual
#   names of the columns instead of V1,V2, etc
#   
  for(i in 1:length(feature_refine)){
    varRefine[i] <- features[feature_refine[i],2]
  }
  
#   next we subset the merged data frame to a new data frame
#   that only has the the column variables we are interested in

  newData <- final.df[feature_refine]
  newData2 <- final.df[,562]
  newData3 <- final.df[,563]
  newData4 <- cbind(newData2,newData)
  newData5 <- cbind(newData3,newData4)



  #This next for loop gives newData5 the appropriate col names
  char <- c("Activity", "Subject", varRefine)
  colnames(newData5) <- char

  #Here we assign the Activity column entries more descriptive names

  for(i in 1:nrow(newData5)){
    if(newData5[i,1] == 1) newData5[i,1] <- "Walking"
  }
  
for(i in 1:nrow(newData5)){
  if(newData5[i,1] == 2) newData5[i,1] <- "Walking_Upstairs"
}

for(i in 1:nrow(newData5)){
  if(newData5[i,1] == 3) newData5[i,1] <- "Walking_Downstairs"
}

for(i in 1:nrow(newData5)){
  if(newData5[i,1] == 4) newData5[i,1] <- "Sitting"
}

for(i in 1:nrow(newData5)){
  if(newData5[i,1] == 5) newData5[i,1] <- "Standing"
}

for(i in 1:nrow(newData5)){
  if(newData5[i,1] == 6) newData5[i,1] <- "Laying"
}

newData5[,1] <- as.factor(newData5[,1])
newData5[,2] <- as.factor(newData5[,2])

# Here we require the reshape 2 package so we can melt our
# data frame and recast with dcast
require(reshape2)

dataMelt <- melt(newData5, id = c("Activity","Subject"))

# here we invoke dcast in order to get the mean of the variables
# by group Activity and Subject
reCast <- dcast(dataMelt, Activity+Subject~variable, mean)

return(reCast)

  
  
}


#This function writes our new data frame to a text file
dataExport <- function(dataFrame){
  print("Writting data to text file...")
  destFile <- "./data/tidy_data.txt"
  write.table(dataFrame, file = destFile, sep = " ")
  print("Done.")
}

#This is our main function that runs the entire prcoess
run_analysis <- function(){
  getData()
  dataFrame <- dataMerge()
  dataFrame.ext <- dataExtract(dataFrame)
  dataExport(dataFrame.ext)
}

























