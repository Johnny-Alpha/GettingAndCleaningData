library(data.table)
library(ggplot2)

#Answer the following question.
#How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?


#Data dir relative to working directory. Need to change as appropriate to run the programme as required
dataDir <- "./GetData/data/"

calculateTotalVechileEmissionsTimeSeries = function(){
  
  message("Reading NEI Data")
  NEIData <- readRDS(paste(dataDir,"summarySCC_PM25.rds",sep=""))
  
  message("Reading SCC Data")
  SCCData <- readRDS(paste(dataDir,"Source_Classification_Code.rds",sep=""))
  
  message("Extracting Vechile Emissons related rows from the SCC Data")
  SCCVechileData  <- SCCData[grep("vehicle", SCCData$EI.Sector,ignore.case=T,value=F),]
  
  message("Extracting Baltimore dataset")
  BaltimoreData <- NEIData[NEIData$fips == "24510", ]
  
  message("Aggregating Vechile Emissions For Baltimore")
  NEIVechileEmissionOnlyData <- subset(BaltimoreData, BaltimoreData$SCC %in% SCCVechileData$SCC)
  NEIVechileEmissionOnlyDataDT <- data.table(NEIVechileEmissionOnlyData)
  
  sumOfBaltimoreVechileEmissionOnlyData <- NEIVechileEmissionOnlyDataDT[,sum(Emissions),by = list(year)]
  setnames(sumOfBaltimoreVechileEmissionOnlyData, c("year","Emissions"))
  
  return(sumOfBaltimoreVechileEmissionOnlyData)
  
}

main = function(){
  
  VechileEmissonData <- calculateTotalVechileEmissionsTimeSeries()
  
  message("Plotting Total Vehicle Emissions in Baltimore City")
  
  png(paste(dataDir,"plot5.png",sep=""), width=480, height=480)
  plot(VechileEmissonData$year, VechileEmissonData$Emissions, type = "l", 
       main = "Total Vehicle Emissions in Baltimore City",
       xlab = "Year", ylab = "Emissions")
  
  dev.off()
}

