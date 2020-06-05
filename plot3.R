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
                    select = c(1, 2, 7:9),
                    col.names = c("date",
                                  "time",
                                  "Sub_metering_1",
                                  "Sub_metering_2",
                                  "Sub_metering_3"))

setwd("../")

power_data[, datetime := dmy_hms(paste(date, time))]
power_data[, date := NULL]
power_data[, time := NULL]

# Plot
par(mfrow = c(1, 1))
par(bg = NA)

with(power_data, plot(datetime,
                      Sub_metering_1,
                      type = "l",
                      xlab = "",
                      ylab = "Energy sub metering")
     )
with(power_data, points(datetime,
                        Sub_metering_2,
                        type = "l",
                        col = "red")
     )
with(power_data, points(datetime,
                        Sub_metering_3,
                        type = "l",
                        col = "blue")
)

legend("topright",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty = c(1, 1, 1),
       col = c("black", "red", "blue"))

dev.copy(png, file = "plot3.png")
dev.off()
