## Download and unzip the dataset:
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "getdata_dataset.zip")
unzip("getdata_dataset.zip") 

# Load the train, test and subject datasets
trainX <- read.table("./UCI HAR Dataset/train/X_train.txt")
trainY <- read.table("./UCI HAR Dataset/train/Y_train.txt")
trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

testX <- read.table("./UCI HAR Dataset/test/X_test.txt")
testY <- read.table("./UCI HAR Dataset/test/Y_test.txt")
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Load activity labels and features
activityLabels = read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] = as.character(activityLabels[,2])

featuresDetails = read.table("UCI HAR Dataset/features.txt")
featuresDetails[,2] = as.character(featuresDetails[,2])

# Merges the training and the test sets to create one data set.
fullX = rbind(trainX, testX)
fullY = rbind(trainY, testY)
fullSubjects = rbind(trainSubject, testSubject)

# Extracts only the measurements on the mean and standard deviation for each measurement.
featureSubset = featuresDetails[grep("mean\\(\\)|std\\(\\)",featuresDetails[,2]),]
fullX = fullX[,featureSubset[,1]]

# Uses descriptive activity names to name the activities in the data set
colnames(fullY) = "activity"
fullY$activitylabel = factor(fullY$activity, labels = as.character(activityLabels[,2]))
activitylabel = fullY[,-1]

# Appropriately labels the data set with descriptive variable names.
colnames(fullX) = featuresDetails[featureSubset[,1],2]
names(fullX)<-gsub("^t", "time", names(fullX))
names(fullX)<-gsub("^f", "freq", names(fullX))
names(fullX)<-gsub("-mean", "Mean", names(fullX))
names(fullX)<-gsub("-std", "Std", names(fullX))


# From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.
colnames(fullSubjects) = "subject"
allData = cbind(fullX, activitylabel, fullSubjects)
library(plyr);
dataMeasure = aggregate(.~subject + activitylabel, allData, mean)
dataMeasure<-dataMeasure[order(dataMeasure$subject,dataMeasure$activitylabel),]
write.table(dataMeasure, file = "tidydata.txt",row.names = FALSE, col.names = TRUE)
