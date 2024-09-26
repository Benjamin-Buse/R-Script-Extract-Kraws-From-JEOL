library(rstudioapi)
library(svDialogs)
library(stringr)
library(stringi)
setwd(selectDirectory(caption="Select 0000 QNT folder"))
NumberofSamples<-as.numeric(dlgInput("Enter number of samples")$res)
NumberofElements<-as.numeric(dlgInput("Enter number of Elements")$res)
StoreKraws<-data.frame(matrix(NA,NumberofSamples,NumberofElements))
StorePositions<-data.frame(matrix(NA,NumberofSamples,4))
for(i in 1:NumberofSamples){
  QuantResult<-read.table(paste(getwd(),"/Pos_",stri_pad(i,4,pad="0"),"/1.wt",sep=""),header=FALSE,sep="",fill=TRUE)
  FolderName<-QuantResult[which(QuantResult=='Project',arr.ind=T)[1,1],which(QuantResult=='Project',arr.ind=T)[1,2]+2]
  elementlabels<-"El No."
  for(ii in 1:NumberofElements){
    El1<-which(QuantResult[,1]==ii)
    elementlabels<-c(elementlabels,(QuantResult[El1,2]))
    rowdecimals<-str_extract(QuantResult[El1,],".*[0-9]\\...[0-9]")
    rowdecimals<-rowdecimals[!is.na(rowdecimals)]
    ExtractedKraw<-rowdecimals[length(rowdecimals)]
    StoreKraws[i,ii]<-ExtractedKraw
  }
  StorePositions[i,1]<-QuantResult[which(QuantResult=='X=',arr.ind=T)[1,1],which(QuantResult=='X=',arr.ind=T)[1,2]+1]
  StorePositions[i,2]<-QuantResult[which(QuantResult=='Y=',arr.ind=T)[1,1],which(QuantResult=='Y=',arr.ind=T)[1,2]+1]
  StorePositions[i,3]<-QuantResult[which(QuantResult=='Z=',arr.ind=T)[1,1],which(QuantResult=='Z=',arr.ind=T)[1,2]+1]
  xmove<-as.numeric(StorePositions[1,1])-as.numeric(StorePositions[i,1])
  ymove<-as.numeric(StorePositions[1,2])-as.numeric(StorePositions[i,2])
  StorePositions[i,4]<-sqrt((xmove^2)+(ymove^2))
}
colnames(StoreKraws)<-elementlabels[2:length(elementlabels)]
colnames(StorePositions)<-c("X","Y","Z","Rel Dist")
#write.csv(StoreKraws,file=file.path(getwd(),paste(FolderName,"RStudio_Extract_Kraws_Points.csv",sep="_")))
write.csv(cbind(StoreKraws,StorePositions),file=file.path(getwd(),paste(FolderName,"RStudio_Extract_Kraws_Points_RelDist.csv",sep="_")))
