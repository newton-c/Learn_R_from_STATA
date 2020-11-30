Introduction
================

*R for STATA Users* is a book designed to take researchers that are
already is profecient in STATA, and show them how to do the same
analyses in R. The hope is that by starting with what the reader is
already comfrotable and showing how to replicate their code in R, the
transition to open source software will be gentle. After covering the
basics, the book then moves on to more R specific lessons that may
introduce techniques that aren’t commonly seen in STATA.

This book will show snipets of STATA code, such as:

    reg dep_var ind_var control_var1 control_var3

followed by the corresponding R code to produce the same result. In this
case:

    lm(dep_var ~ ind_var + control_var1 + control_var2, data = example.data)

There will also be addition answer and explanations. For example, the
linear model above can be written differently in R.

    lm(example.data$dep_var ~ example.data$ind_var + example.data$control_var1 + example.data$control_var2)

These models are exactly the same. They all run OLS regression In R, you
can either write the variables by themselves and then specifly which
dataframe they come from, or you can write the dataframe, and $ symbole,
and then the variable name, making wure there are no spaces between
them. More on this later.

## Who is this book for?

## Who isn’t this book for?
