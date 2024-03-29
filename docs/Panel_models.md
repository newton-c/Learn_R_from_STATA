

# Panel Models

## Fixed-Effects
The easiest way to include fixed effects is by hand. You can simply add the 
variables you are using to the equation, but they must be the right class. In
R if a variable is a `factor`, then each unique value will automatically have a dummy
variable generated for it. For example, if you want to include country-year fixed-effects
and you have the variables `country` and `year`, the fixed-effects panel model would
be:
```
panel_model <- lm(y ~ x + country + year, data = panel_data)
```
It is crucial that the variable be factor, however. You can check the class of 
the variable with the `class()` command.
```
class(panel_data$country)
class(panel_data$year)
```
If the variables are not already factors, you can convert them with `as.factor`.
You can use this command to generate a new variable, or simply modify the existing
variables in the equation. Both options are shown below.
```
# new variables of class factor
panel_data$country_factor <- as.factor(panel_data$country)
panel_data$year_factor <- as.factor(panel_data$year)

# modifying variables in the equation
panel_model <- lm(y ~ x + as.factor(country) + as.factor(year),
                  data = panel_data)
```



### Adjusting Standard Errors
## Random-Effects
### PML
## Mixed Models
## Multilevel/Hierarchical Models
### `lmer` and `stan_lmer`
