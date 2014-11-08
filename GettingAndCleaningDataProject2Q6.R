library(data.table)
library(ggplot2)

#Answer the following question.
#Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle 
#sources in Los Angeles County, California (fips == "06037"). 
#Which city has seen greater changes over time in motor vehicle emissions?


#Data dir relative to working directory. Need to change as appropriate to run the programme as required
dataDir <- "./GetData/data/"

calculateTotalVechileEmissionsTimeSeries = function(){
  
  message("Reading NEI Data")
  NEIData <- readRDS(paste(dataDir,"summarySCC_PM25.rds",sep=""))
  
  message("Reading SCC Data")
  SCCData <- readRDS(paste(dataDir,"Source_Classification_Code.rds",sep=""))
  
  message("Extracting Vechile Emissons related rows from the SCC Data")
  SCCVechileData  <- SCCData[grep("vehicle", SCCData$EI.Sector,ignore.case=T,value=F),]
  
  message("Extracting Baltimore & Los Angles County dataset")
  BaltimoreAndLosAnglesCountyData <- NEIData[NEIData$fips == "24510" | NEIData$fips == "06037" , ]
 
  message("Aggregating Vechile Emissions For Baltimore & Los Angles County")
  NEIVechileEmissionOnlyData <- subset(BaltimoreAndLosAnglesCountyData, BaltimoreAndLosAnglesCountyData$SCC %in% SCCVechileData$SCC)
  NEIVechileEmissionOnlyDataDT <- data.table(NEIVechileEmissionOnlyData)
  
  sumOfBaltimoreAndLACVechileEmissionOnlyData <- NEIVechileEmissionOnlyDataDT[,sum(Emissions),by = list(year,fips)]
  setnames(sumOfBaltimoreAndLACVechileEmissionOnlyData, c("year","fips","Emissions"))
  
  return(sumOfBaltimoreAndLACVechileEmissionOnlyData)
  
}

main = function(){
  
  VechileEmissonData <- calculateTotalVechileEmissionsTimeSeries()
  
  message("Plotting Total Vehicle Emissions in Baltimore City & Los Angles County")
  
  png(paste(dataDir,"plot6.png",sep=""), width=480, height=480)
  chart <- ggplot(VechileEmissonData, aes(x=year, y=Emissions, colour=fips)) + geom_point() + geom_smooth(size=0.5,method="loess") +
    ggtitle("Total Vechile Emissions by Type in Baltimore City & Los Angles County")
  print(chart)
  dev.off()
}



