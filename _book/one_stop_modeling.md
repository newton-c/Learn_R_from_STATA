# One Stop Modeling: Zelig

Zelig is a statistical software originally created by Kosuke Imai, Gary King, and Olivia Lau. It attampts to unify different models, 
tests, vizualizations, and other statistical activities into a single framework. While there are variaous packages in R that you
can use for different models, using Zelig keeps the syntax consistent. More information on Zelig can be found on its 
[website](https://zeligproject.org/).

In addition to running your typical statistical models, Zelig also replicates Clarify from STATA, integrates with 
multiple imputation methods (through the package `Amelia`) as well as matching methods (through the packages `cem` and `MatchIt`)

The generic syntax for statistical models in Zelig is as follows

```r
library(Zelig)
```

```
## Loading required package: survival
```
```
zelig(y ~ x1 + x2 + x3, data = example.data, model = "model.type")
```

This syntax is very similar to most other models, but with the added arguement `model = ` in order to specifiy what you're running. If
we wanted to replicate the model we estimated in Chapter 3, this is how it'd look.

```r
library(tidyverse)
```

```
## -- Attaching packages --------------------------------------- tidyverse 1.3.0 --
```

```
## v ggplot2 3.3.2     v purrr   0.3.4
## v tibble  3.0.4     v dplyr   1.0.2
## v tidyr   1.1.1     v stringr 1.4.0
## v readr   1.3.1     v forcats 0.5.0
```

```
## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
## x purrr::reduce() masks Zelig::reduce()
## x ggplot2::stat() masks Zelig::stat()
```

```r
data("Titanic")
titanic.data <- data.frame(Titanic)
titanic.expanded <- uncount(titanic.data, Freq)

titanic.logit <- zelig(Survived ~ Class + Sex + Age, 
    data = titanic.expanded, model = "logit")
```

```
## Warning: `tbl_df()` is deprecated as of dplyr 1.0.0.
## Please use `tibble::as_tibble()` instead.
## This warning is displayed once every 8 hours.
## Call `lifecycle::last_warnings()` to see where this warning was generated.
```

```
## Warning: `group_by_()` is deprecated as of dplyr 0.7.0.
## Please use `group_by()` instead.
## See vignette('programming') for more help
## This warning is displayed once every 8 hours.
## Call `lifecycle::last_warnings()` to see where this warning was generated.
```

```
## How to cite this model in Zelig:
##   R Core Team. 2007.
##   logit: Logistic Regression for Dichotomous Dependent Variables
##   in Christine Choirat, Christopher Gandrud, James Honaker, Kosuke Imai, Gary King, and Olivia Lau,
##   "Zelig: Everyone's Statistical Software," http://zeligproject.org/
```

```r
summary(titanic.logit)
```

```
## Model: 
## 
## Call:
## z5$zelig(formula = Survived ~ Class + Sex + Age, data = titanic.expanded)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.0812  -0.7149  -0.6656   0.6858   2.1278  
## 
## Coefficients:
##             Estimate Std. Error z value Pr(>|z|)
## (Intercept)   0.6853     0.2730   2.510   0.0121
## Class2nd     -1.0181     0.1960  -5.194 2.05e-07
## Class3rd     -1.7778     0.1716 -10.362  < 2e-16
## ClassCrew    -0.8577     0.1573  -5.451 5.00e-08
## SexFemale     2.4201     0.1404  17.236  < 2e-16
## AgeAdult     -1.0615     0.2440  -4.350 1.36e-05
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 2769.5  on 2200  degrees of freedom
## Residual deviance: 2210.1  on 2195  degrees of freedom
## AIC: 2222.1
## 
## Number of Fisher Scoring iterations: 4
## 
## Next step: Use 'setx' method
```

Zelig models can be easily exported to a table for publication-ready results, but the require an additional command, `from_zelig_model()`. 
If we wanted to campare the original logit from Chapter 3 to the one above so we can varify that they're the same, we'd run 

```r
library(modelsummary)
```

```
## 
## Attaching package: 'modelsummary'
```

```
## The following object is masked from 'package:Zelig':
## 
##     Median
```

```r
models = list(
    "Ch 3 model" = glm(Survived ~ Class + Sex + Age, 
        data = titanic.expanded, family = 'binomial'),
    # using titanic.logit we just estimated above
    "Zelig model" = from_zelig_model(titanic.logit)
)

modelsummary(models, stars = TRUE)
```

\begin{table}[H]
\centering
\begin{tabular}[t]{lcc}
\toprule
  & Ch 3 model & Zelig model\\
\midrule
(Intercept) & 0.685** & 0.685**\\
 & (0.273) & (0.273)\\
Class2nd & -1.018*** & -1.018***\\
 & (0.196) & (0.196)\\
Class3rd & -1.778*** & -1.778***\\
 & (0.172) & (0.172)\\
ClassCrew & -0.858*** & -0.858***\\
 & (0.157) & (0.157)\\
SexFemale & 2.420*** & 2.420***\\
 & (0.140) & (0.140)\\
AgeAdult & -1.062*** & -1.062***\\
 & (0.244) & (0.244)\\
\midrule
Num.Obs. & 2201 & 2201\\
AIC & 2222.1 & 2222.1\\
BIC & 2256.2 & 2256.2\\
Log.Lik. & -1105.031 & -1105.031\\
\bottomrule
\multicolumn{3}{l}{\textsuperscript{} * p < 0.1, ** p < 0.05, *** p < 0.01}\\
\end{tabular}
\end{table}
As we can see, the output is identical, proving that either method will work. Now we can look at various different models by simple changing the
`model = ` parpameter. Here's a compariason of a logit, and probit.


```r
library(modelsummary)

models = list(
    "Logit" = from_zelig_model(zelig(Survived ~ Class + Sex + Age, 
                                      data = titanic.expanded, model = "logit", 
                                      cite = F)),
    "Probit" = from_zelig_model(zelig(Survived ~ Class + Sex + Age, 
                                       data = titanic.expanded, 
                                       model = "probit", cite = F))
)

modelsummary(models, stars = TRUE)
```

\begin{table}[H]
\centering
\begin{tabular}[t]{lcc}
\toprule
  & Logit & Probit\\
\midrule
(Intercept) & 0.685** & 0.367**\\
 & (0.273) & (0.161)\\
Class2nd & -1.018*** & -0.630***\\
 & (0.196) & (0.114)\\
Class3rd & -1.778*** & -1.027***\\
 & (0.172) & (0.098)\\
ClassCrew & -0.858*** & -0.540***\\
 & (0.157) & (0.094)\\
SexFemale & 2.420*** & 1.450***\\
 & (0.140) & (0.080)\\
AgeAdult & -1.062*** & -0.580***\\
 & (0.244) & (0.141)\\
\midrule
Num.Obs. & 2201 & 2201\\
AIC & 2222.1 & 2224.6\\
BIC & 2256.2 & 2258.8\\
Log.Lik. & -1105.031 & -1106.314\\
\bottomrule
\multicolumn{3}{l}{\textsuperscript{} * p < 0.1, ** p < 0.05, *** p < 0.01}\\
\end{tabular}
\end{table}
