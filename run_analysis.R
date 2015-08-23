## Course project for Getting and Cleaning Data

## After I unzipped the zip file in my working directory I need to read the features table and subset only those that contain mean or standard deviation
features<- read.table("./features.txt")
features[,2] <- as.character(features[,2])

## The same for activity
activityLabels <- read.table("./activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])

## I need only second column of features and only those that contain mean and std
Mean_and_Std<- grep(".*mean.*|.*std.*", features[,2])

## I also need to read the train and test tables, but I read only those, that contain mean or std
Train <- read.table("./train/X_train.txt")[Mean_and_Std]
Train_label<- read.table("./train/y_train.txt")
Train_subject<- read.table("./train/subject_train.txt")
Train_full<- cbind(Train_subject, Train_label, Train)

Test <- read.table("./test/X_test.txt")[Mean_and_Std]
Test_label<- read.table("./test/y_test.txt")
Test_subject<- read.table("./test/subject_test.txt")
Test_full<- cbind(Test_subject, Test_label, Test)

## After I loaded the needed files, I merge them together to get 1 big datasets instead of 6 according to their categories
Merge_all<- rbind(Train_full, Test_full)

## Now I rename the columns of merged dataset

colnames(Merge_all) <- c("subject", "activity", Mean_and_Std)

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)

## I now want to change the integer in subject and activity to factor, for grouping the variables
Merge_all$activity <- factor(Merge_all$activity, levels = activityLabels[,1], labels = activityLabels[,2])
Merge_all$subject <- as.factor(Merge_all$subject)

# Now I have everything prepared for creating the final 
Merge_all_grouped <- melt(Merge_all, id = c("subject", "activity"))
Merge_all_tidy <- dcast(Merge_all_grouped, subject + activity ~ variable, mean)

## With this final step, I create a tidy .txt file
write.table(Merge_all_tidy, "tidy.txt", row.names = FALSE, quote = FALSE)
