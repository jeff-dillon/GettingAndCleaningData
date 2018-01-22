# Getting and Cleaning Data Course Project
# Author: Jeff Dillon
# This script works on the "Human Activity Recognition Using Smartphones Dataset" 
# published by Smartlab.
# Merges the training and the test sets to create one data set. Extracts only the 
# measurements on the mean and standard deviation for each measurement. Uses 
# descriptive activity names to name the activities in the data set Appropriately 
# labels the data set with descriptive variable names. From the data set in step 4, 
# creates a second, independent tidy data set with the average of each variable for 
# each activity and each subject.

#
#
# REQUIRED LIBRARIES
#
#

library(dplyr)
library(tidyr)



#
#
# FUNCTION DEFINITIONS
#
#

LoadDataSet <- function(setLabel) {
    # Loads the data set (x, y, and subject files), sets columns names, 
    # and returns the consolidated data set. 
    #
    # Args: 
    #   setLabel: the name of the data set to load. Either "test" or "train"
    #
    # Returns:
    #   Consolidated dataframe with column names
    
    # Error handling
    if(!(setLabel == "test" | setLabel == "train")) {
        stop("Argument setLabel must be either 'test' or 'train'.")
    }
    
    # build out directory and file name variables
    mainDirectory <- "UCI HAR Dataset"
    dataSetDirectory <- setLabel
    observationFileName <- paste("x_", setLabel, ".txt", sep = "")
    activityFileName <- paste("y_", setLabel, ".txt", sep = "")
    subjectFileName <- paste("subject_", setLabel, ".txt", sep = "")
    featuresFileName <- "features.txt"
    activityLabelsFileName <- "activity_labels.txt"
    
    # load the features and set the column names
    features <- read.table(file.path(mainDirectory, 
                                     featuresFileName))
    names(features) <- c("ID","ColName")
    
    # load the activity labels and set the file names
    activityLabels <- read.table(file.path(mainDirectory, 
                                           activityLabelsFileName))
    names(activityLabels) <- c("ID", "Value")
    
    # load the observations, set the column names, add an ID column for merging, 
    # add a column indicating the source data set.
    observations <- read.table(file.path(mainDirectory, 
                                         dataSetDirectory, 
                                         observationFileName))
    names(observations) <- features$ColName
    observations$ObsID <-seq.int(nrow(observations))
    observations$set <- c(setLabel)
    
    # load the activities, set the column names, add an ID column for merging, 
    # add a column with the label of the activity code.
    activities <- read.table(file.path(mainDirectory, 
                                       dataSetDirectory, 
                                       activityFileName))
    activities$ObsID <-seq.int(nrow(activities))
    names(activities) <- c("activityCode","ObsID")
    activities$activityLabel <- activityLabels$Value[activities$activityCode]
    
    # load the subjects, set the column names, add an ID column for merging,
    # and make the subject column a factor
    subjects <- read.table(file.path(mainDirectory, 
                                     dataSetDirectory, 
                                     subjectFileName))
    subjects$ObsID <-seq.int(nrow(subjects))
    names(subjects) <- c("subject","ObsID")
    subjects$subject <- factor(subjects$subject)
    
    # merge the activities and subjects into a new data frame
    cleanData <- merge(subjects,
                     activities,
                     c("ObsID", "subject", "activityLabel"),
                     by.x = "ObsID",
                     by.y = "ObsID")

    # merge the observations into the newly created data frame
    cleanData <- merge(cleanData,
                     observations,
                     by.x = "ObsID",
                     by.y = "ObsID")
    
    # return the columns of the newly created data frame that we are interested in
    select(cleanData, 
           "subject", 
           "activityLabel", 
           grep("mean\\(|std", 
                names(observations), 
                value = TRUE))
    
}

SummarizeDataSet <- function(originalDataSet) {
    # Takes a dataset reutrned by LoadDataSet and returns 
    # another dataset that is summaraize (mean) by subject and activityLabel.
    #
    # Args:
    #   originalDataSet: the data frame to be summarized
    #
    # Returns: 
    #   A data frame with the mean of each variable for each activity and each subject

    # Error handling
    if(!(class(originalDataSet) == "data.frame")) {
        stop("Argument 'originalDataSet' must be of class 'data.frame'")
    }
    
    originalDataSet %>%
        group_by(activityLabel, subject) %>%
        summarise_all(mean)
}





#
#
# ANALYSIS SCRIPT
#
#

# Generate the tidy data set contining all test and train data and write it to disk
allData <- rbind(LoadDataSet("test"), 
                 LoadDataSet("train"))
write.table(allData, 
            file = "HAR_All.txt", 
            quote = FALSE, 
            row.names = FALSE)

# Summarize the tidy data set and write the summary to disk
write.table(SummarizeDataSet(allData), 
            "HAR_Summary.txt", 
            quote = FALSE, 
            row.names = FALSE)

# clean up the environment
rm(allData)
