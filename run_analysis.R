# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.
# Review criterialess 
# The submitted data set is tidy.
# The Github repo contains the required scripts.
# GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
# The README that explains the analysis files is clear and understandable.
# The work submitted for this project is the work of the student who submitted it.
# Getting and Cleaning Data Course Projectless 
# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project.
# You will be required to submit:
# 1) a tidy data set as described below,
# 2) a link to a Github repository with your script for performing the analysis,
# and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md.
# You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.
# 
# One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
#   
#   http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# 
# Here are the data for the project:
#   
#   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 
# You should create one R script called run_analysis.R that does the following.
# 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# 1. Retrieve data
setwd("~/Foundry/coursera/Cleaning_Data")
file_url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file_url, "UCI_HAR_Dataset.zip", method="curl")

# 2. Extract files
unzip( zipfile="UCI_HAR_Dataset.zip")
# unzips to "UCI HAR Dataset"

#
# 3. Create data frames
#

# Feature vector labels
features <- read.table("./UCI HAR Dataset/features.txt")

# Activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# TEST
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt")
head(test_data)
test_activity <- read.table("./UCI HAR Dataset/test/y_test.txt")
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# TRAIN
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_activity <- read.table("./UCI HAR Dataset/train/y_train.txt")
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Stitch all observations for data, activity, and subjects
all_data <- rbind(test_data, train_data)
all_activity <- rbind( test_activity, train_activity)
all_subject <- rbind( test_subject, train_subject)

# Fix labels on data
names(all_data) <- features$V2

# Fix activity labels
library(dplyr)
all_activity <- all_activity %>% inner_join(activity_labels, by.x = c("V1", "V1")) %>% select(-V1)
names(all_activity) <- c("activity")

# Fix subject labels
names(all_subject) <- c("subject")

# More stitching, this time collecting different variables into a single frame
data_names <- names(all_data)
keeper_data_names <- grep("std|mean", data_names)
keeper_data <- all_data[keeper_data_names]

wearable_data <- cbind(keeper_data, all_subject, all_activity)
wearable_data$subject <- as.factor(wearable_data$subject)

summary(wearable_data)
head(wearable_data)
str(wearable_data)

# Clean up variable names
names(wearable_data)<-gsub("[()]", "", names(wearable_data))
names(wearable_data)<-gsub("^t", "time", names(wearable_data))
names(wearable_data)<-gsub("^f", "frequency", names(wearable_data))
names(wearable_data)<-gsub("-std", "Std", names(wearable_data))
names(wearable_data)<-gsub("-mean", "Mean", names(wearable_data))
names(wearable_data)<-gsub("Acc", "Acceleration", names(wearable_data))
names(wearable_data)<-gsub("Mag", "Magnitude", names(wearable_data))
names(wearable_data)<-gsub("BodyBody", "Body", names(wearable_data))

str(wearable_data)

head(wearable_data)
tidy_data = aggregate(wearable_data, by=list(activity_group=wearable_data$activity, subject_group=wearable_data$subject), mean)
str(tidy_data)
tidy_data <- tidy_data %>% select(-subject, -activity)
str(tidy_data)
write.table(tidy_data, file = "tidy_data.txt", row.name=FALSE)
