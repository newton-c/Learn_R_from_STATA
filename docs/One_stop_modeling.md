

# One Stop Modeling: Zelig

Zelig is a statistical software originally created by Kosuke Imai, Gary King, and Olivia Lau. It attampts to unify different models, 
tests, vizualizations, and other statistical activities into a single framework. R is not a piece of software, it is an open source 
programing language. As such, as it has adapted and grown, different people have created different packages. This is a strength
as it keeps R flexible and on the cutting-edge of statistics, but it means that there is often inconsistency. There are variaous 
packages in R that you can use for different models; Zelig was created to keep the syntax consistent and make using different models as
simple as changind a single command. More information on Zelig can be found on its 
[\textcolor{blue}{website}](https://zeligproject.org/).

In addition to running your typical statistical models, Zelig also replicates Clarify from STATA, integrates with 
multiple imputation methods (through the package `Amelia`) as well as matching methods (through the packages `cem` and `MatchIt`)

The generic syntax for statistical models in Zelig is as follows

```
zelig(y ~ x1 + x2 + x3, data = example.data, model = "model.type")
```

This syntax is very similar to most other models, but with the added arguement `model = ` in order to specifiy what you're running. If
we wanted to replicate the model we estimated in Chapter 3, this is how it'd look.

```r
library(tidyverse)
library(Zelig)

theme_set(theme_classic())

data("Titanic")
titanic.data <- data.frame(Titanic)
titanic.expanded <- uncount(titanic.data, Freq)

titanic.logit <- zelig(Survived ~ Class + Sex + Age, 
    data = titanic.expanded, model = "logit")
#> How to cite this model in Zelig:
#>   R Core Team. 2007.
#>   logit: Logistic Regression for Dichotomous Dependent Variables
#>   in Christine Choirat, Christopher Gandrud, James Honaker, Kosuke Imai, Gary King, and Olivia Lau,
#>   "Zelig: Everyone's Statistical Software," https://zeligproject.org/
```
As you can see, Zelig automatically prints the citation for the model your using. This can be very useful when preparing your 
references for a project, but very annoying when you're running a bunch of models. Adding `cite = FALSE` (or `cite = F`)
will stop this. 

```r
summary(titanic.logit)
#> Model: 
#> 
#> Call:
#> z5$zelig(formula = Survived ~ Class + Sex + Age, data = titanic.expanded)
#> 
#> Deviance Residuals: 
#>     Min       1Q   Median       3Q      Max  
#> -2.0812  -0.7149  -0.6656   0.6858   2.1278  
#> 
#> Coefficients:
#>             Estimate Std. Error z value Pr(>|z|)
#> (Intercept)   0.6853     0.2730   2.510   0.0121
#> Class2nd     -1.0181     0.1960  -5.194 2.05e-07
#> Class3rd     -1.7778     0.1716 -10.362  < 2e-16
#> ClassCrew    -0.8577     0.1573  -5.451 5.00e-08
#> SexFemale     2.4201     0.1404  17.236  < 2e-16
#> AgeAdult     -1.0615     0.2440  -4.350 1.36e-05
#> 
#> (Dispersion parameter for binomial family taken to be 1)
#> 
#>     Null deviance: 2769.5  on 2200  degrees of freedom
#> Residual deviance: 2210.1  on 2195  degrees of freedom
#> AIC: 2222.1
#> 
#> Number of Fisher Scoring iterations: 4
#> 
#> Next step: Use 'setx' method
```

Zelig models can be easily exported to a table for publication-ready results, but the require an additional command, `from_zelig_model()`. 
We can compare the original logit from Chapter 3 to the one above to varify that they're the same.[^1] 

```r
library(modelsummary)

models = list(
    "Ch 3 model" = glm(Survived ~ Class + Sex + Age, 
        data = titanic.expanded, family = 'binomial'),
    
    # using titanic.logit we just estimated above
    "Zelig model" = zelig(Survived ~ Class + Sex + Age, 
    data = titanic.expanded, model = "logit", cite = FALSE) %>% 
        from_zelig_model()
)

modelsummary(models, stars = TRUE)
#> Warning: In version 0.8.0 of the `modelsummary` package, the default significance markers produced by the `stars=TRUE` argument were changed to be consistent with R's defaults.
#> This warning is displayed once per session.
```

<table style="NAborder-bottom: 0; width: auto !important; margin-left: auto; margin-right: auto;" class="table">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> Ch 3 model </th>
   <th style="text-align:center;"> Zelig model </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> (Intercept) </td>
   <td style="text-align:center;"> 0.685* </td>
   <td style="text-align:center;"> 0.685* </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.273) </td>
   <td style="text-align:center;"> (0.273) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Class2nd </td>
   <td style="text-align:center;"> −1.018*** </td>
   <td style="text-align:center;"> −1.018*** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.196) </td>
   <td style="text-align:center;"> (0.196) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Class3rd </td>
   <td style="text-align:center;"> −1.778*** </td>
   <td style="text-align:center;"> −1.778*** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.172) </td>
   <td style="text-align:center;"> (0.172) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ClassCrew </td>
   <td style="text-align:center;"> −0.858*** </td>
   <td style="text-align:center;"> −0.858*** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.157) </td>
   <td style="text-align:center;"> (0.157) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> SexFemale </td>
   <td style="text-align:center;"> 2.420*** </td>
   <td style="text-align:center;"> 2.420*** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.140) </td>
   <td style="text-align:center;"> (0.140) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AgeAdult </td>
   <td style="text-align:center;"> −1.062*** </td>
   <td style="text-align:center;"> −1.062*** </td>
  </tr>
  <tr>
   <td style="text-align:left;box-shadow: 0px 1px">  </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.244) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.244) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Num.Obs. </td>
   <td style="text-align:center;"> 2201 </td>
   <td style="text-align:center;"> 2201 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AIC </td>
   <td style="text-align:center;"> 2222.1 </td>
   <td style="text-align:center;"> 2222.1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BIC </td>
   <td style="text-align:center;"> 2256.2 </td>
   <td style="text-align:center;"> 2256.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Log.Lik. </td>
   <td style="text-align:center;"> −1105.031 </td>
   <td style="text-align:center;"> −1105.031 </td>
  </tr>
