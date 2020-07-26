library(dplyr)

download_and_extract <- function(URL, filename) {
    if(!file.exists(filename)) {
        download.file(URL, filename, method="curl")
    }
    if(!file.exists(DATA_DIR)) {
        unzip(filename)
    }
}

#================= Auxilliary functions ========================

read_data <- function(path) {
    read.table(path)
}

# To read the names of features from 'features.txt'
read_feature_names <- function(feature_file_path) {
    read.table(feature_file_path,
               header=FALSE,
               sep=" ",
               col.names = c("feature_number", "feature_name"))
}

# To read subject list from a subject file
read_train_subjects <- function(subject_file_path) {
    read.table(subject_file_path,
               header=FALSE,
               sep=" ",
               col.names = c("subject"))
}

# To read activity labels from 'activity_labels.txt'
read_activity_types <- function(activity_label_file) {
    read.table(activity_label_file,
               header=FALSE,
               sep=" ",
               col.names = c("activity_label", "activity_name"))
}

# Binds the 561 features with activity labels and subjects. i.e. Merge 'X' and 'y' part
merge_X_and_y <- function(Xfile, yfile, subject_file, activity_label_file, feature_file_path) {
    subjects <- read_train_subjects(subject_file)
    X <- read.table(Xfile, header=FALSE, sep="")
    feature_names <- read_feature_names(feature_file_path)
    names(X) <- feature_names$feature_name
    y <- read.table(yfile, header=FALSE, sep=" ", col.names = c("activity_label"))
    activities <- read_activity_types(activity_label_file)
    y <- sapply(y, function(x) activities[x, "activity_name"])
    cbind(subjects, y, X)
}

# Merge the training and testing data blocks into one block
merge_train_and_test <- function(train_data_block, test_data_block) {
    rbind(train_data_block, test_data_block)  
}
                
#===================== Analysis =============================

# Download and extract the data

save_as <- "Week4_project_data.zip"
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download_and_extract(URL, save_as)

# Set all the file paths relative to Data directory: UCI HAR Dataset
DATA_DIR <- paste0(getwd(), "/UCI HAR Dataset")
X_train_path <- paste0(DATA_DIR, "/train/X_train.txt")
y_train_path <- paste0(DATA_DIR, "/train/y_train.txt")
X_test_path <- paste0(DATA_DIR, "/test/X_test.txt")
y_test_path <- paste0(DATA_DIR, "/test/y_test.txt")
subject_train_path <- paste0(DATA_DIR, "/train/subject_train.txt")
subject_test_path <- paste0(DATA_DIR, "/test/subject_test.txt")
activity_file_path <- paste0(DATA_DIR, "/activity_labels.txt")
feature_file_path <- paste0(DATA_DIR, "/features.txt")

training_data <- merge_X_and_y(X_train_path,
                               y_train_path,
                               subject_train_path,
                               activity_file_path,
                               feature_file_path)

testing_data <- merge_X_and_y(X_test_path,
                              y_test_path,
                              subject_test_path,
                              activity_file_path,
                              feature_file_path)

total_data <- merge_train_and_test(training_data, testing_data)

# Selecting only those feature names which contains mean() OR std()
# Also select the 'subject' and 'activity_label' column
sub_data <- total_data[, grep("-mean()|-std()|subject|activity_label", 
                              names(total_data),
                              value=TRUE)]

groups <- group_by(sub_data, subject, activity_label)
final_output <- summarise_all(groups, funs(mean))

# Making the variable names TIDY
names(final_output) <- gsub("^t", "Time_", names(final_output))
names(final_output) <- gsub("^f", "Freq_", names(final_output))
names(final_output) <- gsub("Acc", "Accelerometer_", names(final_output))
names(final_output) <- gsub("Gyro", "Gyroscope_", names(final_output))
names(final_output) <- gsub("BodyBody", "Body", names(final_output))
names(final_output) <- gsub("Body", "Body_", names(final_output))
names(final_output) <- gsub("Gravity", "Gravity_", names(final_output))
names(final_output) <- gsub("Mag", "Magnitude_", names(final_output))
names(final_output) <- gsub("-mean()", "Mean", names(final_output))
names(final_output) <- gsub("-std()", "Std", names(final_output))
# print(names(final_output))
# head(final_output, n=15)
# str(final_output)

# Writing the tidy dataset
write.table(final_output, "Final_Tidy_Data.txt", row.name=FALSE)
