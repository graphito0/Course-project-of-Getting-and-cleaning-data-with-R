## R script for Getting and Cleaning data project
## Load CRAN modules
library(knitr)
library(plyr)

## Step 1. Download the dataset and unzip it.
## 1.1 Downloading the dataset (Dataset will be saved in  the current working directory )

if(!file.exists("./Project")){dir.create("./Project")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./Project/Dataset.zip")

## 1.2 Unzip the folder.
unzip(zipfile="./Project/Dataset.zip",exdir="./Project")
## List all the files.
path <- file.path("./Project" , "UCI HAR Dataset")
files<-list.files(path, recursive=TRUE)
## All the files will be listed.

## Stpe 2. Reading feature, acticity and subject info.

## 2.1 Read the feature file.
featuretrain<- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)
featuretest  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
## 2.2. Read the activity file.
activitytrain <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)
activitytest  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
## 2.3. Read the subject file.
subjectTrain <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
subjectTest  <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)

## Look at the properties of the above variables

str(featuretrain)
str(featuretest)
str(activitytrain)
str(activitytest)
str(subjectTrain)
str(subjectTest)

## Step 3. Merge the training and test data sets.

## 3.1. Merge  the data tables by rows
Subject <- rbind(subjectTrain, subjectTest)
Activity<- rbind(activitytrain, activitytest)
Feature<- rbind(featuretrain, featuretest)

## 3.2. Give name to the variables
FeatureNames <- read.table(file.path(path, "features.txt"),head=FALSE)
names(Feature)<- FeatureNames$V2
names(Activity)<- c("activity")
names(Subject)<-  c("subject")

## 3.3. Merge all the data into one data frame.
Combine <- cbind(Subject, Activity)
Data <- cbind(Feature, Combine)

## Step 4. Extracting the measurements of mean and std.

## 4.1.Extracting using grep function.
subdataFeature <- FeatureNames$V2[grep("mean\\(\\)|std\\(\\)", FeatureNames$V2)]

## 4.2. Subset the data frame DATA.
selectedNames <- c(as.character(subdataFeature), "subject", "activity" )
Data <- subset( Data , select=selectedNames)

## 4.3. Check the structure of the data frame Data.
str(Data)

## Step 5.Assigning the activity details to the data frame DATA.

## 5.1. Read  activity names from "activity_labels.txt"
activityLabels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)

## 5.2. Assigning Variale activity in the data frame Data using  activity names
Data$activity <- factor(Data$activity,labels=activityLabels[,2])
 
## 5.3. Print the data
head(Data$activity,25)
 
## Step 6. Label the data set with appropriate descriptive variable names.
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

## Step 7. Creates a independent tidy data set
newData<-aggregate(. ~subject + activity, Data, mean)
newData<-newData[order(newData$subject,newData$activity),]
write.table(newData, file = "tidydata.txt",row.name=FALSE,quote = FALSE, sep = '\t')






















