The Stationary Bootstrap
========================================================
author: Tyler J. Brough, PhD
date: March 28, 2018
autosize: true

First Slide
========================================================

For more details on authoring R presentations please visit <https://support.rstudio.com/hc/en-us/articles/200486468>.

- Bullet 1
- Bullet 2
- Bullet 3

Slide With Code
========================================================


```r
summary(cars)
```

```
     speed           dist       
 Min.   : 4.0   Min.   :  2.00  
 1st Qu.:12.0   1st Qu.: 26.00  
 Median :15.0   Median : 36.00  
 Mean   :15.4   Mean   : 42.98  
 3rd Qu.:19.0   3rd Qu.: 56.00  
 Max.   :25.0   Max.   :120.00  
```

Slide With Plot
========================================================

![plot of chunk unnamed-chunk-2](Stat-Boot-figure/unnamed-chunk-2-1.png)


Artificial Time Series Data
========================================================


```r
N <- 100
e <- rnorm(100)
y <- rep(0, N)
rho <- 0.5
y[1] <- e[1] * sqrt(1 / (1 - rho^2))

for(t in 2:N)
{
    y[t] <- rho * y[t-1] + e[t]
}
```

Slide with Longer Code Chunk
========================================================


```r
m <- 10
q <- 1 / m
B <- 10000
N <- length(y)
ystar <- matrix(0, nrow=B, ncol=N)

for(b in 1:B) {
  u <- sample(1:N, size=N, replace=TRUE)
  for(t in 2:N) {
    v <- runif(1)
    if(v < q) { u[t] <- sample(1:N, size=1) }
    else {
      u[t] <- u[t-1] + 1
      if(u[t] > N) { u[t] <- u[t] - N }
    }
  }
  ystar[b,] <- y[u]
}

c(mean(y), mean(apply(ystar, 1, mean)))
```

```
[1] 0.2171070 0.2178989
```
