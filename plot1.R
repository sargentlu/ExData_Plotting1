library(data.table)

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
                    select = 3,
                    col.names = "global_active_power")

setwd("../")

# Plot
par(bg = NA)
hist(power_data$global_active_power,
     col = "red",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)",
     ylab = "Frequency")

dev.copy(png, file = "plot1.png")
dev.off()