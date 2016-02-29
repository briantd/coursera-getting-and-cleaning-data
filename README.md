## Overview
Week 4 programming assignment: The script run_analysis.R that loads wearable data, tidys, then outputs an aggregated data frame.

## Pre-requisites
The following path must exist, as a setwd command is included in run_analysis.R:
setwd("~/Foundry/coursera/Cleaning_Data")

## Execution
Open the run_analysis.R script, and being execution.

### Step 1: Retrieve raw data zipfile
The file UCI_HAR_Dataset.zip will be downloaded and stored in the current working directory.

### Step 2: Unzip raw data zipefile
The file UCI_HAR_Dataset.zip will be unzipped into a direcotry called "UCI HAR Dataset" with numerous raw data files.

### Step 3: Create data frames
The following files will have a data frame created for them:
./activity_labels.txt
./features.txt
./train/subject_train.txt
./train/X_train.txt
./train/y_train.txt
./test/subject_test.txt
./test/X_test.txt
./test/y_test.txt

### Step 4: Fix data frame names, ensure factors data types, and tidy up data by dropping unneeded columns, and replacing activity the human-readable label.

### Step 5: Output a tidy_data.txt containing aggregate metrics into a file for consumption



