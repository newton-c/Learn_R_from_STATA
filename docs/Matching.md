# Matching

## The MarchIt Package
Written by Daniel Ho, Kosuke Imai, Gary King, Elizabeth Stuart, Alex Whitworth,
and Noah Greifer, MatchIt allows a consistent syntax for various different
matching algorithms. As of the writing of this chapter (13 July 2021), MatchIt
supports seven algorithms, witch are: nearest neighbor matching ("nearest", 
on the propensity score by default), optimal pair matching ("optimal"),
optimal full matching ("full"), genetic matching ("genetic"), coarsened 
exact matching ("cem"), exact matching ("exact"), and subclassification
("subclass").

The basic sytax for matching involves specifying an equation for matching on
the treatment vaiable the same way we specifiy an eqation for regression,
with the treatment separated from the rest of the equation with a `~`, and 
the rest of the variable separated by `+` (assuming the equation is additive).
We must also specify the dataset we're using with `data = ` and the algorithm
we want with `method = `.

Using `matchit()`, you can then see how well balanced the matches are using
`summary()`. You will see statistiques about the balance of the original data,
the matched data, as well as information about how many observarions were matched
in the treated group, how many were matched in the control group, and how many
were omitted. 


```
library(MatchIt)
library(modelsummary)
library(tidyverse)
library(Zelig)

m.cem <- matchit(treatment ~ x1 + x2 + x3, 
                 data = dat, method = "cem")
m.gen <- matchit(treatment ~ x1 + x2 + x3, 
                 data = dat, method = "genetic")

m.cem <- match.data(m.cem)
m.gen <- match.data(m.gen)

models = list(
    `CEM` = zelig(y ~ treatment, 
                  data = m.cem, weights = weights) %>% 
        from_zelig_model(),
    
    `Genetic` = zelig(y ~ treatment, 
                      data = m.gen, weights = weights) %>% 
        from_zelig_model()
)

modelsummary(models = models, stars = TRUE)
```
