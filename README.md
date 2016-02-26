1. Original data source:

    Human Activity Recognition Using Smartphones Dataset, Version 1.0
    Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
    Smartlab - Non Linear Complex Systems Laboratory
    DITEN - Università degli Studi di Genova.
    Via Opera Pia 11A, I-16145, Genoa, Italy.
    activityrecognition@smartlab.ws
    www.smartlab.ws

    The data were collected with 30 volunteers within an age bracket 
    of 19-48 years. Each person performed six activities (WALKING, 
    WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) 
    wearing a smartphone (Samsung Galaxy S II) on the waist.  Using
    the phone's accelerometer and gyroscope, the researchers recorded
    3-axial linear acceleration and 3-axial angular velocity at a 
    constant rate of 50Hz.  The goal of the researchers' analysis was
    to identify the activity of the volunteers from data collected
    from the phone.  More information about the study may be found at:
    http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
    and also in the README.txt that the researchers provide.

    The dataset has 10299 instances or examples of data; these were
    divided randomly into a test set with 30% of the instances (2947
    instances) and a training set with 70% of the instances (7352 
    instances).  Each instance is comprised of 561 measures (also 
    called attributes or features) derived from the measurements from
    the phone.  A full list of the features can be found in 
    features.txt, and a description of the features can be found in
    features_info.txt.

2. Brief description of the data processing:

    The script run_analysis.R takes the original files from the Human 
    Activity Recognition Using Smartphones Dataset, consolidates the
    data into one file (data_all.csv).  It then creates 
    data_extract.csv, consisting of the mean and standard deviation
    measures from the original set of 561 measures (66 measures), the
    full activity labels, and the full column names.  Finally, the 
    script creates a 'tidy' dataset (tidy_data.txt) with the mean 
    values for each measure, grouped by Subject and Activity. The 
    final tidy set of data has 66 measures (33 X 2 for either mean or 
    standard deviation).

    The file data_all.csv combines the test and train data set into 
    one file.  It also adds the information of subject identity and 
    activity id for each instance from the corresponding text files 
    (i.e., subject: subject_test.txt, subject_train.txt; activity:
    y_test.txt, y_train.txt).  Thus, data_all.txt has 2947 (test) + 
    7352 (train) = 10299 rows and 561 measures + 2 (Subject, 
    Activity) = 563 columns.  

    The file data_extract.csv has the mean and standard deviation
    measures extracted from the data_all.csv data set. It has 10229 
    rows and 66 measures + 2 (Subject + Activity) = 68 columns.
    Also, the activity codes have been replaced with the activity 
    labels. Finally, the column names have been expanded to their 
    full names (as described in Codebook.md), have the parentheses 
    removed, and have the dashes (-) changed to underscores (_). 

    The file Cnames_extract.csv has the column names for the columns 
    found in data_extract.csv.

    The file tidy_data.txt transforms the data in data_extract.csv.
    First the mean is computed for each measure, grouped by
    Subject and Activity.  Then, note that the 66 measures in
    data_extract.csv are in 33 pairs of mean and standarddeviation
    for the same base measure.  Thus, the Measure column was 
    separated into a Measure column and a mean_or_standarddeviation
    column.  The final format of each row of tidy_data.txt:

    Subject | Activity | Measure | mean_or_standarddeviation | MeanValue

    There are 30 subjects X 6 activities X 33 measures X 2 mean_or_
    standarddeviation rows = 11880 rows.

    The file tidy_data.csv has the names of the 33 measures in
    tidy_data.csv.

3. Original files needed for this analysis (when applicable, 
rows X columns):
|---------------------------------------------------------------------|
|    features.txt            : full list of features (561 features)   |
|    train/X_train.txt       : data for train set (2947 X 561)        |
|    train/y_train.txt       : activity code for each train instance  | 
|                             (2947 codes)                            |
|    train/subject_train.txt : subject code for each train instance   |
|                             (2947 codes)                            |
|    test/X_test.txt         : data for train set (7352 X 561)        | 
|    test/y_test.txt         : activity code for each test instance   |
|                              (7352 codes)                           |
|    test/subject_test.txt   : subject code for each test instance    | 
|                              (7352 codes)                           |
|    activity_labels.txt     : labels corresponding to activity codes |
|                              (6 labels)                             |

4. Files produced by this analysis (when applicable, rows X columns): 
|-------------------------------------------------------------------------|
|   data_all.csv            : combined data across x_train.txt,           |
|                              y_train.txt, subject_train.txt,            |
|                              x_test.txt, y_test.txt, subject_test.txt,  |
|                              activity_labels.txt (10299 X 563)          | 
|    data_extract.csv        : mean and standard deviation measures       |
|                              extracted from data_all.csv (10299 X 68)   | 
|    Cnames_extract.csv      : column names in data_extract.csv (68       |
|                              names)                                     |
|    tidy_data.txt           : tidy data set from data_extract (11880 X   |
|                              5)                                         |
|    tidy_data_measures.csv  : Measures in tidy_data.csv (33 measures)    |

