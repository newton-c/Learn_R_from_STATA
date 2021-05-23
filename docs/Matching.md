# Matching

## The MarchIt Package
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
