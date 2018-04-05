M <- 10000
beta.hat <- rep(0, M)
rsqrd <- rep(0, M)
tstat <- rep(0, M)


for(i in 1:M)
{
  y <- cumsum(rnorm(500))
  x <- cumsum(rnorm(500))
  fit <- summary(lm(y ~ x))
  #beta.hat[i] <- coef(fit)[2]
  beta.hat[i] <- fit$coefficients[2,1]
  rsqrd[i] <- fit$r.squared
  tstat[i] <- fit$coefficients[2,3]
}

hist(beta.hat, breaks = 50)