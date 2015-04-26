# Getting and Cleaning Data - Project

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the 
#    average of each variable for each activity and each subject.


library(data.table)
library(dplyr)


##### read files #####
# download archive
fileUrl<-"http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./temp.zip")
# unzip archive
unzip("temp.zip", files = NULL, list = FALSE, overwrite = TRUE, junkpaths = FALSE, unzip = "internal", setTimes = FALSE)
# remove temporary file
unlink("temp.zip")


##### 1.            merge the training and the test sets                #####
# read data files
Te <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE, strip.white=TRUE)
Tr <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE, strip.white=TRUE)

T <- rbind(Te, Tr)


##### 2.  extract the measurements on the mean and standard deviation   #####
# according to features.txt files, the first 6 recorded variables are:
# 1 tBodyAcc-mean()-X; 2 tBodyAcc-mean()-Y; 3 tBodyAcc-mean()-Z	
# 4 tBodyAcc-std()-X;  5 tBodyAcc-std()-Y;  6 tBodyAcc-std()-Z
# keep only mean and std of body acceleration
T <- T[, 1:6]


##### 3.               name activities in the data set                  #####
# read test activity
Ae <- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE)
# read train activity
Ar <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE)
# row bind activity files
A <- rbind(Ae, Ar)

# convert Activity to factor
A = as.factor(A[,1])

# lables are (see activity_labels.txt):
# 1 WALKING; 2 WALKING_UPSTAIRS; 3 WALKING_DOWNSTAIRS
# 4 SITTING; 5 STANDING; 6 LAYING
# name Activity levels
levels(A) <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", 
  "SITTING", "STANDING", "LAYING")

# read test subject 
Se <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)
# read train subject 
Sr <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)
S <- rbind(Se, Sr)                                                      # overall subjects

# create overall data table
D <- cbind(T, A, S)


##### 4.         label data set with descriptive variable names         #####
# 1 tBodyAcc-mean()-X; 2 tBodyAcc-mean()-Y; 3 tBodyAcc-mean()-Z	
# 4 tBodyAcc-std()-X;  5 tBodyAcc-std()-Y;  6 tBodyAcc-std()-Z
# will name the last columns "Activity" and "Subject"
names(D) <- c("tBodyAccMeanX", "tBodyAccMeanY", "tBodyAccMeanZ", 	# label variables
  "tBodyAccStdX", "tBodyAccStdY", "tBodyAccStdZ", "Activity", "Subject")


##### 5. create a second, independent tidy data set with the average of #####
##### each variable for each activity and each subject                  #####
F <- tbl_df(D)

# create the report file by first grouping rows by Subject and Activity then
# compute the means and standard deviations of each column
tidy <- summarise(group_by(F, Subject, Activity), 
    MeanAccX = mean(tBodyAccMeanX), MeanAccY = mean(tBodyAccMeanY), MeanAccZ = mean(tBodyAccMeanZ), 
    StdAccX = mean(tBodyAccStdX), StdAccY = mean(tBodyAccStdY), StdAccZ = mean(tBodyAccStdZ))

write.table(tidy, "tidy.txt", sep="\t", row.name=FALSE)
