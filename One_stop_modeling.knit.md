

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
















