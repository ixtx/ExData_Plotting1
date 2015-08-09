# Download household power consumption data, unzip it, and then assign it to "power"

url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, destfile = "power_consumption.zip", method = "curl")
unzip("power_consumption.zip")
power <- read.table("household_power_consumption.txt", sep=";", header=T, stringsAsFactors = F)

# Load the lubridate package (to format the date column) 
# and the dplyr package (to add a new date-formatted column)

library(lubridate)
library(dplyr)

# Add a properly formatted Dates column
power <- mutate(power, Dates = dmy(Date))

# Extract only dates from 2007-02-01 to 2007-02-02
power <- power[power$Dates >= ymd("2007-02-01") & power$Dates <= ymd("2007-02-02"),] 

# Combine the Date and Time columns, and then format them, overwriting Dates
Date_Time <- paste(power$Date, power$Time, sep = " ")
power <- mutate(power, Dates = dmy_hms(Date_Time))

# Add a column with the names of the days
power <- mutate(power, Days = wday(Dates, label = T))

# Create 4 plots for Global Active Power, Voltate, Energy Sub Meetering, 
# and Global Reactive Power, all with Dates as the X axis
par(mfrow = c(2, 2), mar = c(4, 4, 1.5, 1), oma = c(0, 0, 0, 0))
with(power, {
  plot(Dates, Global_active_power, ylab = "Global Active Power", xlab = "", type = "l")
  plot(Dates, Voltage, ylab = "Voltage", xlab = "datetime", type = "l")
  plot(Dates, Sub_metering_1, type = "l", col = "black", 
       ylab = "Energy sub metering", xlab = "")
       lines(Dates, Sub_metering_2, type = "l", col = "red")
       lines(Dates, Sub_metering_3, type = "l", col = "blue")
       legend("topright", lty=c(1,1,1), lwd=c(2,2,2), col = c("black", "red", "blue"), 
       bty = "n", cex = 0.5, 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  plot(Dates, Global_reactive_power, xlab = "datetime", type = "l")
})


# Save plot as a PNG file
dev.copy(png, file = "plot4.png")
dev.off()
