

# MLE

## Binary Dependent Variables
While STATA has seperate commands for different MLE models (`logit`, `nbreg`, etc.),  R combines some models into single commands. We can use `zelig()`, the command we learned earlier, and just change the `model = ` portion. Alternatively, there are commands such as `glm()`, which do the same thing outside of the Zeligverse.  We'll loog at some examples with the `iris` dataset.


```r
library(modelsummary)
library(tidyverse)
library(Zelig)

theme_set(theme_bw())

head(iris)
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1          5.1         3.5          1.4         0.2  setosa
#> 2          4.9         3.0          1.4         0.2  setosa
#> 3          4.7         3.2          1.3         0.2  setosa
#> 4          4.6         3.1          1.5         0.2  setosa
#> 5          5.0         3.6          1.4         0.2  setosa
#> 6          5.4         3.9          1.7         0.4  setosa
summary(iris)
#>   Sepal.Length    Sepal.Width     Petal.Length    Petal.Width   
#>  Min.   :4.300   Min.   :2.000   Min.   :1.000   Min.   :0.100  
#>  1st Qu.:5.100   1st Qu.:2.800   1st Qu.:1.600   1st Qu.:0.300  
#>  Median :5.800   Median :3.000   Median :4.350   Median :1.300  
#>  Mean   :5.843   Mean   :3.057   Mean   :3.758   Mean   :1.199  
#>  3rd Qu.:6.400   3rd Qu.:3.300   3rd Qu.:5.100   3rd Qu.:1.800  
#>  Max.   :7.900   Max.   :4.400   Max.   :6.900   Max.   :2.500  
#>        Species  
#>  setosa    :50  
#>  versicolor:50  
#>  virginica :50  
#>                 
#>                 
#> 
ggplot(iris) +
    geom_point(aes(x = Sepal.Length, y = Petal.Length, color = Species)) +
    geom_hline(yintercept = 2.5) 

ggplot(iris) +
    geom_point(aes(x = Sepal.Width, y = Petal.Width, color = Species)) +
    geom_abline(intercept = -1.9) 
```

<img src="MLE_files/figure-html/unnamed-chunk-1-1.png" width="70%" style="display: block; margin: auto;" /><img src="MLE_files/figure-html/unnamed-chunk-1-2.png" width="70%" style="display: block; margin: auto;" />

This dataset, originally collected by Ronald Fisher, looks at three different species of iris: setosa, versicolor, and virginica. It provides information on the length and width of flowers' petal and sepals. Looking at the data, we can see that setosas are rather distinct, and easy to seperate graphically. Veriscolor and virginia are more similar, so we'll examine them statistically. We can create a new dataframe with the `filter()` command we learned in *Modeling and Wrangling*.


```r
iris.binary <- filter(iris, Species != "setosa")
```

To predict whether a flower is setosa or virginica, we could use a logit model.
```
logit Species Sepal.Length Sepal.Width Petal.Length Petal.Width
```
In R, we estimate a logit by specifying `model = "logit"` in `zelig()`.

```r
iris.logit <- zelig(Species ~ Sepal.Length + Sepal.Width + Petal.Length +
                  Petal.Width, data = iris.binary, 
                  model = "logit", cite = FALSE)
```

IF we want to instead estimate a probit model, in STATA, we change the command.
```
probit Species Sepal.Length Sepal.Width Petal.Length Petal.Width
```
In R, we change `model = `.

```r
iris.probit <- zelig(Species ~ Sepal.Length + Sepal.Width + Petal.Length +
                  Petal.Width, data = iris.binary, 
                  model = "probit", cite = FALSE)
```

```r
models = list(
    `Logit` = from_zelig_model(iris.logit),
    
    `Probit` = from_zelig_model(iris.probit)
)

modelsummary(models = models, stars = TRUE)
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
   <td style="text-align:center;"> −42.638+ </td>
   <td style="text-align:center;"> −23.985+ </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (25.707) </td>
   <td style="text-align:center;"> (13.843) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sepal.Length </td>
   <td style="text-align:center;"> −2.465 </td>
   <td style="text-align:center;"> −1.440 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (2.394) </td>
   <td style="text-align:center;"> (1.272) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sepal.Width </td>
   <td style="text-align:center;"> −6.681 </td>
   <td style="text-align:center;"> −3.778 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (4.480) </td>
   <td style="text-align:center;"> (2.556) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Petal.Length </td>
   <td style="text-align:center;"> 9.429* </td>
   <td style="text-align:center;"> 5.316* </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (4.737) </td>
   <td style="text-align:center;"> (2.435) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Petal.Width </td>
   <td style="text-align:center;"> 18.286+ </td>
   <td style="text-align:center;"> 10.486+ </td>
  </tr>
  <tr>
   <td style="text-align:left;box-shadow: 0px 1px">  </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (9.743) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (5.614) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Num.Obs. </td>
   <td style="text-align:center;"> 100 </td>
   <td style="text-align:center;"> 100 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AIC </td>
   <td style="text-align:center;"> 21.9 </td>
   <td style="text-align:center;"> 21.8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BIC </td>
   <td style="text-align:center;"> 34.9 </td>
   <td style="text-align:center;"> 34.8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Log.Lik. </td>
   <td style="text-align:center;"> −5.949 </td>
   <td style="text-align:center;"> −5.876 </td>
  </tr>
</tbody>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> + p &lt; 0.1, * p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</td></tr></tfoot>
</table>

## Counts
Count models tend to fall into two categories: Poisson and negative binomial. Poisson models assume an even dispersion, with the mean equal to the variance, while negative binomial accout for overdispersed data. 

```r
summary(diamonds)
#>      carat               cut        color        clarity          depth      
#>  Min.   :0.2000   Fair     : 1610   D: 6775   SI1    :13065   Min.   :43.00  
#>  1st Qu.:0.4000   Good     : 4906   E: 9797   VS2    :12258   1st Qu.:61.00  
#>  Median :0.7000   Very Good:12082   F: 9542   SI2    : 9194   Median :61.80  
#>  Mean   :0.7979   Premium  :13791   G:11292   VS1    : 8171   Mean   :61.75  
#>  3rd Qu.:1.0400   Ideal    :21551   H: 8304   VVS2   : 5066   3rd Qu.:62.50  
#>  Max.   :5.0100                     I: 5422   VVS1   : 3655   Max.   :79.00  
#>                                     J: 2808   (Other): 2531                  
#>      table           price             x                y         
#>  Min.   :43.00   Min.   :  326   Min.   : 0.000   Min.   : 0.000  
#>  1st Qu.:56.00   1st Qu.:  950   1st Qu.: 4.710   1st Qu.: 4.720  
#>  Median :57.00   Median : 2401   Median : 5.700   Median : 5.710  
#>  Mean   :57.46   Mean   : 3933   Mean   : 5.731   Mean   : 5.735  
#>  3rd Qu.:59.00   3rd Qu.: 5324   3rd Qu.: 6.540   3rd Qu.: 6.540  
#>  Max.   :95.00   Max.   :18823   Max.   :10.740   Max.   :58.900  
#>                                                                   
#>        z         
#>  Min.   : 0.000  
#>  1st Qu.: 2.910  
#>  Median : 3.530  
#>  Mean   : 3.539  
#>  3rd Qu.: 4.040  
#>  Max.   :31.800  
#> 
```

## Rare-events and Zero-inflation
