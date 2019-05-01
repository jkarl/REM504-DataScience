
# Orientation to Dates & Times in R, intro to Lubridate Package 

## What Is Up with Dates and Times?
Dates and times in R need a little extra love, this is because when we simply try to feed what *appears* to be a nicely formatted date into R, R sees the individual numbers instead of a compound date. 

For Example: You can ask R for the date using Sys.Date(), then inspect its class
>today <- Sys.Date()
>
>today
>
>[1] "2019-05-01"
>
>class(today)
>
>[1] "Date" 

You can also get more specific and ask for the time using Sys.time()
>now <- Sys.time()
>
>now
>
>[1] "2019-05-01 05:32:15 UTC" 
>
>class(now)
>
>[1] "POSIXct" "POSIXlt"

But if we try to do it ourselves...
>today <- "2019-05-01"
>
>today 
>
>[1] "2013"
>
>class(today)
>
>[1] "character"

When we punch the numbers in oursleves it is interpreting them as characters sepereated by substraction signs and doing the math for us.
Bottom line is that dates and times need to be translated into special date objects. Luckily this is easy:

+ Use **as.Date** and **as.POSIXct**

as.date: 
>my_date <- as.Date("1991-05-31")
>
>my_date
>
>[1] "1991-05-31"

+ Using **str()** on my_date will reveal that it is a Date object as well as the format of the date. 

as.POSIXct:
>my_time <- as.POSIXct("1991-05-31 07:45:00")
>my_time
>[1] "1991-05-31 07:45:00 CET"

## Date Formatting 
The default date format in R is a four-digit year, two-digit month, and a two-digit day - YYYY-MM-DD, with larger increments of time moving to smaller increments of time as you flow left to right. Here, you must pad with leading zeros if you are using a one-digit month or day. *Ex) 05, not 5*
+ In R, this date format looks like "%Y-%m-%d" 

The '%' followed by a letter (capitalization is important) indicates what unit of time you are trying to code for. 
    For a full list use **?strptime**, see commonly used ones below
    *NOTE:* When using the lubridate package, you will not use the '%' before the letter
	
+ **%Y:** 4-digit year (1991)
+ **%y:** 2-digit year (91)
+ **%m:** 2-digit month (05)
+ **%d:** 2-digit day (31)
+ **%A:** weekday (Friday)
+ **%a:** abbreviated weekday (Fri)
+ **%B:** month (May/January)
+ **%b:** abbreviated month (May/Jan)
+ **%H:** 24 hour
+ **%I:** 12 hour, used in conjunction with %p to indicate am/pm
+ **%M:** minutes as decimal 
+ **%S:** seconds as decimal 
+ **%T:** ISO standard shorthand for %H:%M:%S
+ **%F:** ISO standard shorthand for %Y-%m-%d
+ **%p:** am/pm inidcator 
+ **%z:** timezone offset from UTC if needed

Since R is expecting dates in the order that we call ISO 8601 standard format, "%Y-%m-%d", we must help it infer any non-standard format! 
+If you have the date we used above in the format "1991-31-05", we will get and error because the number in the month position exceeds 
    allowable parameters. So we use **as.Date** and re-format it. 
	
Use the argument 'format' to show what position the expected values are on, mimic seperators. 	
>my_date <- as.Date("1991-31-05", format = "%Y-%d-%m") 

Great. Now we can also do arithmetic with dates.
>my_date +1 
>
>[1] "1991-06-01" 

+Date math could be used in a function with incrementally increasing time 
+You can create a 2nd later date and subtract the earlier date from it to get the difference in days. 
+ Adding to objects created with as.Date will increase them by days, while adding objects created with as.POSIXct will increase them 
    by seconds. 
	
You can also format your dates to print only parts of the date, or dates in non-stamdard arrangements using the format() function
>format(Sys.date() or date object, format = "We've almost made it through %A!"
>
>[1] "We've almost made it through Wednesday!"

OR

>dates <- c("02/27/92", "02/28/92", "01/14/92")
>
>new.dates <- as.Date(dates, "%m/%d/%y")
>
>what.weekday <- format(new.dates, format = "This was a %A")

## Packages to Assist Us 
A lot of the time we aren't modifying single dates or small sets of dates, often we want to import data where there is an entire column
of dates. These packages can help us.

### readr 
+ Load readr using library(readr) 
+ There is a function in this package called **read_csv()**
+ **read_csv()** will recognize dates in multiple common/easily inferred formats

>data <- read_csv("largedataset.csv")

Then we could inspect the date column within our new data frame using str(), lets assume our date column is called DateColumn

>str(data$DateColumn)
>
> Date [1:n] Format: "%F"

Essentially, our date column would be read in as date objects. Yay. 

### anytime 
+ Load anytime using library(anytime) 
+ There is a function in this package called **anytime()**
+ **anytime()** will parse dates and times in various formats out of vectors
+ **anydate()** will parse dates, will not include time zone 

>sep_10_2009 <- c("September 10 2009", "2009-09-10", "10 Sep 2009", "09-10-2009", "09/10/09")
>
>anytime(sep_10_2009) 
>
>[1] "%F UTC" "%F UTC" "%F UTC" "%F UTC"
>
>[5] NA

anytime() was able to infer what many of the formats were, BUT the final date "09/10/09" was too ambiguous and returned an NA

### lubridate 
+ In combination with dplr and tidyverse, lubridate helps us quickly parse dates under various organizational structures
+ **ymd():** This function is telling R that we are dealing with a date arranged as a year, then month, then day. Do we care? Seems a lot like as.Date. 

We do care. ymd() can work past small obstacles, like seperators that are not the standard dashes:

>ymd("2010.01.01")
>
>"2010-01-01"

As well as:

>ymd("2010 Jan 1st")
>
>"2010-01-01"

+ **ymd() Variations:** ydm(), mdy(), myd(), dmy(), dym()
+ And if your date has a time of day with it, no problem! For hours and minutes, you would write ymd_hm

>ymd_hm("2010/01/01 12:15pm")
>
>"2010-01-01 12:15:00 UTC" 

## Plotting Dates 
+ You can pull dates directly out of a date column for plotting as well 

>x <- data$DateColumn 
>plot(x, someY)

Or

>ggplot() +
>
>geom_point(aes(x = x, y = someY)

+ With date objects on our axis, we need to:
1. Specifiy limits as date objects
2. control scale using the scale_x_date() function

+ To limit x-axis between two dates, 2000-01-01 and 2010-01-01
>ggplot(my.data, aes(x = date, y= someY) +
>
>geom_line(aes(group = 1, color = factor(major)) + 
>
>xlim(as.Date("2000-01-01"), as.Date("2010-01-01"))

+ To create breaks every 5 years and display x-axis as years:
>ggplot(my.data, aes(x = date, y= someY) +
>
>geom_line(aes(group = 1, color = factor(major)) + 
>
>scale_x_date(date_breaks = "5 years", date_labels = "%Y")
