==================================================================

*1. Original data set

    There are 561 measures in the original data set. The 561 measure 
    names (aka features) can be found in features.txt, and information 
    regarding the measures can be found in features_info.txt. The data 
    are divided into a test set with 30% of the instances (2947 
    instances) and a training set with 70% of the instances (7352 
    instances). 

    Subject identity is coded as a number from 1-30. These codes can 
    be found for each instance in either subject_test.txt or 
    subject_train.txt.

    Activity identity is coded as a number from 1-6. These codes can 
    be found for each instance in either y_test.txt or 
    y_train.txt.  The corresponding labels for the activity codes
    can be found in activity_labels.txt.

    Information about the goals of the study, the data collection,
    and the data pre-processing can be found at:
    [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones]
    and also in the README.txt that the researchers provide.

==================================================================

==================================================================

*2. data_all.csv

    The train and test datasets are combined, in that order, giving
    7352 + 2947 = 10299 instances (or rows). Also, two columns are 
    added in the first two columns, the Subject ID and the Activity ID, 
    giving 563 columns. No other changes are made to the original files.

==================================================================

==================================================================

*3. data_extract.csv

    a. The first step is the extract of all measures describing means 
    and standard deviations.  Specifically, the script looks for 
    strings with "mean(" and "std(". This excludes some matches of 
    mean, such as JerkMean and meanFreq(). These appear to be different 
    measures than what the assignment asks for.  This results in a 
    total of 66 measures.

    b. The next step is the substitution of the Activity code with the
    corresponding label, as described in activity_labels.txt.  The
    codes and the labels are as follows:

| code | label              |
|------|--------------------|
| 1    | WALKING            |
| 2    | WALKING_UPSTAIRS   |
| 3    | WALKING_DOWNSTAIRS |
| 4    | SITTING            |
| 5    | STANDING           |
| 6    | LAYING             |

    c. The final step is the transformation of the column names. 
    Abbreviations are expanded to the full names, as follows:

| Original column name    |    changed to     
|-------------------------|----------------------------|
| Name begins with "t"    |    "Time"                  |
| Name begins with "f"    |    "FastFourierTransform"  | 
| "Acc" appears in name   |    "Accelerometer"         |
| "Gyro" appears in name  |    "Gyroscope"             |
| "Mag" appears in name   |    "Magnitude"             |              
| "std" appears in name   |    "standarddeviation"     |

    For ease of use with R, 
    All parentheses were removed ("(", ")")
    All dashes ("-") were changed to underscores ("_")

    The full set of column names for data_extract.csv can be found in
    Cnames_extract.csv

==================================================================

==================================================================

*4. tidy_data.txt

    a. First, the mean values across time intervals are found, 
    grouped by Subject and Activity.  Thus, for each measure there
    are 30 subjects X 6 activities = 180 instances.

    b. Then, the data were reorganized so that each row had the 
    following format:

    | Subject | Activity | Measure | MeanValue |

    With 66 measures, this gives 180 X 66 rows = 11880 rows X 4 
    columns

    c. Note that "Measure" has 33 pairs of a mean and a 
    standarddeviation measure.  Thus, the column "Measure" is 
    separated into two columns, "Measure" and 
    "mean_or_standarddeviation".  Each final row had the following
    format:

    | Subject | Activity | Measure | mean_or_standarddeviation | MeanValue |

    This gives 11880 rows X 5 columns.  The measure names are as
    follows (also found in tidy_data_measures.csv)

    | TimeBodyAccelerometer_X                           
    | TimeBodyAccelerometer_Y                                 
    | TimeBodyAccelerometer_Z                                 
    | TimeGravityAccelerometer_X                              
    | TimeGravityAccelerometer_Y                              
    | TimeGravityAccelerometer_Z                              
    | TimeBodyAccelerometerJerk_X                             
    | TimeBodyAccelerometerJerk_Y                              
    | TimeBodyAccelerometerJerk_Z                             
    | TimeBodyGyroscope_X                                     
    | TimeBodyGyroscope_Y                                     
    | TimeBodyGyroscope_Z                                     
    | TimeBodyGyroscopeJerk_X                                 
    | TimeBodyGyroscopeJerk_Y                                         
    | TimeBodyGyroscopeJerk_Z                                 
    | TimeBodyAccelerometerMagnitude                           
    | TimeGravityAccelerometerMagnitude                       
    | TimeBodyAccelerometerJerkMagnitude                      
    | TimeBodyGyroscopeMagnitude                              
    | TimeBodyGyroscopeJerkMagnitude                           
    | FastFourierTransformBodyAccelerometer_X                 
    | FastFourierTransformBodyAccelerometer_Y                 
    | FastFourierTransformBodyAccelerometer_Z                 
    | FastFourierTransformBodyAccelerometerJerk_X             
    | FastFourierTransformBodyAccelerometerJerk_Y             
    | FastFourierTransformBodyAccelerometerJerk_Z             
    | FastFourierTransformBodyGyroscope_X                     
    | FastFourierTransformBodyGyroscope_Y                     
    | FastFourierTransformBodyGyroscope_Z                     
    | FastFourierTransformBodyAccelerometerMagnitude          
    | FastFourierTransformBodyBodyAccelerometerJerkMagnitude  
    | FastFourierTransformBodyBodyGyroscopeMagnitude          
    | FastFourierTransformBodyBodyGyroscopeJerkMagnitude      

==================================================================

