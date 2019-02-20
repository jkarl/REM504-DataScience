## Tidy Data Assignment

This past week we discussed the concept of tidy data and explored some R functions for tidying messy data. For this assignment, I'd like you to take a crack at tidying a particularly messy dataset that is used as one of the projects in the REM 410 class.

In the Practice_Datasets folder of this repo, you'll find a file called __TidyDataPractice_SalsifyData.xlsx__ that contains the data. One look at it and you'll see that it is, indeed, a mess. Aside from the unpardonable sin of mixing results with the data, this dataset has 2 messy problems that will need to be tidied.
1. Data on the same indicator (plant density) are stored in 3 separate tables (though these tables happen to be on the same worksheet) based on the design (or quadrat size)
2. Data on team is stored as column names.

The assignment is as follows:
 - read the Excel file into R (hint, you'll need to specify the cell ranges and read the three data tables in as separate data frames)
 - reformat the data frame(s) from wide to long format.
 - merge the data frames together (use rbind)
 - export the new tidy data as a .CSV file to the GitHub_Practice/tidy_data_assignment folder (put your name in the file name).

I've included a file, __tidied_salsify_data.csv__ here so you can see what your file should look like in the end.

Of course, there are many ways to accomplish this in R, but the following packages and functions might be helpful:
 - the __readxl__ package's __read_excel()__ function.
 - the __dplyr__ package and the __gather()__ function.
 - __rbind()__ for merging data 2Dkeyframes
 - __write.csv()__ for exporting the CSV file

 Let me know if you get stuck or run into any problems!
