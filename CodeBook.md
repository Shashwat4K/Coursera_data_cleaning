<p> The R script <code>run_analysis.R</code> downloads the <a href="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip">original dataset</a> from the internet and performs following steps to get a tidy dataset</p>

1. **Downloading the dataset**:
  Using <code>file.download()</code> the ZIP file is downloaded and then unzipped to get all the original files.
2. **Reading original data**:
    - features.txt (561 rows, 2 columns) : The names of variables in training/testing datasets. (Names of the columns)
    - activity_labels.txt (6 rows, 2 columns): The list of activities performed by the subjects. 
    - train
      - train/subject_train.txt (7352): The subjects which were included in the training dataset. 
      - train/X_train.txt (7352 rows, 561 columns): The recorded values of every features from 'features.txt', for each subject in 'subject_train.txt'
      - train/y_train.txt (7352): The activity label for each recorded vector.
    - test
      - test/subject_test.txt (2947): The subjects which were included in the testing dataset.
      - test/X_test.txt (2947 rows, 561 columns): The recorded values of every features from 'features.txt', for each subject in 'subject_test.txt'
      - test/y_test.txt (2947): The activity label for each recorded vector.

3. **Creating training and testing datasets**:
   Since the training instances and labels are in different files, we need to combine them, along with the column of 'subject'. Using <code>cbind()</code> we can combine the *X* and *y* part of the dataset. While doing so, we will replace the values of tha activity label in *y* with their appropriate values from *activity_labels.txt*.
   This process is done for both training and testing data. The two resulting blocks are combined using <code>rbind()</code> into one big data block named 'total_data'

4. **Extracting only the measurements of mean() and std()**:
    There are total 561 variables in total. These variables are actually obtained by applying functions such as min(), max(), mean(), std(), etc. We are required to extract only those measurements on the mean and standard deviation for each measurement. More information will be obtained by reading *features_info.txt*.
    Using <code>grep()</code> we can easily find out which variable names contain *mean* and *std*. We will then subset the *total_data* using only those column names.

5. **Calculating average of each variable for each activity and each subject**: 
    The <code>dplyr</code> library is loaded. The subsetted date from step 4 (sub_data) is grouped w.r.t the subject and activity label using <code>group_by()</code>. The the grouped data is passed to the <code>summarise_all()</code> and <code>mean()</code> is applied. 
    
6. **Replacing original variable names with more descriptive names**:
    The variable names (features) provided with the dataset are kind of difficult to read, thus to improve readability, we will substitute variable names with more informative names. <code>gsub()</code> function is helpful to substitute a specific pattern with another pattern or string.
   
7. **Writing the output on file**
    After all the processing, the output dataframe is written on a file using <code>write.table()</code>.
