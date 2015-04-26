## Getting and Cleaning Data Project Codebook
Describes the variables, the data, and any transformations or work performed to clean up the data.

### Variables
According to the features.txt file the first 6 recorded variables are:

Column | Variable Name
-------|------------------
   1   | tBodyAcc-mean()-X
   2   | tBodyAcc-mean()-Y
   3   | tBodyAcc-mean()-Z
   4   | tBodyAcc-std()-X
   5   | tBodyAcc-std()-Y
   6   | tBodyAcc-std()-Z


Other variables that may have some value for this study therefore may be included here are:

Column | Variable Name
-------|-------------------
  121  | tBodyGyro-mean()-X
  122  | tBodyGyro-mean()-Y
  123  | tBodyGyro-mean()-Z
  124  | tBodyGyro-std()-X
  125  | tBodyGyro-std()-Y
  126  | tBodyGyro-std()-Z

I decided to include only the first set to make the file easily readable. For future needs the script can be changed to generate the updated tidy set.

All acceleration variables maintain the original units (standard gravity units 'g'). 

Other variables are Activity, and Subject. Both of these variables are treated as levels and used for clasification purposes. 

Activity can have values of: 

Coding | Variable Name
-------|---------------------
   1   |  "WALKING"
   2   |  "WALKING_UPSTAIRS"
   3   |  "WALKING_DOWNSTAIRS"
   4   |  "SITTING"
   5   |  "STANDING"
   6   |  "LAYING" 

The Subject can have values from 1 to 30.

### Data
#### Initial and Work in progress Data
Te contains the test/X_test.txt file, test acceleration data.
Tr contains the test/X_train.txt file, train acceleration data.
T is the file resulted from binding together Te, Tr. Only columns 1 to 6 are retained.

Se contains the test/subject_test.txt file, test Subject info.

Sr contains the train/subject_train.txt, train Subject info.

S is the file resulted from bindind together Se, Sr.                                                      


Ae contains the test/y_test.txt, test Activity info.

Ar contains the train/y_train.txt, train Activity info.

A is the file resulted from binding together Ae, Ar.

D is the overall data table and F the result of the tbl_df conversion.

The end result is the tidy data set containing the average of each variable for each activity and each subject.

#### Processed Data
The processed data is stored in the tidy set.

### Transformations to clean the data
#### Get the archive from the internet
Download archive

`fileUrl<-"http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./temp.zip")`

Unzip archive

`unzip("temp.zip", files = NULL, list = FALSE, overwrite = TRUE, junkpaths = FALSE, unzip = "internal", setTimes = FALSE)`

Remove temporary file

`unlink("temp.zip")`

#### 1. Merge the training and the test sets
Read data files

`Te <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE, strip.white=TRUE)
Tr <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE, strip.white=TRUE)`

Row bind the two data files

`T <- rbind(Te, Tr)`

#### 2. Extract the measurements on the mean and standard deviation
Keep only mean and std of body acceleration

`T <- T[, 1:6]`

#### 3. Name activities in the data set
Read test activity

`Ae <- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE)`

Read train activity

`Ar <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE)`

Row bind activity data

`A <- rbind(Ae, Ar)`

Convert Activity to factor

`A = as.factor(A[,1])`

Name Activity levels

`levels(A) <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", 
  "SITTING", "STANDING", "LAYING")`

Read test subject

`Se <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)`

Read train subject

`Sr <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)`

Create overall subjects by row binding the two sets

`S <- rbind(Se, Sr)`

Create overall data table

`D <- cbind(T, A, S)`

At this time all temporary data sets can be deleted keeping only D.

#### 4. Label data set with descriptive variable names
Change variable names as tBodyAcc-meanX, tBodyAcc-meanY, tBodyAcc-meanZ,  
tBodyAcc-stdX, tBodyAcc-stdY, tBodyAcc-stdZ, Activity and Subject

`names(D) <- c("tBodyAccMeanX", "tBodyAccMeanY", "tBodyAccMeanZ", 	# label variables
  "tBodyAccStdX", "tBodyAccStdY", "tBodyAccStdZ", "Activity", "Subject")`

#### 5. Create the tidy data set
The tidy data set contains the average of each variable for each activity and each subject

First convert the overall data table to the tbl_df format required by dplyr

`library(dplyr)
F <- tbl_df(D)`

Create the report file by first grouping rows by Subject and Activity then compute the means and standard deviations of each column

`tidy <- summarise(group_by(F, Subject, Activity), 
    MeanAccX = mean(tBodyAccMeanX), MeanAccY = mean(tBodyAccMeanY), MeanAccZ = mean(tBodyAccMeanZ), 
    StdAccX = mean(tBodyAccStdX), StdAccY = mean(tBodyAccStdY), StdAccZ = mean(tBodyAccStdZ))`
    
Write the data to the tidy.txt file

`write.table(tidy, "tidy.txt", sep="\t", row.name=FALSE)`

