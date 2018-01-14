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
dat <- dat %>% filter(DateTime %within% (ymd("2007-02-01") %--% ymd("2007-02-02")))

# Plot

                      