## Script for Programming Assignment 1 Exploratory Data Analysis course
## Author: Gerrit Versteeg
## Last saved: Sept 4th, 2016
##-----------------------------------------------------------------------------
##---------------- PART 1. GETTING THE DATA -----------------------------------
##
##---- step 0. Loading relevant packages
library("dplyr")
##
##---- step 1: prepare the download (URL & landingplace: WDir/EDA1_data) ------
myURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
myURL <- sub("^https", "http", myURL)
if (!file.exists("EDA1_data")) {
        dir.create("EDA1_data")
}
##
##---- step 2: download the zip-file, unzip it and delete it------------------- 
download.file(myURL, destfile = "./EDA1_data/temp.zip", mode="wb")
dateDownloaded <- date()
unzip("./EDA1_data/temp.zip", exdir = "./EDA1_data")
unlink("./EDA1_data/temp.zip")
##
##-----------------------------------------------------------------------------
##----- PART 2. MAKING TIBBLE, SUBSETTING AND CLEANING ------------------------
##
##---- step 3: read txt.file into tibbles (in WDir) for speed in dplyr --------
TDF <- tbl_df(read.table("./EDA1_data/household_power_consumption.txt", 
                         header = TRUE,
                         sep = ";",
                         na.strings = "?",
                         colClasses = "character"))
##
##---- step 4: Subset DF for Feb 1st & Feb 2nd, 2007 --------------------------
TDFS <- filter(TDF, Date == "1/2/2007" | Date == "2/2/2007")
##
##---- step 5: Add a datetime column and set the class of other var's ---------
TDFT <- mutate(TDFS, Datetime = as.POSIXct(strptime(paste(Date, Time), "%d/%m/%Y %H:%M:%S")))
TDFT$Date <- as.Date(strptime(TDFT$Date, "%d/%m/%Y"))
TDFT$Global_active_power <- as.numeric(TDFT$Global_active_power)
TDFT$Global_reactive_power <- as.numeric(TDFT$Global_reactive_power)
TDFT$Voltage <- as.numeric(TDFT$Voltage)
TDFT$Global_intensity <- as.numeric(TDFT$Global_intensity)
TDFT$Sub_metering_1 <- as.numeric(TDFT$Sub_metering_1)
TDFT$Sub_metering_2 <- as.numeric(TDFT$Sub_metering_2)
TDFT$Sub_metering_3 <- as.numeric(TDFT$Sub_metering_3)
##
##-----------------------------------------------------------------------------
##----- PART 3. MAKE THE PLOT -------------------------------------------------
##
##---- step 6: Setup png.file, make plots, close device ------------------------
if (file.exists("plot4.png")) {unlink("plot4.png")}
png(filename = "plot4.png", width = 480, height = 480)
par(mfrow = c(2, 2))
with(TDFT, {
        plot(Datetime, Global_active_power,
                     type = "l", 
                     xlab = NA,
                     ylab = "Global Active Power")
        plot(Datetime, Voltage,
                     type = "l", 
                     xlab = "datetime",
                     ylab = "Voltage")
        plot(Datetime, Sub_metering_1,
                        type = "l", 
                        xlab = NA,
                        ylab = "Energy sub metering")
                with(TDFT, lines(Datetime, Sub_metering_2, col = "red"))
                with(TDFT, lines(Datetime, Sub_metering_3, col = "blue"))
                        legend("topright",
                        pch = "-",
                        lwd = 1,
                        bty = "n",
                        col = c("black", "red", "blue"),
                        legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
        plot(Datetime, Global_reactive_power,
                        type = "l", 
                        xlab = "datetime")
        })
dev.off(which = dev.cur())
##
##-----------------------------------------------------------------------------
## End of script
##-----------------------------------------------------------------------------

