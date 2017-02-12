
install.packages("data.table")
install.packages("reshape2")
require("data.table")
require("reshape2")

# Reads in activity table then reads in names.

activity_labels <- read.table("C:\\Users\\jamryan\\Documents\\getdata%2Fprojectfiles%2FUCI HAR Dataset\\UCI HAR Dataset\\activity_labels.txt")[,2]
features <- read.table("C:\\Users\\jamryan\\Documents\\getdata%2Fprojectfiles%2FUCI HAR Dataset\\UCI HAR Dataset\\features.txt")[,2]

# Extractsthe mean and standard deviation
extract_features <- grepl("mean|std", features)

# Processes the test data
Xtest <- read.table("C:\\Users\\jamryan\\Documents\\getdata%2Fprojectfiles%2FUCI HAR Dataset\\UCI HAR Dataset\\test\\X_test.txt")
ytest <- read.table("C:\\Users\\jamryan\\Documents\\getdata%2Fprojectfiles%2FUCI HAR Dataset\\UCI HAR Dataset\\test\\y_test.txt")
subject_test <- read.table("C:\\Users\\jamryan\\Documents\\getdata%2Fprojectfiles%2FUCI HAR Dataset\\UCI HAR Dataset\\test\\subject_test.txt")
names(Xtest) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
Xtest = Xtest[,extract_features]

# Load activity labels
ytest[,2] = activity_labels[ytest[,1]]
names(ytest) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# Bind data
test_data <- cbind(as.data.table(subject_test), ytest, Xtest)

# Load and process X_train & y_train data.
Xtrain <- read.table("C:\\Users\\jamryan\\Documents\\getdata%2Fprojectfiles%2FUCI HAR Dataset\\UCI HAR Dataset\\train\\X_train.txt")
ytrain <- read.table("C:\\Users\\jamryan\\Documents\\getdata%2Fprojectfiles%2FUCI HAR Dataset\\UCI HAR Dataset\\train\\y_train.txt")

subject_train <- read.table("C:\\Users\\jamryan\\Documents\\getdata%2Fprojectfiles%2FUCI HAR Dataset\\UCI HAR Dataset\\train\\subject_train.txt")

names(Xtrain) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
Xtrain = Xtrain[,extract_features]


ytrain[,2] = activity_labels[ytrain[,1]]
names(ytrain) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"
train_data <- cbind(as.data.table(subject_train), ytrain, Xtrain)

# Merge test and train data
data = rbind(test_data, train_data)
id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# Creates mean and writes file for export
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)
write.table(tidy_data, file = "./tidy_data.txt")
write.table(tidy_data, file = "./tidy_data.txt")
