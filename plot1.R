# Download household power consumption data, unzip it, and then assign it to "power"

url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, destfile = "power_consumption.zip", method = "curl")
unzip("power_consumption.zip")
power <- read.table("household_power_consumption.txt", sep=";", header=T, stringsAsFactors = F)

# Load the lubridate package (to format the date column) 
# and the dplyr package (to add a new date-formatted column)

library(lubridate)
library(dplyr)

power <- mutate(power, Dates = dmy(Date))

# Extract only dates from 2007-02-01 to 2007-02-02
power <- power[power$Dates >= ymd("2007-02-01") & power$Dates <= ymd("2007-02-02"),]  

# Plot a historgram of global active power
hist(as.numeric(power$Global_active_power), col = "red", xlab = 
       "Global Active Power (kilowatts)", main = "Global Active Power")

# Save plot as a PNG file
dev.copy(png, file = "plot1.png") # Copy histogram to a PNG file
dev.off()
