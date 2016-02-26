# open libraries that might be used. 
library(data.table)
library(plyr)
library(dplyr)

# Set home directory to where the unzipped data folder ("UCI HAR Dataset") exists. 
home <- "C:/Users/Steve S/Desktop/coursera data science/course 3 cleaning data/project/UCI HAR Dataset/"
setwd(home)

###############################################################################################
# 1. Merges the training and the test sets to create one data set.
###############################################################################################

# open features.txt with the variable names. These will be the column names for the full ("_all") datasets.
# There are 561 columns
featurefile <- paste(home,"features.txt",sep = "")
features <- read.table(featurefile, header = FALSE, sep = " ")
Cnames <- as.character(features$V2)

# open the original data files, X_train.txt and X_test.txt, and put them into tables (train, test)
trainfile <- paste(home,"train/X_train.txt",sep = "")
testfile <- paste(home,"test/X_test.txt",sep = "")
train <- read.table(trainfile, header = FALSE, col.names = Cnames)
test <- read.table(testfile, header = FALSE, col.names = Cnames)

# open the subject data files, subject_train.txt and subject_test.txt, and put them into tables (trainsubject, testsubject)
# this is a vector containing the number code for the subjects, 1-30, corresponding to the rows for the original data files
trainsubjectfile <- paste(home,"train/subject_train.txt",sep = "")
testsubjectfile <- paste(home,"test/subject_test.txt",sep = "")
trainsubject <- read.table(trainsubjectfile, header = FALSE, col.names = "Subject")
testsubject <- read.table(testsubjectfile, header = FALSE, col.names = "Subject")

# open the activity data files, y_train.txt and y_test.txt, and put them into tables (trainactivity, testactivity)
# this is a vector containing the number code for the activity, 1-6, corresponding to the rows for the original data files
# the codes for the activities are in "activity_labels.txt" and are loaded in later
trainactivityfile <- paste(home,"train/y_train.txt",sep = "")
testactivityfile <- paste(home,"test/y_test.txt",sep = "")
trainactivity <- read.table(trainactivityfile, header = FALSE, col.names = "Activity")
testactivity <- read.table(testactivityfile, header = FALSE, col.names = "Activity")

# first combine the data with the subject code (1st column) and the activity code (2nd column)
# then combine the train and test data into one file, data_all
train_all <- cbind(trainsubject,trainactivity,train)
test_all <- cbind(testsubject,testactivity,test)
data_all <- rbind(train_all,test_all)
write.csv(data_all,file = "data_all.csv")
# Updating Cnames with Subject and Activity names
Cnames <- c("Subject", "Activity", Cnames)

###############################################################################################
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
###############################################################################################

# Initialize the data_extract and Cnames_extract with the Subject code (1st column) and Activity code (2nd column)
Cnames_extract <- c("Subject", "Activity")
data_extract_matrix <- cbind(data_all$Subject, data_all$Activity)

# this is the loop that extracts the columns with the means and standard deviations
for (i in 3:length(Cnames)) {                                   # start loop at 3, first two columns initialized to Subject and Activity
    if ( !is.na(grep("mean\\(",Cnames[i]) || grep("std\\(",Cnames[i])) ) { 
                                                                # look for mean( and std( with 2 grep statement and an OR (||)
                                                                # using mean(  and std( excludes some matches of mean, 
                                                                # such as JerkMean and meanFreq(). These appear to be
                                                                # different measures than what the assignment asks for
        Cnames_extract <- c(Cnames_extract, Cnames[i])          # update Cnames_extract
        data_extract_matrix <- cbind(data_extract_matrix,data_all[,i]) # update data_extract_matrix. 
                                                                # Somehow I think this step is returning a matrix 
    }       
}

###############################################################################################
# 3. Uses descriptive activity names to name the activities in the data set
###############################################################################################

# changing the matrix back into a table, and also allowing the use of the dplyr library
# this fixes creating a matrix table in the code above for step 2
data_extract <- tbl_df(as.data.frame(data_extract_matrix))
colnames(data_extract) <- Cnames_extract

# read in the activity names from activity_labels.txt
activitynamefile <- paste(home,"activity_labels.txt",sep = "")
activitynames <- read.table(activitynamefile, header = FALSE,col.names =c("ActivityNumber",'ActivityName'))

