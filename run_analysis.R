# Load the Activity Labels
activity_labels <- read.table("activity_labels.txt")[,2]

# Load the Column Names
features <- read.table("features.txt")[,2]

# Extract only the mean or standard deviation values
mean_std <- grepl("mean|std", features)

# Load X_test, y_test, and subject_text data.
X_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")
subject_test <- read.table("subject_test.txt")

# Apply feature names to X_test
names(X_test) = features

# Pull out only mean and standar deviation values from X_test
X_test = X_test[,mean_std]

# Loading activity labels for test dataset
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# Combine subject, y, and X test datasets
test_data <- cbind(as.data.table(subject_test), y_test, X_test)

# Load X, y, and subject training datasets
X_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")
subject_train <- read.table("subject_train.txt")

# Apply feature names to x training dataset
names(X_train) = features

# Extract only the mean and standard deviation values from the X training dataset
X_train = X_train[,mean_std]

# Load activity labels for training dataset
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Combine training datasets
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

# Combine training and testing datasets
data = rbind(test_data, train_data)

id_labels = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)

# Melt datasets
melt_data = melt(data, id = id_labels, measure.vars = data_labels)

# Use dcast to apply mean to all values in the dataset
tidy_data = dcast(melt_data, subject + Activity_Label ~ variable, mean)

# Write table to txt file, remove rownames for grader
write.table(tidy_data, file = "tidy_data.txt", row.names=FALSE)
