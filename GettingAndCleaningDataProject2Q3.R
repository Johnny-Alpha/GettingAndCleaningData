library(data.table)
library(ggplot2)

#Answer the following question.
#Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these 
#four sources have seen decreases in emissions from 1999-2008 for Baltimore City? 
#Which have seen increases in emissions from 1999-2008? Use the ggplot2 plotting system to make a plot answer this question.


#Data dir relative to working directory. Need to change as appropriate to run the programme as required
dataDir <- "./GetData/data/"

calculateTotalBaltimoreEmissionsTimeSeries = function(){
  
  message("Reading NEI Data")
  NEIData <- readRDS(paste(dataDir,"summarySCC_PM25.rds",sep=""))
  
  message("Extracting Baltimore dataset")
  BaltimoreData <- NEIData[NEIData$fips == "24510", ]
  
  message("Aggregating Emmisions by year and type")
  BaltimoreDataDT <- data.table(BaltimoreData)
  sumEmmisionsBaltimoreData <- BaltimoreDataDT[,sum(Emissions),by = list(year,type)]
  setnames(sumEmmisionsBaltimoreData, c("year","type","Emissions"))
  
  return(sumEmmisionsBaltimoreData)
  
}

main = function(){
  
  BaltimoreDataTS <- calculateTotalBaltimoreEmissionsTimeSeries()
  
  png(paste(dataDir,"plot3.png",sep=""), width=480, height=480)
  chart <- ggplot(BaltimoreDataTS, aes(x=year, y=Emissions, colour=type)) + geom_point() + geom_smooth(size=0.5,method="loess") +
  ggtitle("Total Emissions by Type in Baltimore City")
  
  print(chart)
  dev.off()
  
}
