## Synopsis

Document describes the data provided in tiny_data.txt, and the process used to develop it.

## Overview

The data provided in tiny_data.txt is derived from a UCI data set tracking the accelerometers readings from 30  participants as they perfomed one of 6 activities while wearing a smartphone.  Activities were manually labeled: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.

From the UCI data sets, only variables of type Mean or Std (Standard Deviation) were kept, the others were discarded.  Furthermore, as there were multiple observations for each activity performed by a subject, the data was summarized by calculating the mean average for each activity and subject.

## Fields included in tiny_data.txt

activity_group <-- activity label representing this group
subject_group <-- subject id representing this group
timeBodyAccelerationMean-X
timeBodyAccelerationMean-Y
timeBodyAccelerationMean-Z
timeBodyAccelerationStd-X
timeBodyAccelerationStd-Y
timeBodyAccelerationStd-Z
timeGravityAccelerationMean-X
timeGravityAccelerationMean-Y
timeGravityAccelerationMean-Z
timeGravityAccelerationStd-X
timeGravityAccelerationStd-Y
timeGravityAccelerationStd-Z
timeBodyAccelerationJerkMean-X
timeBodyAccelerationJerkMean-Y
timeBodyAccelerationJerkMean-Z
timeBodyAccelerationJerkStd-X
timeBodyAccelerationJerkStd-Y
timeBodyAccelerationJerkStd-Z
timeBodyGyroMean-X
timeBodyGyroMean-Y
timeBodyGyroMean-Z
timeBodyGyroStd-X
timeBodyGyroStd-Y
timeBodyGyroStd-Z
timeBodyGyroJerkMean-X
timeBodyGyroJerkMean-Y
timeBodyGyroJerkMean-Z
timeBodyGyroJerkStd-X
timeBodyGyroJerkStd-Y
timeBodyGyroJerkStd-Z
timeBodyAccelerationMagnitudeMean
timeBodyAccelerationMagnitudeStd
timeGravityAccelerationMagnitudeMean
timeGravityAccelerationMagnitudeStd
timeBodyAccelerationJerkMagnitudeMean
timeBodyAccelerationJerkMagnitudeStd
timeBodyGyroMagnitudeMean
timeBodyGyroMagnitudeStd
timeBodyGyroJerkMagnitudeMean
timeBodyGyroJerkMagnitudeStd
frequencyBodyAccelerationMean-X
frequencyBodyAccelerationMean-Y
frequencyBodyAccelerationMean-Z
frequencyBodyAccelerationStd-X
frequencyBodyAccelerationStd-Y
frequencyBodyAccelerationStd-Z
frequencyBodyAccelerationMeanFreq-X
frequencyBodyAccelerationMeanFreq-Y
frequencyBodyAccelerationMeanFreq-Z
frequencyBodyAccelerationJerkMean-X
frequencyBodyAccelerationJerkMean-Y
frequencyBodyAccelerationJerkMean-Z
frequencyBodyAccelerationJerkStd-X
frequencyBodyAccelerationJerkStd-Y
frequencyBodyAccelerationJerkStd-Z
frequencyBodyAccelerationJerkMeanFreq-X
frequencyBodyAccelerationJerkMeanFreq-Y
frequencyBodyAccelerationJerkMeanFreq-Z
frequencyBodyGyroMean-X
frequencyBodyGyroMean-Y
frequencyBodyGyroMean-Z
frequencyBodyGyroStd-X
frequencyBodyGyroStd-Y
frequencyBodyGyroStd-Z
frequencyBodyGyroMeanFreq-X
frequencyBodyGyroMeanFreq-Y
frequencyBodyGyroMeanFreq-Z
frequencyBodyAccelerationMagnitudeMean
frequencyBodyAccelerationMagnitudeStd
frequencyBodyAccelerationMagnitudeMeanFreq
frequencyBodyAccelerationJerkMagnitudeMean
frequencyBodyAccelerationJerkMagnitudeStd
frequencyBodyAccelerationJerkMagnitudeMeanFreq
frequencyBodyGyroMagnitudeMean
frequencyBodyGyroMagnitudeStd
frequencyBodyGyroMagnitudeMeanFreq
frequencyBodyGyroJerkMagnitudeMean
frequencyBodyGyroJerkMagnitudeStd
frequencyBodyGyroJerkMagnitudeMeanFreq"

## Process for deriving tiny_data.txt

### Step 1: Retrieve raw data zipfile

The file UCI_HAR_Dataset.zip will be downloaded and stored in a class directory.

```
setwd("~/Foundry/coursera/Cleaning_Data")
file_url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file_url, "UCI_HAR_Dataset.zip", method="curl")
```

### Step 2: Unzip raw data zipefile

The file UCI_HAR_Dataset.zip will be unzipped into a direcotry called "UCI HAR Dataset" with numerous raw data files.

```
unzip( zipfile="UCI_HAR_Dataset.zip")
```

### Step 3: Create data frames

The following files will have a data frame created for them: ./activity_labels.txt ./features.txt ./train/subject_train.txt ./train/X_train.txt ./train/y_train.txt ./test/subject_test.txt ./test/X_test.txt ./test/y_test.txt

```
# Feature vector labels
features <- read.table("./UCI HAR Dataset/features.txt")

# Activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# TEST
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_activity <- read.table("./UCI HAR Dataset/test/y_test.txt")
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# TRAIN
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_activity <- read.table("./UCI HAR Dataset/train/y_train.txt")
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
```

### Step 4: Stitch training and test data.  Fix data frame names, ensure factors data types.  Tidy up data by dropping unneeded columns, and replacing activity the human-readable label.

```
# Stitch
all_data <- rbind(test_data, train_data)
all_activity <- rbind(test_activity, train_activity)
all_subject <- rbind(test_subject, train_subject)

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

# Subjects should be factors
wearable_data$subject <- as.factor(wearable_data$subject)

# Clean up variable names
names(wearable_data)<-gsub("[()]", "", names(wearable_data))
names(wearable_data)<-gsub("^t", "time", names(wearable_data))
names(wearable_data)<-gsub("^f", "frequency", names(wearable_data))
names(wearable_data)<-gsub("-std", "Std", names(wearable_data))
names(wearable_data)<-gsub("-mean", "Mean", names(wearable_data))
names(wearable_data)<-gsub("Acc", "Acceleration", names(wearable_data))
names(wearable_data)<-gsub("Mag", "Magnitude", names(wearable_data))
names(wearable_data)<-gsub("BodyBody", "Body", names(wearable_data))
```

### Step 5: Output a tidy_data.txt containing aggregate metrics into a file for consumption

Grouping performed on activity and subject.  Output to file "tidy_data.txt".

```
# Create the aggregated tidy data set
tidy_data = aggregate(wearable_data, by=list(activity_group=wearable_data$activity, subject_group=wearable_data$subject), mean)
str(tidy_data)
tidy_data <- tidy_data %>% select(-subject, -activity)
str(tidy_data)
write.table(tidy_data, file = "tidy_data.txt", row.name=FALSE)
```

## Source Data Set Information:

The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

These signals were used to estimate variables of the feature vector for each pattern:
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag

For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope.
- A 561-feature vector with time and frequency domain variables.
- Its activity label.
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:
=========================================

- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

Notes:
======
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

For more information about this dataset contact: activityrecognition@smartlab.ws


