#Loading packages
library(dplyr)

#See dir
dir<- getwd()

#Name of file
filename <- "household_power_consumption.zip"

# Check if file already exists.
if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileURL, filename, method="curl")
}  

textfile <- "household_power_consumption.txt"
# Check if text file exists
if (!file.exists(textfile)) { 
    unzip(filename) 
}

#load data.frames
data <- read.table(textfile, header=TRUE, sep=";") 
str(data)

#Convert columns Date and Time of dataset to Date/Time classes using the strptime() and as.Date() functions
data$Date <- as.Date(data$Date, "%d/%m/%Y")
data$Time <-  strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")

#Subset data from specific dates 2007-02-01 and 2007-02-02
datas <- as.Date(c("2007-02-01","2007-02-02"), "%Y-%m-%d")
setdat <- subset(data, Date == datas[1] | Date == datas[2])

#identified columns with not numeric data (=?)
setdat[,3:8] <- apply(setdat[,3:8],2, as.numeric)
str(setdat)

#Change directory to save plot file
newdir <- paste0(dir, "/figure", collapse = "")
setwd(newdir)

#plot4 four plots of household_power_consumption dataset between dates 2007-02-01 and 2007-02-02
png(file="plot4.png", height=480, width=480, units="px")
par(mfrow=c(2, 2))
#plot1
plot(setdat$Time, setdat$Global_active_power, type="l", ylab="Global Active Power", xlab="")
#plot2
plot(setdat$Time, setdat$Voltage, type="l", ylab="Voltage", xlab="datetime")
#plot3
plot(setdat$Time, setdat$Sub_metering_1, type="l", col="black", ylab="Energy sub metering", xlab="")
lines(setdat$Time, setdat$Sub_metering_2, col="red")
lines(setdat$Time, setdat$Sub_metering_3, col="blue")
legend("topright",
       c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"),
       fill=c("black","blue","red"))
#plot4
plot(setdat$Time, setdat$Global_reactive_power, type="l", ylab="Global Reactive Power", xlab="")
dev.off()

#Set again directory old
setwd(dir)
