# Dealing with .dta

There are multiple packages that can read and write .dta files; we're going to use `haven`. Haven is not part of base-R, so it has to be installed if you haven't done so before. With it installed, put `library(haven)` at the top of you R script. 


```r
library(haven)
```

## Using haven to import STATA files
Now you import your data. This is done with the command `read_dta()`. As you probably want to actually load the data into the environment, and not just print the observations in the console, you'll have to assign the data a name. In R, names can contain uppercase and lowercase letters, numbers, underscores, and periods. An object name cannot contain spaces, begin with a number, or contain symbols such as $ or %. Also, names cannot be the same as a function in base-R or any of the packages you are using.

```
my.data <- read_dta('data.dta') # this works
MyDaTa <- read_dta('data.dta') # so does this

# this doesn't work, sum() is a function in base-R
 sum <- read_dta('data.dta') 

data2 <- read_dta('data.dat') # this is fine
2data <- read_dta('data.dat') # this isn't
```

Names are assigned by using `<-`, typically with a space before and after (though this isn't necessary, it keeps the code clean and easy to read). To load your data, give it a name (that conforms with R's rules) followed by `<-` and then `read_dta()`. If your data is in your working directory, you can simply write the file name inside either single ('') or double ("") quotes. To find you working directory, type `getwd()` into the console. 

If your file is in a subdirectory of your working directory, you can simply specify the subdirectiory. For example, if you keep all of your datasets in a folder 'data', and you have a file `data.dta`, you would type `read_dta('data/data.dta')`. If your data is outside of your working directory, you can specify the complete file path. for example `read_dta('~/home/user/Desktop/datasets/data.dta')`. 

## Dealing with errors
The `read_dta()` function supports STATA versions 8-15. If you import your file and it doesn't look right, there may be an issue with interpreting the version. This can be fixed by adding a comma after the file name, followed by `version = ` and then the version of STATA that wrote the file. For example, importing a file from STATA 10 would look like this:
```
stata.data <- read_dta('data/data.dta', version = 10)
```
If there's still an issue, it might be the econding. Before STATA 14, files relied on the default encoding of the system when writing a file. This means that a file written on Windows may not have the same encoding as one written on Mac or Linux. If you get the message `"Unable to convert string to the requested encoding"`, it's probably because STATA saved the default Windows encoding, windows-1252. To fix this, add `encoding = "latin1"` after the version (again seperated with a comma). 
```
stata.data <- read_dta('data/data.dta', version = 10, 
                        encoding = "latin1")
```

Of course, if you saved the file on you own computer or the file was save using STATA 14 or newer, this shouldn't be a problem. 

## But there's still problems
If you're still having errors at this point, the best option is probably to quit. Unistall R, throw your laptop into the sea, fish it our because you're worried about pollution, chuck it in rice because you realize that you started learning R to save money.

Or, start practicing th single most important programming skill there is: looking up the answer on the internet. When something doesn't run, R prints an error message. Copy and paste this error message into the search engine of your choice, and it's likely that someone has already had the same issue, posted about it on Stack Overflow or GitHub, and found a solution. 

## Other data formats

While `.dta` may be the most common format for data files if you use STATA, there are plenty of other formats out there that you'll run into. 

### .Rdata
`.Rdata` is the simplest format to load as it is R's native data format. You simply type `load()` with with file name if the data is in your working directory. Just as with `read_dta()`, if the data isn't in your working directory, you have to specify either the subdirectory or the complete file path. Note, `load()` will import you data with the file name preceding `.Rdata` being the name of the data frame, so `example_data.Rdata` will become an object named `example_data`. You can of course change the name, by writing:
```
new_name <- example_data
rm(example_data)
```

### .csv and other delimited files
One of the most common ways of saving data is with delimited text files. The `readr` package, which is part of the `tidyverse`, comes with three functions for different seperators, as well as a generic delimited file importer. `read_csv()` imports comma seperated files, `read_csv2()` imports semicolon seperated files, and `read_tsv()` imports tab seperated files. `read_delim()` handles everying else as you can specify which the delimiter is. You do this with `delim = 'delimiter'`. For example:

```
# * delimited file
delimited.data <- read_delim(example_data.txt, delim = '*')
```

You can also read delimited files using base-R functions. For example, comma seperated files can be read with `read.csv()`. While using base-R eliminates the need to import a package, the readr functions run more quickly, and are therefore better if you have a large dataset. 

### Excel files
To read Excel files saved as `.xls` or `.xlsx`, use the package `readxl`. For `.xls` files, the command is `read_xls()`, and for `.xlsx` files, it's `read_xlsx()`.

### .json
For `.json` files, the package `jsonlite` is used. To import a dataset, use `fromJSON()`.

## Using multiple dataframes
One advantage of R over STATA is that you can have multiple dataframes loaded into your environment. If you have one main dataset, `data.dta`, you can import it, and then divide it into subsets or variations. If you are running four models, each of which is using a different sample or transformed data, you can create four dataframes (ex: `data1, data2, data3, data4`) and then use each dataframe from each model. If you then want to remove one that you're no longer using, you can do so with `rm()`. 

This can be very usefull when merging. You can import your main dataset and the data you are going to merge in to compare. You can then save the merged data as a third dataframe to compare with the originals to make sure everything looks as it should. 
