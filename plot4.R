# Install tidyverse package if necessary
if (!require(tidyverse)) {
      install.packages("tidyverse")
      library(tidyverse)
}

# Download archive and unzip
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
archive <- tempfile()
download.file(url, archive)
unzip(archive, "household_power_consumption.txt")

# Read data from unzipped file
dat <- as_tibble(read.table("household_power_consumption.txt", sep=";", na.strings="?", header=T))

# Convert date & time
dat <- dat %>% mutate(Time=dmy_hms(paste(Date, Time))) %>%
      rename(DateTime = Time) %>%
      select(-Date)

# Extract cases of 2007-02-01 and 2007-02-02
dat <- dat %>% filter(DateTime %within% (ymd_hms("2007-02-01 00:00:00") %--% ymd_hms("2007-02-02 23:59:59")))

# Cache local date format and switch to US format
cacheLocale <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME", "C")

# Initialise plot
png(filename="plot4.png", width=480, height=480, units="px")
par(mfrow=c(2,2), mar=c(4,4,2,2))

# Plot [1,1]
with(dat, plot(DateTime, Global_active_power, type="l", ylab="Global Active Power (kilowatts)", xlab=""))

# Plot [1,2]
with(dat, plot(DateTime, Voltage, type="l", ylab="Voltage", xlab="datetime"))

# Plot [2,1]
with(dat, plot(DateTime, Sub_metering_1, type="n", ylab="Energy sub metering", xlab=""))
with(dat, lines(DateTime, Sub_metering_1, col="black"))
with(dat, lines(DateTime, Sub_metering_2, col="red"))
with(dat, lines(DateTime, Sub_metering_3, col="blue"))
legend("topright",legend=names(dat[6:8]),lty=c(1,1,1), col=c("black","red","blue"), bty="n")

# Plot [2,2]
with(dat, plot(DateTime, Global_reactive_power, type="l", ylab="Global_reactive_power", xlab="datetime"))

# Save and close plot
dev.off()

# Switch back to cached local date format
Sys.setlocale("LC_TIME", cacheLocale)