require(dplyr)

##You should create one R script called run_analysis.R that does the following. 
##1.Merges the training and the test sets to create one data set.

#Because fread function causes R session crash in this project,I don't use data.table package.
#read test dataset(value measurements,activity numbers,subject numbers)
test_x<-read.table("UCI_HAR_Dataset/test/X_test.txt")
test_y<-read.table("UCI_HAR_Dataset/test/Y_test.txt")
subject_test<-read.table('UCI_HAR_Dataset/test/subject_test.txt')
#read train dataset(value measurements,activity numbers,subject numbers)
train_x<-read.table('UCI_HAR_Dataset/train/X_train.txt')
train_y<-read.table('UCI_HAR_Dataset/train/Y_train.txt')
subject_train<-read.table('UCI_HAR_Dataset/train/subject_train.txt')

#bind test and train dataset 
x<-rbind(test_x,train_x)
y<-rbind(test_y,train_y)
subject<-rbind(subject_test,subject_train)

#use factor functionto encode subject object. 
subject<-factor(subject[,1])

##2.Extracts only the measurements on the mean and standard deviation for each measurement.

# read feature data set. 
features<-read.table('UCI_HAR_Dataset/features.txt')
#get position for the measurements names including mean and std deviation by grep.
features_extract<-grep("*-mean\\(\\)|-std\\(\\)",features[,2])
#extracts only the measurements on the mean and standard deviation for each measurement.
x_extract<-x[,features_extract]

##3.Uses descriptive activity names to name the activities in the data set

#read activity labels data set
activity_labels<-read.table('UCI_HAR_Dataset/activity_labels.txt')
#use factor functionto encode y object with activity_labels.
activity<-factor(y[,1],labels=activity_labels[,2])

##4.Appropriately labels the data set with descriptive variable names. 

features_extract_name<-features[features_extract,]
features_label_name<-gsub("\\(\\)-|-|\\(\\)$","",features_extract_name[,2])
features_label_name<-tolower(features_label_name)
labels<-c("subject","activity",features_label_name)
#create merge data set by cbind function.
dataset<-cbind(subject,activity,x_extract)
names(dataset)<-labels
# write table for merge data set.
#write.table(dataset,"merge_data.txt",row.name=FALSE,sep=",",quote = FALSE)

##5.From the data set in step 4, creates a second, independent tidy data set with the average of each 
##variable for each activity and each subject.

#Create a data frame tbl from merge data set.
tbl_dataset<-tbl_df(dataset)
#group by subjct and activity colume.
datasets_group<-group_by(tbl_dataset,subject,activity)
#create tidy data by sumarise_each function.
tidy_data<-summarise_each(datasets_group,funs(mean))
#write table for tidy data set.
write.table(tidy_data,"tidy_data.txt",row.name=FALSE,sep=",",quote = FALSE)