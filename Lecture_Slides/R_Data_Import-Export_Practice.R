# Import-Export-Practice.R
#
# Script for practicing data import and export from R.

#########################################################
## do some setup first...
#########################################################
# Load the readxl library for working with Excel files
library(readxl)

# Set up some variables to use for file names
RapidEye.file <- "IBP_RapidEyeOrtho_Availability.csv"
PRISM.file <- "PRISM_ppt_CraigMountain_1900-2018.csv"
excel.file <- "Lander-HAF_preferred_species_cover-031215.xlsx"
multi.excel.file <- "GPS_Collars_Example.xlsx"
web.file <- "ftp://ftp.ncdc.noaa.gov/pub/data/noaa/isd-history.csv"

data.path <- "C:\\Users\\jakal\\OneDrive - University of Idaho\\Documents\\GitHub\\REM504-DataScience\\Practice_Datasets"

## Set a working directory (this will work for today, but I don't normally do this.)
setwd(data.path)

###########################################################
## Reading from CSV files
###########################################################

# Import data from a CSV file - will turn string fields into factors!
# Check help file (?read.csv) for defaults
rapideye.data <- read.csv(RapidEye.file, header = TRUE)
summary(rapideye.data)

# Overwrite the rapideye.data object, treat strings as character fields
rapideye.data <- read.csv(RapidEye.file, header = TRUE, stringsAsFactors = FALSE)
summary(rapideye.data)

# Use read.table instead - does the same thing as read.csv, but need to 
# specify the separator and fill option for missing values.
# Useful if you have data that uses tabs or some other delimiter.
rapideye.data <- read.table(RapidEye.file, sep=",", header = TRUE, stringsAsFactors = FALSE, fill = TRUE)


# Import CSV data where you need to skip some header lines
prism.data <- read.csv(PRISM.file, header = TRUE, skip = 10)

###########################################################
## Reading data from Excel files
###########################################################

# Import a Worksheet from an Excel Workbook - will take first worksheet as default
### HINT: the read_excel function will not work if you have the file open in Excel. Close it first.
excel.data <- read_excel(excel.file)

# Import a specific worksheet from EXcel
excel.data <- read_excel(excel.file, sheet="Plot Totals")

# Example of importing multiple sheets from an Excel Workbook
## This example assumes that the data structure is the same in each of the sheets
## There's lots of ways to do this. For this example, I'll read each sheet in and
##    append it to a data frame so in the end I'll have a single data frame.

# Get a list of the sheets in the Excel workbook
excel.sheets <- excel_sheets(multi.excel.file)

# Set up an empty data frame to hold the results
gps.data <- data.frame()

# iterate over each sheet in the excel file and append it to the data frame
for (current.sheet in excel.sheets) {
  sheet.data <- read_excel(multi.excel.file, sheet=current.sheet, col_names=FALSE)
  gps.data <- rbind(gps.data,sheet.data)
}

# in the case of my data, I didn't have column names, so add those now
names(gps.data) <- c("pdop","lat","lon","numSats","date","time","ttff","ttlf","ttbf")


###########################################################
### Import data from a website
###########################################################

## Note that this only works this simply if you're accessing a file that is
## stored on a web server or FTP site. Accessing data via an API or through
## a site where you have to do a search/query/order is more complicated.
## We'll cover that in a later class lecture

web.data <- read.csv(url(web.file), header = TRUE, stringsAsFactors = FALSE)

###########################################################
## Writing data out to files
###########################################################

# Export R data to a CSV file
write.csv(web.data, file="some_data_to_save.csv")
