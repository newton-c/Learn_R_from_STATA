# Linear Regression

Now we'll look at plain old OLS.  In STATA this is done using the command `reg`. In R, OLS is run using the command `lm()`. This is part of base-R, so there are no packages to install, you just start R and you're ready to go. 

While STATA seperates each part of the regression with a space, R wraps everything in parentheses. You don't have to include any spaces between the elements inside the pathenses, but it best to do so, for readability. You do have to add `~`, `+`, and `:`. `~` goes between the dependent variabale, and the rest of the equation, `+` seperates the rest of the variables in an additive model, and `:` indicates a multiplitcative interation. So 

```lm(y ~ x1 + x2 + x1:x2, data = stata.data)```

in R is the same as 

```
gen x1x2 = x1*x2
reg y x1 x2 x1x2
``` 
in STATA.

This R code could also be written: 
```
lm(stata.data$y ~ stata.data$x1 + stata.data$x2 + 
    stata.data$x1:stata.data$x2)
```
And just to add even more variety, one could also write:
```
attach(stata.data)
lm(y ~ x1 + x2 + x1:x2)
```

## Which way should you write your model?
Starting with `attach(stata.data)` is likely to be most comfortable for STATA users. This method loads a single dataframe into the environment (in this case stata.data) and now any variable you reference is assumed to belong to that dataframe. If you call a variable that doesn't exist in the dataframe, you see the message `Error in eval(predvars, data, env) : object 'variable' not found` where `'variable'` is that name of the non-existant variable you tried to call. 

If you want to switch to another dataframe, you simply write `detach(stata.data)` and then attach another dataframe (i.e. `attach(stata.data2)`). Note that `detach()` will not remove the data from the environment, it only removes it from being the default for calling variables. If you want to remove the data completly, type `rm(stata.data)`.

While this may be the most similar to the way you're used to working with dataframes in STATA, one of the advantages of R is that you can work with various different dataframes at the same time. You can alsways indicate which dataframe a variable belongs to by writeing `dataframe$variable`. This is seen in the second example above and is quite specific, but requires specifying the dataframe for every variable. This can be tedious. Adding `data = dataframe` is a nice balance where you only have to specify the data once per model, but you can still access different dataframes without constantly typing `detach()` and `attach()`.  

## Viewing the results
If you simply run the `lm()` command without assigning it to an object, the results will print in the console. If you do assign you model to an object, you can access the results with the `summary()` command. Here's an example using the `ToothGrowth` dataset, which examines the role of vitimins in the rate of guinea pigs' tooth growth. 


```r
data("ToothGrowth")
dat <- data.frame(ToothGrowth)

model <- lm(len ~ supp + dose, data = dat)
summary(model)
```

```
## 
## Call:
## lm(formula = len ~ supp + dose, data = dat)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -6.600 -3.700  0.373  2.116  8.800 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)   9.2725     1.2824   7.231 1.31e-09 ***
## suppVC       -3.7000     1.0936  -3.383   0.0013 ** 
## dose          9.7636     0.8768  11.135 6.31e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 4.236 on 57 degrees of freedom
## Multiple R-squared:  0.7038,	Adjusted R-squared:  0.6934 
## F-statistic: 67.72 on 2 and 57 DF,  p-value: 8.716e-16
```

You can combine the results of numerous models into a single (publication ready) table as we've seen before.


```r
library(modelsummary)

cn = c(
    "suppVC" = "Supplement Type",
    "dose" = "Dose (mg/day)"
)

modelsummary(models = model, coef_map = cn, stars = TRUE)
```

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> Model 1 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Supplement Type </td>
   <td style="text-align:center;"> -3.700*** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (1.094) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Dose (mg/day) </td>
   <td style="text-align:center;"> 9.764*** </td>
  </tr>
  <tr>
   <td style="text-align:left;box-shadow: 0px 1px">  </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.877) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Num.Obs. </td>
   <td style="text-align:center;"> 60 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 </td>
   <td style="text-align:center;"> 0.704 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Adj. </td>
   <td style="text-align:center;"> 0.693 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AIC </td>
   <td style="text-align:center;"> 348.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BIC </td>
   <td style="text-align:center;"> 356.8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Log.Lik. </td>
   <td style="text-align:center;"> -170.208 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> F </td>
   <td style="text-align:center;"> 67.718 </td>
  </tr>
</tbody>
<tfoot>
<tr>
<td style="padding: 0; border:0;" colspan="100%">
<sup></sup> * p &lt; 0.1, ** p &lt; 0.05, *** p &lt; 0.01</td>
</tr>
</tfoot>
</table>
