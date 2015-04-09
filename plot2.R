##################################################################################################
## Preparation: Set Working Directory, Download dataset and Unzip to working directory
##################################################################################################

dataDirectory <- "./data"

if(!file.exists(dataDirectory)) {
  dir.create(dataDirectory)
}

zippedDataset <- file.path(dataDirectory, paste("exdata-data-household_power_consumption.zip", sep = "/"))

if (!file.exists(zippedDataset)) {
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(url, destfile = zippedDataset)
}

txtFile <- file.path(dataDirectory, paste("household_power_consumption.txt", sep = "/"))

if(!file.exists(txtFile)) {
  unzip(zippedDataset, exdir = dataDirectory)
}

##################################################################################################
## Read in dataset and extract only data corresponding to dates 2007-02-01 and 2007-02-02
##################################################################################################

data <- read.table(text = grep("^[1,2]/2/2007", readLines(file(txtFile, "r")), value = T), 
                   header = T, 
                   sep = ";", 
                   col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power", 
                                 "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", 
                                 "Sub_metering_3"), 
                   na.strings = c("?", ""), 
                   colClasses = c(rep("character", 2), rep("numeric", 7)))

concatDateTime <- paste(data$Date, data$Time)
data$Date_Time <- strptime(concatDateTime, "%d/%m/%Y %H:%M:%S")

##################################################################################################
## Create Plot 2
##################################################################################################

png("plot2.png", width = 480, height = 480)
plot(data$Date_Time, 
     data$Global_active_power, 
     type = "l", 
     xlab = "", 
     ylab = "Global Active Power (kilowatts)")
dev.off()