</tbody>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> + p &lt; 0.1, * p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</td></tr></tfoot>
</table>
As we can see, the output is identical, proving that either method will work. Now we can look at various different models by simply changing the
`model = ` parpameter. Here's a compariason of a logit, and probit.


```r
models = list(
    "Logit" = zelig(Survived ~ Class + Sex + Age,
                    data = titanic.expanded, 
                    model = "logit", cite = F) %>% 
        from_zelig_model(),
    "Probit" = zelig(Survived ~ Class + Sex + Age,
                     data = titanic.expanded,
                     model = "probit", cite = F) %>% 
        from_zelig_model()
)

modelsummary(models, stars = TRUE)
```

<table style="NAborder-bottom: 0; width: auto !important; margin-left: auto; margin-right: auto;" class="table">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> Logit </th>
   <th style="text-align:center;"> Probit </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> (Intercept) </td>
   <td style="text-align:center;"> 0.685* </td>
   <td style="text-align:center;"> 0.367* </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.273) </td>
   <td style="text-align:center;"> (0.161) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Class2nd </td>
   <td style="text-align:center;"> −1.018*** </td>
   <td style="text-align:center;"> −0.630*** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.196) </td>
   <td style="text-align:center;"> (0.114) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Class3rd </td>
   <td style="text-align:center;"> −1.778*** </td>
   <td style="text-align:center;"> −1.027*** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.172) </td>
   <td style="text-align:center;"> (0.098) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ClassCrew </td>
   <td style="text-align:center;"> −0.858*** </td>
   <td style="text-align:center;"> −0.540*** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.157) </td>
   <td style="text-align:center;"> (0.094) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> SexFemale </td>
   <td style="text-align:center;"> 2.420*** </td>
   <td style="text-align:center;"> 1.450*** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.140) </td>
   <td style="text-align:center;"> (0.080) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AgeAdult </td>
   <td style="text-align:center;"> −1.062*** </td>
   <td style="text-align:center;"> −0.580*** </td>
  </tr>
  <tr>
   <td style="text-align:left;box-shadow: 0px 1px">  </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.244) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.141) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Num.Obs. </td>
   <td style="text-align:center;"> 2201 </td>
   <td style="text-align:center;"> 2201 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AIC </td>
   <td style="text-align:center;"> 2222.1 </td>
   <td style="text-align:center;"> 2224.6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BIC </td>
   <td style="text-align:center;"> 2256.2 </td>
   <td style="text-align:center;"> 2258.8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Log.Lik. </td>
   <td style="text-align:center;"> −1105.031 </td>
   <td style="text-align:center;"> −1106.314 </td>
  </tr>
