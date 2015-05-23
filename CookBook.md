# Project dataset

The project data were obtained from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones. You can download them [here] (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

The data are recordings of 30 subjects performing activities of daily living while carrying a waist-mounted smartphone with embedded accelerometer and gyroscope. The 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz were captured. The obtained dataset has been randomly partitioned into two sets, where 70% of the subjects was selected for generating the training data and 30% the test data. The sensor signals were pre-processed. A set of variables were estimated from the raw signals. These estimated variables are the starting point for my tidy dataset, not the raw measurements.

I used the following files from the downloaded dataset to create the tidy dataset:

**Training data**
* `.\UCI HAR Dataset\train\X_train.txt` - estimated variables
* `.\UCI HAR Dataset\train\subject_train.txt` - subject ID's
* `.\UCI HAR Dataset\train\y_train.txt` - activity ID's

**Test data**
* `.\UCI HAR Dataset\test\X_test.txt` - estimated variables
* `.\UCI HAR Dataset\test\subject_test.txt` - subject ID's
* `.\UCI HAR Dataset\test\y_test.txt` - activity ID's

**Other**
* `.\UCI HAR Dataset\activity_labels.txt` - labels for the activities
* `.\UCI HAR Dataset\features.txt` - descriptive names for the estimated variables

More information on the dataset and it's variables can be found in `.\UCI HAR Dataset\features_info.txt`.

# Transformations

The first step is to replace one ore more subsequent spaces in `X_test.txt` and `X_train.txt` with a comma using a regular expression. The spaces must be replaced by an alternative delimiter character, otherwise you cannot use `fread`.

In the next step the measurements in each file are read into a `data.table` using the `fread` function, which is very fast! 

Only the columns with names containing std() or mean() are saved into the data.table, because we are only interested in measurements on the mean and standard deviation for each measurement. The column names are altered into more descriptive ones. Also the subject and activity ID's are added.

Subsequently the test and training `data.table` are merged together into one overall `data.table`.

The activity ID's are replaced by the appropriate, descriptive labels.

Finally the average of each variable for each activity and subject is calculated and the tidy dataset is created. I've chosen the long form (in stead of the wide). The tidy dataset is saved as `tidy_dataset.txt`.

# Tidy dataset
The resulting tidy dataset contains four columns:
* subject - the subject's ID
* activity - LAYING, SITTING, STANDING, WALKING, WALKING_DOWNSTAIRS, WALKING_UPSTAIRS 
* variable - the variable (normalized and therefore dimensionless)
* average  - the average of the variable (dimensionless)

The dataset has 11,880 rows: one for each variable for each activity for each subject (66 variables * 6 activities * 30 subjects = 11,880 rows).