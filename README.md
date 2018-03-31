# makeTidyDataCoursera

Course project from the Coursera course "Getting and Cleaning Data". 

Project:
* get the data from the work described here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
* gather the whole data (both train and test datasets)
* extract only the mean and the standard deviation for the different variables in the dataset
* update the name of the variables to be clearer
* replace the integer defining the different activities by a string describing them
* average the variables by activity and subject
* write the tidy dataset

Input:
* https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Detailed information about the input can be found in "UCI HAR Dataset/README.txt" and other realated txt files.
The script will take care of downloading and unzip the input file if not already done.

Script:
* run_analysis.R

Run as: source("run_analysis.R")

Output:
* mytidydata.txt

Output description:
* mytidydata_info.txt

