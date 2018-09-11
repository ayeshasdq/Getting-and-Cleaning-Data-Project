
##STEP 1. #Merges the training and the test sets to create one data set.

#### 
# 1. reading the training tables
setwd("~/Downloads/UCI HAR Dataset/train")
x_train <- read.table(file = "X_train.txt", header = FALSE)
y_train <- read.table(file = "y_train.txt", header = FALSE)
subject_train <- read.table(file = "subject_train.txt", header = FALSE)

#2. reading the testing tables
setwd("~/Downloads/UCI HAR Dataset/test")
x_test <- read.table(file = "X_test.txt", header = FALSE)
y_test <- read.table(file = "y_test.txt", header = FALSE)
subject_test <- read.table(file = "subject_test.txt", header = FALSE)

#3.reading vector files
setwd("~/Downloads/UCI HAR Dataset")
features_name <- read.table(file = "features.txt", header = FALSE)


#### Observing structure of files
str(activity_labels)
str(x_test)
str(y_test)
str(x_train)
str(y_train)
str(subject_test)
str(subject_train)


###combine tables by rows
Subject <- rbind(subject_train, subject_test)
Activity<- rbind(y_train, y_test)
Features<- rbind(x_train, x_test)

###Set names to Variables
names(Subject)<-c("subject")
names(Activity)<- c("activity")
features_name <- read.table(file = "features.txt", header = FALSE)
names(Features)<- features_name$V2


### Merge Columns
CombineData <- cbind(Subject, Activity)
Data <- cbind(Features, CombineData)





##STEP2 ####Extracts only the measurements on the mean and standard deviation for each measurement.

subdata_FeaturesNames<-features_name$V2[grep("mean\\(\\)|std\\(\\)", features_name$V2)]
selectedNames<-c(as.character(subdata_FeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)




####STEP3. Uses descriptive activity names to name the activities in the data set
#4. Reading activity labels:
activity_labels <- read.table(file = "activity_labels.txt", header = FALSE)
Data$activity<-factor(Data$activity,labels=activity_labels[,2])
head(activity_labels, 30)



###STEP4. Appropriately labels the data set with descriptive variable names.
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

names(Data)

####STEP5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydataset.txt",row.name=FALSE, quote = FALSE, sep = '\t')

