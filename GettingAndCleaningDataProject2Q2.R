library(data.table)

#Answer the following question.
#Have total emissions from PM2.5 decreased in the Baltimore City, 
#Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.

#Data dir relative to working directory. Need to change as appropriate to run the programme as required
dataDir <- "./GetData/data/"

readBaltimoreData = function(){
  
  message("Reading NEI Data")
  NEIData <- readRDS(paste(dataDir,"summarySCC_PM25.rds",sep=""))
  
  message("Extracting Baltimore dataset")
  BaltimoreData <- NEIData[NEIData$fips == "24510", ]
  
  message("Aggregating Emmisions by year")
  BaltimoreDataDT <- data.table(BaltimoreData)
  sumEmmisionsBaltimoreData <- BaltimoreDataDT[,sum(Emissions),by = year]
  setnames(sumEmmisionsBaltimoreData,c("year","Emissions"))
  
  return(sumEmmisionsBaltimoreData)
  
}

main = function(){
  
  BaltimoreData <- readBaltimoreData()
  
  png(paste(dataDir,"plot2.png",sep=""), width=480, height=480)
  
  chart <- plot(BaltimoreData$year, BaltimoreData$Emissions, type = "l",main = "Total PM2.5 Emissions for Baltimore City", xlab = "Year", ylab = "Emissions")
  
  print(chart)
  
  dev.off()
}
