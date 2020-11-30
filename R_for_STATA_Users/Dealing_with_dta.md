Dealing with .dta
================

The first step for moving from STATA to R is getting access to your .dta
files. There are multiple packages that can read and write .dta files,
were going to use `haven`.

Haven is not part of base-R, so it has to be installed if you haven’t
done so before. One a package has been installed on a system, however,
you don’t need to reinstall it. You should already know now to install
packages, from the previous chapter. With have in stalled, put
`library(haven)` at the top of you R script. R scripts (as with scripts
in all programming languages) with the first line and goes through the
program. As long as `library(haven)` appears in you file before you
attept to use it, you should be fine. That being said, the convention is
to put all packages used at the beginning of your script, with each
being on a new line (ex: *figure 1*).

*figure 1*

``` r
library(dplyr)
library(ggplot2)
library(haven)
```

Below the packages that you’ll be using, you then need to import your
data. This is done with the command `read_dta()`. As you probably want
to actually load the data into the environment, and not just print the
observations in the colsole, you’ll have to assign the data a name. In
R, names can contain uppercase and lowercase letter, numbers,
underscores, and periods. An object name cannot, contain spaces, begin
with a number, or contain symbols such as $ or %. Also, names cannot be
the same as a function in base-R or any of the packages you are using.

    my.data <- read_dta('data.dta') # this works
    MyDaTa <- read_dta('data.dta') # so does this
    
    sum <- read_dta('data.dta') # this doesn't, sum() is a function in base-R
    
    data2 <- read_dta('data.dat') # this is fine
    2data <- read_dta('data.dat') # this isn't

Names are assigned by using `<-`, typically with a space before and
after (though this isn’t necessary, it keeps the code clean and easy to
read). To load your data, give it a name (that conforms with R’s rules)
followed by `<-` and then `read_dta()`. If your data is in your working
directory, you can simply write the file name inside either single (’’)
or double ("") quotes. To find you working directory, type `getwd()`
into the console.

If your file is in a subdirectory of your workind directory, you can
simple speficy the subdirectiory. For example, if you keep all of your
datasets in a folder ‘data’, you would type `read_dta('data/data.dta')`.
If you data is outside of your working directory, you can specify the
complete file path. for example
`read_dta('~/home/user/Desktop/datasets/data.dta')`
