#Download & unzip dataset
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
	      destfile="household_power_consumption.zip")
unzip("household_power_consumption.zip")

#Load whole dataset, with date/time as character strings
power_consumption_table_dirty <- read.table("household_power_consumption.txt", header=TRUE, sep=";", dec=".", na.strings="?", stringsAsFactors=FALSE,
					    colClasses=c('character','character','numeric','numeric','numeric','numeric','numeric','numeric','numeric'))

#Add new column with datetime, on base of Date & Time character columns
power_consumption_table_dirty$DateTime <- as.POSIXct(strptime(paste(power_consumption_table_dirty$Date, power_consumption_table_dirty$Time), "%d/%m/%Y %H:%M:%S", tz="GMT") )

#Filter dataset for entries from Feb 1-2 only
power_consumption_table <- subset( power_consumption_table_dirty, as.Date(DateTime) %in% c(as.Date("1/2/2007", format="%d/%m/%Y"),
											   as.Date("2/2/2007", format="%d/%m/%Y")) )

#Free some memory
rm(power_consumption_table_dirty)

#Set EN locale for English day names
Sys.setlocale("LC_TIME", "English") #For Windows

#Plot required flow
png("plot4.png")
par(mfrow=c(2,2))

plot(power_consumption_table$DateTime, power_consumption_table$Global_active_power, type="l", ylab="Global Active Power", xlab="")

plot(power_consumption_table$DateTime, power_consumption_table$Voltage, type="l", ylab="Voltage", xlab="datetime")

plot(power_consumption_table$DateTime, power_consumption_table$Sub_metering_1, type="l", ylab="Energy sub metering", xlab="")
points(power_consumption_table$DateTime, power_consumption_table$Sub_metering_2, type="l", col="red")
points(power_consumption_table$DateTime, power_consumption_table$Sub_metering_3, type="l", col="blue")
legend("topright", lty = 1, bty="n", col = c("black", "blue", "red"), legend = c("Sub_metering1", "Sub_metering2", "Sub_metering3")) #border!

plot(power_consumption_table$DateTime, power_consumption_table$Global_reactive_power, type="l", ylab="Global_reactive_power", xlab="datetime")

dev.off()
