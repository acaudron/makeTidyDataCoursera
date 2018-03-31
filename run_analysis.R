#Script to get the original data and create a new tidy dataset

#get the original data and unzip them if not already done
if(!file.exists("originalDatasets.zip")){
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "originalDatasets.zip")
  unzip("originalDatasets.zip")
}

#get the datasets
library(data.table)
train <- fread("UCI HAR Dataset/train/X_train.txt")
activityTrain <- fread("UCI HAR Dataset/train/y_train.txt")
subjectTrain <- fread("UCI HAR Dataset/train/subject_train.txt")
alltrain <- cbind(subjectTrain, activityTrain, train)

test <- fread("UCI HAR Dataset/test/X_test.txt")
activityTest <- fread("UCI HAR Dataset/test/y_test.txt")
subjectTest <- fread("UCI HAR Dataset/test/subject_test.txt")
alltest <- cbind(subjectTest, activityTest, test)

#merge the two datasets
alldata <- rbind(alltrain, alltest)

#get the feature labels and use them to rename the data colomns
features <- fread("UCI HAR Dataset/features.txt")
names(alldata) <- append(append("subject", "activity"), features$V2) #add by hand the first two colomn names

#get the mean and std colomns to keep (also keep the subject and activity colomns)
keep <- as.list(features[grepl('mean()', features$V2, fixed = TRUE) | grepl('std()', features$V2), "V2"])[[1]]
keep <- append(append("subject", "activity"), keep)
tidydata <- alldata[,keep, with=FALSE]

#replace the integer in the activity colomn by the corresponding name
activityLabels <- fread("UCI HAR Dataset/activity_labels.txt")
tidydata[,activity := sapply(tidydata$activity, function(x) x<-activityLabels[V1==x,as.character(V2)])]

#update the feature names to them slightly clearer
updateFeatureNames <- function(x){
  x <- sub("tBody", "inTimeBody", x)
  x <- sub("tGravity", "inTimeGravity", x)
  x <- sub("fBodyBody", "fBody", x) #correct a mistake in few feature names
  x <- sub("fBody", "frequencyBody", x)
  x <- sub("fGravity", "frequencyGravity", x)
  x <- sub("Acc", "Acceleration", x)
  x <- sub("Gyro", "AngularVelocity", x)
  x <- sub("Jerk", "JerkSignal", x)
  x <- sub("Mag", "Magnitude", x)
  x
}
names(tidydata) <- unlist(lapply(names(tidydata), updateFeatureNames))

#final dataset averaging by activity and by subject
library(dplyr)
finaldata <- tidydata %>% group_by(activity, subject) %>%  summarise_all (funs(mean))

#write the dataset
write.table(finaldata, "mytidydata.txt", row.names = FALSE)