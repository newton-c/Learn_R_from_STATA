# Bayesian Models

Bayesian models may seem like a whole new world, with different definitions
of probability, new interprestations, and a suspicious lack of *p-values* 
(how do I know if it's significant? What about the stars?) Bayesian methods
are very similary to maximumlikehihood, however. If fact, under two conditions, 
Bayesian and ML models will give you the exact same answer. The first is as
*N* approaches infinity. Of course this never actually occurs, but if you
have enough observations, Bayesian and ML models will be the same. One advantage
of Bayesian analysis, is that it often outperforms ML when your dataset is small.
The second condition under which Bayesian and ML models give the same answer, is
when the Bayesian priors are flat. 

## Using STAN in R
The `rstanarm` package makes basic Bayesian modeling easy. It copies the syntax from
common R packages for GLMs and multilevel modeling so there is little learnin curve.