# changing the Activity column from integer to character, keeping the same column location. 
# This sets up the step below to add the character descriptions of the activities
data_extract <- mutate(data_extract,Activity = as.character(Activity))

# This loops through the activity number, n = 6, and replaces the activity codes (now as characters) 
# with the full activity names, from activitynames
for (i in 1:nrow(activitynames)) {
    data_extract$Activity[data_extract$Activity==as.character(i)] <- as.character(activitynames$ActivityName[i])
}

###############################################################################################
# 4. Appropriately labels the data set with descriptive variable names.
###############################################################################################

# information about label codes can be found in features_info.txt
Cnames_extract_descriptive <- Cnames_extract
Cnames_extract_descriptive <- gsub("^t","Time",Cnames_extract_descriptive)
Cnames_extract_descriptive <- gsub("^f","FastFourierTransform",Cnames_extract_descriptive)
Cnames_extract_descriptive <- gsub("Acc","Accelerometer",Cnames_extract_descriptive)
Cnames_extract_descriptive <- gsub("Gyro","Gyroscope",Cnames_extract_descriptive)
Cnames_extract_descriptive <- gsub("Mag","Magnitude",Cnames_extract_descriptive)
Cnames_extract_descriptive <- gsub("std","standarddeviation",Cnames_extract_descriptive)
Cnames_extract_descriptive <- gsub("\\(\\)","",Cnames_extract_descriptive)
Cnames_extract_descriptive <- gsub("-","_",Cnames_extract_descriptive)
colnames(data_extract) <- Cnames_extract_descriptive

# arrange by Subject, then Activity. Write data_extract to csv file
data_extract <- arrange(data_extract, Subject, Activity)
write.csv(data_extract,file = "data_extract.csv")
write.csv(Cnames_extract_descriptive, file = "Cnames_extract.csv")

###############################################################################################
# 5. From the data set in step 4, creates a second, independent tidy data set with the average 
# of each variable for each activity and each subject.
###############################################################################################

# this command works w/o dplyr library
# ddply(data_extract,.(Subject, Activity),summarize, FastFourierTransformBodyAccelerometer_mean_Y = mean(FastFourierTransformBodyAccelerometer_mean_Y) )

# plyr interferes with dplyr group_by function
detach(package:plyr)
# create grouped data set, grouped by Subject and Activity
group_data <- group_by(data_extract,Subject,Activity)

# loop to compute mean values for each measure, grouped by Subject and Activity (group_data)
for (i in 3:length(Cnames_extract_descriptive)) {
  temp <- paste("mean(",Cnames_extract_descriptive[i],")",sep="")    # set up temp to do summarize with mean() and column name
  temp_df <- summarize_(group_data,temp)                             # summarize data by Subject and Activiy, using mean() set by previous line
                                                                     # Note that here the summarize_() function (NOT the summarize() function)
                                                                     # is necessary in order to pass a variable as a column name
  temp_var <- rep(Cnames_extract_descriptive[i],nrow(temp_df))       # create a column with column label
  temp_df <- cbind(temp_df[,1:2],temp_var,temp_df[,3])               # add column with column label 
  colnames(temp_df) <- c("Subject","Activity","Measure","MeanValue") # reset column names
  if (i == 3) {                   
    tidy_data <- temp_df
  } else {
    tidy_data <- rbind(tidy_data,temp_df)
  }
}

# Measure column has both measure and mean_or_standarddeviation coded
# so that column has to be separated, as per tidy data rules
library(tidyr)
tidy_data <- separate(tidy_data,Measure,c("Measure","mean_or_standarddeviation"))

# Create tidy_data_measures file from Cnames_extract_descriptive
# Take out Subject and Activity
tidy_data_measures <- Cnames_extract_descriptive[3:length(Cnames_extract_descriptive)]
# Take out _standarddeviation
tidy_data_measures <- gsub("_standarddeviation","",tidy_data_measures)
# Take out _mean.  This leaves us with 33 pairs of duplicate column names
tidy_data_measures <- gsub("_mean","",tidy_data_measures)
# Take out the duplicates
tidy_data_measures <- unique(tidy_data_measures)

# write tidy_data files
write.csv(tidy_data,file = "tidy_data.csv")
write.csv(tidy_data_measures,file = "tidy_data_measures.csv")






