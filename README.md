# Getting and Cleaning Data: Course Project

This is the submission by *Shashwat Kadam* for Getting and Cleaning Data Course project. 

### Problem Statment
Given a dataset for Human Activity Recognition by UCI, apply process on it to obtain a tidy dataset which contains average of each variable for each subject and each activity.

### Dataset
[Human Activity Recognition (HAR) using Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

### Files
- CodeBook.md: A code book that describes the features, the data, and the recipe used to run the analysis.
- run_analysis.R: The R script file which runs the analysis and is the solution for given problem statement.
Following Steps are performed in order:
    - Step 1: Downloading and reading the data into R objects.
    - Step 2: Merging the training and testing data into a single data frame. Appropriately adding the activity labels.
    - Step 3: Extracting only mean and STD measurements for each measurements.
    - Step 4: A dataset is obtained with the average of each variable for each subject and activity.
    - Step 5: The dataset variable names are replaced with more descriptive and readable names. And the resulting 'Tidy dataset' is written on a file.
- Final_Tidy_Data.txt: The txt file containing the final dataset obtained after performing analysis on original HAR dataset.
