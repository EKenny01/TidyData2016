## Script for Getting and Cleaning Data Peer Graded Assignment

## Required packages/libraries - "dyplr"

## Required files in working directory:features.txt, y_test.txt, y_train.txt, X_train.txt
## X_test.txt, subject_train.txt, subject_test.txt


## The following code reads the features file into a character vector to capture variable names
features <- scan("features.txt", what = character(), sep = "\n", strip.white = TRUE)

## The following code reads the y_test file into a character vector to capture the activity
testY <- scan("y_test.txt", what = character(), sep = "\n")

## The following code reads the y_train file into a character vector to capture the activity
trainY <- scan("y_train.txt", what = character(), sep = "\n")

## The following code subs the activity numbers for meanigful activity
## names for the left-most column

meaningfulTestY <- gsub("1", "WALKING", testY)
meaningfulTestY <- gsub("2", "WALKING_UPSTAIRS", meaningfulTestY)
meaningfulTestY <- gsub("3", "WALKING_DOWNSTAIRS", meaningfulTestY)
meaningfulTestY <- gsub("4", "SITTING", meaningfulTestY)
meaningfulTestY <- gsub("5", "STANDING", meaningfulTestY)
meaningfulTestY <- gsub("6", "LAYING", meaningfulTestY)

meaningfulTrainY <- gsub("1", "WALKING", trainY)
meaningfulTrainY <- gsub("2", "WALKING_UPSTAIRS", meaningfulTrainY)
meaningfulTrainY <- gsub("3", "WALKING_DOWNSTAIRS", meaningfulTrainY)
meaningfulTrainY <- gsub("4", "SITTING", meaningfulTrainY)
meaningfulTrainY <- gsub("5", "STANDING", meaningfulTrainY)
meaningfulTrainY <- gsub("6", "LAYING", meaningfulTrainY)

## The following code reads the training and test data into 
## dataframes
trainingSetDf <- read.table("X_train.txt")

testSetDf <- read.table("X_test.txt")


## The following code assigns the column names from the features file
colnames(trainingSetDf) <- features
colnames(testSetDf) <- features

## The following code creates the ACTIVITY and SUBJECT columns
subjectTrain <- scan("subject_train.txt", what = character(), sep = "\n")
SUBJECT <- subjectTrain
SUBJECT <- as.data.frame(SUBJECT)

ACTIVITY <- meaningfulTrainY
ACTIVITY <- as.data.frame(ACTIVITY)

## The following code creates an indicator of the source of these observations (TRAIN)
groupTrainNum <- nrow(trainingSetDf)
GROUP <- rep("TRAIN", times = groupTrainNum)

## The following code binds the training data into a data frame
trainingSetDf <- cbind(ACTIVITY, SUBJECT, GROUP, trainingSetDf)

## The following code creates the ACTIVITY and SUBJECT columns
subjectTest <- scan("subject_test.txt", what = character(), sep = "\n")
SUBJECT <- subjectTest
SUBJECT <- as.data.frame(SUBJECT)

ACTIVITY <- meaningfulTestY
ACTIVITY <- as.data.frame(ACTIVITY)

## The following code creates an indicator of the source of these observations (TEST)
groupTestNum <- nrow(testSetDf)
GROUP <- rep("TEST", times = groupTestNum)

## The following code binds the test data into a data frame
testSetDf <- cbind(ACTIVITY, SUBJECT, GROUP, testSetDf)

## The following code combines the test and train data frames
trainTestComb <- rbind(trainingSetDf, testSetDf)

## The following code enables the data frame to be manipulated using the 'dplyr' package
trainTestComb <- tbl_df(trainTestComb)

## The following code obtains the names of the columns
allNames <- names(trainTestComb)

## The following code identifies the column names containing 'mean' and 'std'  
subNames <- grep(("-mean\\(\\)|-std\\(\\)"), allNames)

## The following code subsets the mean and standard deviation data
meanStdData <- select(trainTestComb, 1, 2, 3, subNames)


averages <- meanStdData %>% group_by(ACTIVITY, SUBJECT) %>% summarise_each(funs(mean), -ACTIVITY, -SUBJECT, -GROUP)

return(averages)






