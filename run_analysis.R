####################################
###         Load packages        ###
####################################

library(data.table)
library(reshape)
library(plyr)

####################################
###      Read column names       ###
####################################

columns <- read.table("./UCI HAR Dataset/features.txt", col.names = c("id", "name"), colClasses = c("integer", "character"))
columns <- columns[grep("std\\(\\)|mean\\(\\)", columns$name), ]

####################################
###      Read measurements       ###
###     (training and test)      ###
####################################

############################################################################
### Function: readData                                                   ###
###                                                                      ###
### Description:                                                         ###
### Reads dataset with training or test measurements into a data.table   ###
###                                                                      ###
### Arguments:                                                           ###
### set -  Dataset (training or test)                                    ###
###                                                                      ###
### Returns:                                                             ###
### data.table containing the measurements of the specified set,         ###
### including subject and activity ID's, and descriptive column names    ###
###                                                                      ###
### Note:                                                                ###
### sed.exe should be installed and the install directory should be      ###
### included in the Windows PATH environment variable!                   ###
### sed.exe comes with the git installation (git/bin/sed.exe).           ###
############################################################################

readData <- function(set){
    
    cmd <- paste("'s/^[[:blank:]]*//;s/[[:blank:]]\\{1,\\}/,/g' './UCI HAR Dataset/", set, "/X_", set, ".txt'", sep = "")
    subjectFile <- paste("./UCI HAR Dataset/", set, "/subject_", set, ".txt", sep = "")
    activityFile <- paste("./UCI HAR Dataset/", set, "/Y_", set, ".txt", sep = "")
    
    # Generate a path and name for a temporary file
    temp <- tempfile(pattern = "file", tmpdir = tempdir())
    
    # Replace spaces in measurements file by commas and save as temporary file
    system2("sed", args = cmd, stdout = temp)
    
    # Load temporary file as data table
    # Only select the columns we are interested in
    dt <- fread(temp, sep=",", header = FALSE, select = columns$id) 
    
    # Add descriptive column names
    setnames(dt, columns$name)
    
    # Add the column 'subject'
    subjects <- read.table(subjectFile, col.names = c("id"), colClasses = c("integer"))
    dt[, subject := subjects$id]
    
    # Add the column 'activity'
    activities <- read.table(activityFile, col.names = c("id"), colClasses = c("integer"))
    dt[, activity := activities$id]
    
    return(dt)
    
}

train <- readData("train")
test <- readData("test")

####################################
### Combine training & test data ###
####################################

all.data <- rbind(train, test)

####################################
###      Add activity labels     ###
####################################

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("id", "label"), colClasses = c("integer", "character"))
all.data[, activity := mapvalues(all.data$activity, from = activity_labels$id, to = activity_labels$label)]

####################################
###      Create tidy dataset     ###
###           (long form)        ###
####################################

melted.data <- melt(all.data, id = c("subject", "activity"))
tidy.data <- ddply(melted.data, c("subject", "activity", "variable"), summarise, average = mean(value))

####################################
### Write tidy dataset to a file ###
####################################

write.table(tidy.data, file = "tidy_data.txt", row.names = FALSE)

