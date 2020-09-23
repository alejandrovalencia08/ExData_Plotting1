#Loading packages
library(dplyr)


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

#Convert columns Date and Time of dataset to Date/Time classes using the hms() and as.Date functions
data$Date <- as.Date(data$Date, "%d/%m/%Y")
data$Time <- strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")

#Subset data from specific dates 2007-02-01 and 2007-02-02
datas <- as.Date(c("2007-02-01","2007-02-02"), "%Y-%m-%d")
setdat <- subset(data, Date == datas[1] | Date == datas[2])

#identified columns with not numeric data (=?)
setdat[,3:8] <- apply(setdat[,3:8],2, as.numeric)
str(setdat)



#Change directory to save plot file
dir<- getwd()
newdir <- paste0(dir, "/figure", collapse = "")
setwd(newdir)

#plot1 histogram of Global active power between dates 2007-02-01 and 2007-02-02
png(file="plot1.png", height=480, width=480, units="px")
hist(setdat$Global_active_power, col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)")
dev.off()

#Set again directory old
setwd(dir)