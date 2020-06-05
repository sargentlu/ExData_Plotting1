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
                    col.names = c("date",
                                  "time",
                                  "global_active_power",
                                  "global_reactive_power",
                                  "voltage",
                                  "global_intensity",
                                  "sub_metering_1",
                                  "sub_metering_2",
                                  "sub_metering_3"))

setwd("../")

power_data[, datetime := dmy_hms(paste(date, time))]
power_data[, date := NULL]
power_data[, time := NULL]

# Plot
par(mfrow = c(2, 2))
par(bg = NA)

# Plot 1
with(power_data, plot(datetime,
                      global_active_power,
                      type = "l",
                      xlab = "",
                      ylab = "Global Active Power"
))

# Plot 2
with(power_data, plot(datetime,
                      voltage,
                      type = "l",
                      xlab = "datetime",
                      ylab = "Voltage"
))

# Plot 3
with(power_data, plot(datetime,
                      sub_metering_1,
                      type = "l",
                      xlab = "",
                      ylab = "Energy sub metering")
     )
with(power_data, points(datetime,
                        sub_metering_2,
                        type = "l",
                        col = "red")
     )
with(power_data, points(datetime,
                        sub_metering_3,
                        type = "l",
                        col = "blue")
)

legend("topright",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty = 1,
       col = c("black", "red", "blue"),
       bty = "n",
       cex = 0.85,
       y.intersp = 0.5,
       inset = c(-0.05, -0.06))

# Plot 4
with(power_data, plot(datetime,
                      global_reactive_power,
                      type = "l",
                      xlab = "datetime",
                      ylab = "Global_reactive_power"
))

dev.copy(png, file = "plot4.png")
dev.off()
