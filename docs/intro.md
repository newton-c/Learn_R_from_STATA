# Introduction

*Learn R from STATA* is a book designed to take researchers that are already is profecient in STATA, and show them how to do the same analyses in R. The hope is that by starting with what the reader already finds comfrotable and showing how to replicate their code in R, the transition to open source software will be gentle. After covering the basics, the book moves on to more R specific lessons that may introduce techniques that aren't commonly seen in STATA. 


This book will show snipets of STATA code, such as:
```
reg dep_var ind_var control_var1 control_var3
```
followed by the corresponding R code to produce the same result. In this case:
```
lm(dep_var ~ ind_var + control_var1 + control_var2, 
    data = example.data)
```

There will also be additional answers and explanations. For example, the linear model above can be written differently in R.
```
lm(example.data$dep_var ~ example.data$ind_var + 
    example.data$control_var1 + example.data$control_var2)
```

These models are exactly the same. They all run OLS regressions -- you can either write the variables by themselves, and then specifly which dataframe they come from, or you can write the dataframe, and `$` symbol, and then the variable name, making sure there are no spaces between them. More on this later.

## Who is this book for?
This book is for anyone that is already profecient in STATA that would like to learn how to conduct statistical analyses in R. It is primarily written for researchers, educations, and students in quatitative fields.

## Who isn't this book for?
This books assumes that you are already comfortable with STATA and statistics. If you don't already know STATA, this book will not make a lot of sense as the underlying concepts will not be explained. If you are not already familiar with the math and intuition behind statistical models, this book will not be of much help eight. No pure math covered what so ever. There may be some generall discussions on model selection or other topics, but the point of this book is not to explain why you should do something statistically, only to show you how to do something you're already familiar with in STATA using R. This book teaches you
how to read in a new language -- not how to read.

## Setting up R
There are already a number of great tutorials on how install and setup R. As this book is unlikely to provide an even better tutorial, I recommend checking out one of these tutorials:

<!-- Rethink the formatting here. Are the bold and italics in teh right place? -->
- [*Hands-On Programming with R*, by Garrett Grolemund: **A Installing R and RStudio**](https://rstudio-education.github.io/hopr/starting.html)
- [*R for Data Science*, by Hadley Wickham & Garrett Grolemund: **1.4 Prerequisites**](https://r4ds.had.co.nz/introduction.html) 

