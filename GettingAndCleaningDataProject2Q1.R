library(data.table)

#Answer the following question.
#Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
#Using the base plotting system, make a plot showing the total PM2.5 emission from all 
#sources for each of the years 1999, 2002, 2005, and 2008.

#Data dir relative to working directory. Need to change as appropriate to run the programme as required
dataDir <- "./GetData/data/"

readNEIData = function(){
  
  message("Reading NEI Data")
  NEIData <- readRDS(paste(dataDir,"summarySCC_PM25.rds",sep=""))
    
  message("Aggregating Emmisions by year")
  NEIDataDT <- data.table(NEIData)
  sumEmmisionsNEIData <- NEIDataDT[,sum(Emissions),by = year]
  
  return(sumEmmisionsNEIData)
  
}

main = function(){
  
  NEIData <- readNEIData()
  
  png(paste(dataDir,"plot1.png",sep=""), width=480, height=480)
  
  plot(NEIData$year, NEIData$V1, type = "l",main = "Total PM2.5 Emissions for the US", xlab = "Year", ylab = "Emissions")
  
  dev.off()
}
