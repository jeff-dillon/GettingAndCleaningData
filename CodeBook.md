# CodeBook for run_analysis.R script
This CodeBook describes the process used to clean up the "Human Activity Recognition Using Smartphones Dataset" published by Smartlab.

## Data
The original data set contained three files for observations (x_), subjects (subject_), and activities (y_) split across two data sources ("test", "train"). The data set also contained a file listing all of the column names for the observations file (features.txt), and a file with key-value pairs for each type of activity (activity_labels.txt).

## Variables
- subject: the identifier of the subject of the observation
- activityLabel: the activity label for the observation
- multiple mean and std variables: the mean and standard deviation values of the observation

## Transformations
### Data Set Transformations
1. This script combines the columns from the three data files in each data source into a single data set. 
2. This script combines the data sets from each data source into a single data set.
3. This script applies descriptive column names to the resulting data set.
4. This script adds a column (activityLabel) to indicate the type of activity for each observation.

### Variable Transformations
- subject: changed from int to factor
- activityLabel: derived from activity_labels.txt
- mean and standard deviation variables: none for full data set - mean by activity/subject for summary data data set

## Processing
1. This script loads data from the test and train data sources.
2. This script creates a file "HAR_All.txt" with the full tidy data set.
3. This script creates a file "HAR_Summary.txt" with the summarized tidy data set.
4. This script removes environment variables.