</tbody>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> + p &lt; 0.1, * p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</td></tr></tfoot>
</table>
You can see all of the supported models, and their specific syntax in the [\textcolor{blue}{Zelig documentation}](http://docs.zeligproject.org/articles/index.html#section-core-zelig-model-details).

## Simulation and Counterfactuals
Zelig can take a model and generate simulated values. This can be particularly useful for plotting counterfactuals.
We'll use the `mtcars` dataset. This is a dataset of various car features for 32 models, from a Motor Trend magazine's 1974
issue. 


```r
data("mtcars")
head(mtcars)
#>                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
#> Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
#> Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
#> Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
#> Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
#> Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
#> Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
```

Let's say we're interested in the effect the that number of cylinders has on a car's fuel effeciency. We'll
start by looking at the data.


```r
table(mtcars$cyl)
#> 
#>  4  6  8 
#> 11  7 14
ggplot(mtcars, aes(x = mpg)) +
    geom_density(fill = "blue", color = "blue", alpha = .3)
```

<embed src="One_stop_modeling_files/figure-html/unnamed-chunk-6-1.pdf" width="70%" height="100%" style="display: block; margin: auto;" type="application/pdf" />
To look at the effect of cylinders *all else equal*, we need to estimate a model.
Miles per gallon is roughly countious and regularly distributed, so we'll use OLS. In addition to the number of cylinders
lets adjust for the weight, horsepower, and the number of gears a car has. 

```r
m1 <- zelig(mpg ~ cyl + wt + hp + gear, data = mtcars, 
            model = "ls", cite = FALSE)
summary(m1)
#> Model: 
#> 
#> Call:
#> z5$zelig(formula = mpg ~ cyl + wt + hp + gear, data = mtcars)
#> 
#> Residuals:
#>     Min      1Q  Median      3Q     Max 
#> -3.4710 -1.7876 -0.6517  1.2362  5.9677 
#> 
#> Coefficients:
#>             Estimate Std. Error t value Pr(>|t|)
#> (Intercept) 36.68953    5.97025   6.145 1.44e-06
#> cyl         -0.81260    0.66320  -1.225  0.23106
#> wt          -3.02263    0.85116  -3.551  0.00143
#> hp          -0.02170    0.01574  -1.379  0.17922
#> gear         0.36259    1.00000   0.363  0.71974
#> 
#> Residual standard error: 2.551 on 27 degrees of freedom
#> Multiple R-squared:  0.8439,	Adjusted R-squared:  0.8208 
#> F-statistic: 36.49 on 4 and 27 DF,  p-value: 1.599e-10
#> 
#> Next step: Use 'setx' method
```
The table shows that adding a cylinder to the engine decreases the average miles per gallon by 0.8. Now we can simulate some values
and visualize the relationship. 

First we have to set the values of interest. Let's see a 4 cylinder vs 8 cylinder car. This is done with the
`setx()` and `setx1()` commands. We then simulate values with `sim()`, and finally plot the results with `plot()`.
This can all be chained together with `%>%`.



```r
par(mar = rep(2, 4))

zelig(mpg ~ cyl + wt + hp + gear, data = mtcars, 
            model = "ls", cite = FALSE) %>% 
    setx(cyl = 4) %>% 
    setx1(cyl = 8) %>% 
    sim() %>% 
    plot()
```

<embed src="One_stop_modeling_files/figure-html/unnamed-chunk-8-1.pdf" width="70%" height="100%" style="display: block; margin: auto;" type="application/pdf" />

We can see from the graphs that a car with 8 cylinders (in blue) is expected to have a lower mgp when
compared to a car with 4 cylinders. That said, there is some overlap in the comparison. 


[^1]: There are two options for converting Zelig's output to a format that's readable for `modelsummary()`. As seen above
you can add a pipe (`%>%`) followed by `from_zelig_model()`. Alternatively, you can wrap the code inside of `from_zelig_model()`. 
For example `from_zelig_model(zelig(Survived ~ Class + Sex + Age, data = titanic.expanded, model = "logit"))`.
Both methods do the same thing, the difference is ultimately asthetic. I prefer using `%>%` as the commands read in the order that they are being executed, where as nesting commands requires you to start near the end of the line and read backwards.
