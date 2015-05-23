## Getting and Cleaning Data

This repository hosts my course project files for [Getting and Cleaning Data](https://www.coursera.org/course/getdata), the third course in Coursera's Data Science Specialization.
It consists of four files:
* `README.md` - this file that describes the contents of the repository
* `run_analysis.R` - the script that performs the analysis
* `CodeBook.md` - a code book that describes the variables, the data, and the transformations that are performed to clean up the data
* `tidy_data.txt` -  a tidy data set (long form) that was created by executing `run_analysis.R` containing the average of each variable for each activity and each subject

Before executing `run_analysis.R` you should download [the data for the project](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) and unzip it into your working directory.
 
Also `sed.exe` should be installed and the directory the executable resides in should be included in the `PATH` environment variable! 
