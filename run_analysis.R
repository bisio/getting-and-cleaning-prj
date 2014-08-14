

load.a.dataset <- function(dataset="test") {
  base.path <- paste("UCI HAR Dataset",dataset,sep="/")
  features.data.path <- paste0("X_",dataset,".txt") 
  features.data.path <- paste(base.path,features.data.path,sep="/")
  outcome.path <- paste0("y_",dataset,".txt")
  outcome.path <- paste(base.path,outcome.path,sep="/")
  subject.path <- paste0("subject_",dataset,".txt")
  subject.path <- paste(base.path,subject.path,sep="/")
  features.data <- read.table(features.data.path)
  outcome.data  <- read.table(outcome.path)
  subject.data  <- read.table(subject.path)
  cbind(subject.data,outcome.data,features.data)
}


testSet <-  load.a.dataset("test")
trainSet <- load.a.dataset("train")

base.path <- paste("UCI HAR Dataset")
activity.labels <-  read.table(paste(base.path,"activity_labels.txt",sep="/"))
names(activity.labels) <- c("code","label")

features.names <- read.table(paste(base.path,"features.txt",sep="/"))
names(features.names) <- c("ord","feature")

tidy.dataset <- function(dataset,features.names,activity.labels) {
  dataset[,2] <- factor(dataset[,2],labels=activity.labels$label)
  names(dataset) <- c("subject","activity",make.names(features.names$feature))
  to.keep <- grep("mean|std",names(dataset))
  to.keep <- c(1,2,to.keep)
  dataset <- dataset[,to.keep]
  names(dataset) <- gsub("\\.","",names(dataset))
  dataset
}

testTidy  <-  tidy.dataset(testSet,features.names,activity.labels)
trainTidy <- tidy.dataset(trainSet,features.names,activity.labels)
tidy.all  <- rbind(testTidy,trainTidy)


library(plyr)
cols.to.process <- colnames(tidy.all)[3:ncol(tidy.all)]
the.new.df <- ddply(tidy.all,.(subject,activity),colwise(mean,cols.to.process))

# alternative implementation without plyr
#
# splitted <- split(tidy.all,list(tidy.all$subject,tidy.all$activity),drop=T)
# new.mat  <-  t(sapply(splitted,function(x){
#     m <- as.matrix(as.matrix(x[,3:ncol(tidy.all)]))
#     colMeans(m)
# }))
# 
# subject <- as.integer(sub("([0-9]+).*","\\1",rownames(new.mat)))
# activity <- as.factor(sub("[0-9]+\\.(.*)","\\1",rownames(new.mat)))
# the.new.df <-  data.frame(subject,activity,new.mat)
# rownames(the.new.df) <- NULL

