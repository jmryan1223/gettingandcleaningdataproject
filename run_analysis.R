install.packages("data.table")
install.packages("reshape2")
require("data.table")
require("reshape2")


activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
feat <- read.table("./UCI HAR Dataset/features.txt")[,2]
# Mean/stddev
extract_features <- grepl("mean|std", feat)

# Processes the test dataset
Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(Xtest) = feat

# Extract only the measurements on the mean and standard deviation for each measurement.
Xtest = Xtest[,extract_features]

# Load labels
ytest[,2] = activity_labels[ytest[,1]]
names(ytest) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# Bind data
test_data <- cbind(as.data.table(subject_test), ytest, Xtest)

# Loads the training data.
Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

names(Xtrain) = feat


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
