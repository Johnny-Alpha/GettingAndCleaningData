library(data.table)
library(ggplot2)

#Answer the following question.
#Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?


#Data dir relative to working directory. Need to change as appropriate to run the programme as required
dataDir <- "./GetData/data/"

calculateTotalCoalEmissionsTimeSeries = function(){
  
  message("Reading NEI Data")
  NEIData <- readRDS(paste(dataDir,"summarySCC_PM25.rds",sep=""))
  
  message("Reading SCC Data")
  SCCData <- readRDS(paste(dataDir,"Source_Classification_Code.rds",sep=""))
  
  message("Extracting 'Coal Combustion' Emissions related rows from the SCC Data")
  SCCCoalData  <- SCCData[grep("coal", SCCData$EI.Sector,ignore.case=T,value=F),]
  
  message("Aggregating PM2.5 Coal Combustion Emissions")
  NEICoalCombustionEmissionOnlyData <- subset(NEIData, NEIData$SCC %in% SCCCoalData$SCC)
  NEICoalCombustionEmissionOnlyDataDT <- data.table(NEICoalCombustionEmissionOnlyData)
  
  sumCoalEmmisionsByYearAndSCCCode <- NEICoalCombustionEmissionOnlyDataDT[,sum(Emissions),by = list(year)]
  setnames(sumCoalEmmisionsByYearAndSCCCode, c("year","Emissions"))
  
  return(sumCoalEmmisionsByYearAndSCCCode)
  
}

main = function(){
  
  CoalEmissonData <- calculateTotalCoalEmissionsTimeSeries()
  
  message("Plotting Coal Combustion Emmissons data using ggplot")
  
  png(paste(dataDir,"plot4.png",sep=""), width=480, height=480)
  chart <- ggplot(CoalEmissonData, aes(x=year, y=Emissions)) + geom_point() + geom_smooth(size=0.5,method="loess") +
  ggtitle("Total PM2.5 Coal Combustion Emissions in the US")
  
  print(chart)
  dev.off()
}