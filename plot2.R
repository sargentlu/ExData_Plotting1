library(data.table)
library(lubridate)

# Create data directory to store the dataset
if (!dir.exists("data")) {
    dir.create("data")
}

setwd("data")

# Download, extract, and filter the dataset if it's not already filtered
if (!file.exists("filtered_data.txt")) {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                  "household_power_consumption.zip")
    
    unzip("household_power_consumption.zip")
    
    system("awk 'BEGIN { FS=\";\" }
           { if ($1 == \"1/2/2007\" || $1 == \"2/2/2007\") print $0 }'
           household_power_consumption.txt > filtered_data.txt")
    
    file.remove("household_power_consumption.txt",
                "household_power_consumption.zip")
}

# Read the dataset
power_data <- fread("filtered_data.txt",
                    na.strings = "?",
                    select = 1:3,
                    col.names = c("date",
                                  "time",
                                  "global_active_power"))

setwd("../")

power_data[, datetime := dmy_hms(paste(date, time))]
power_data[, date := NULL]
power_data[, time := NULL]

# Plot
par(bg = NA)
with(power_data, plot(datetime,
                      global_active_power,
                      type = "l",
                      xlab = "",
                      ylab = "Global Active Power (kilowatts)"
                      ))

dev.copy(png, file = "plot2.png")
dev.off()