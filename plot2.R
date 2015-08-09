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


# Make a line graph, and then export a PNG file
plot(power$Dates, power$Global_active_power, type = "l", 
     xlab = "", ylab = "Global Active Power (kilowatts)")

# Save plot as a PNG file
dev.copy(png, file = "plot2.png")
dev.off()