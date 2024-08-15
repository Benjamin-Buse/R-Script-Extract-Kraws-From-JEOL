library(rstudioapi)
library(svDialogs)
setwd(selectDirectory(caption="Select 0000 QNT folder"))
NumberofSamples<-as.numeric(dlgInput("Enter number of samples")$res)
NumberofElements<-as.numeric(dlgInput("Enter number of Elements")$res)
StoreKraws<-data.frame(matrix(NA,NumberofSamples,NumberofElements))
for(i in 1:NumberofSamples){
  QuantResult<-read.table(paste(getwd(),"/Pos_",stri_pad(i,4,pad="0"),"/1.wt",sep=""),header=FALSE,sep="",fill=TRUE)
  for(ii in 1:NumberofElements){
    El1<-which(QuantResult[,1]==ii)
    rowdecimals<-str_extract(QuantResult[El1,],".*[0-9]\\...[0-9]")
    rowdecimals<-rowdecimals[!is.na(rowdecimals)]
    ExtractedKraw<-rowdecimals[length(rowdecimals)]
    StoreKraws[i,ii]<-ExtractedKraw
  }
}
write.csv(StoreKraws,file=file.path(getwd(),"RStudio_Extract_Kraws_Points.csv"))

