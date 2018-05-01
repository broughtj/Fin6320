# Read in the data, and organize
raw <- read.csv("petro.csv", header=T)
lnHO <- log(raw$Heating)
lnCO <- log(raw$Crude)
N <- length(lnHO)

# Step 1 of Engle-Granger
fit <- lm(lnHO ~ lnCO)
z <- fit$residuals
## NB: now you would do an ADF test (I'll assume you do that, and it passes)

# Step 2 of Engle-Granger
tmp <- embed(z, 4)[,2]
dat1 <- data.frame(embed(diff(lnHO), 4))
names(dat1) <- c("lnHO.diff", "lnHO.diff.lag1", "lnHO.diff.lag2", "lnHO.diff.lag3")
dat2 <- data.frame(embed(diff(lnCO), 4))
names(dat2) <- c("lnCO.diff", "lnCO.diff.lag1", "lnCO.diff.lag2", "lnCO.diff.lag3")
dat <- cbind(dat1, dat2)
dat$z <- tmp[1:(length(tmp) - 1)] 

## I'm only going to run the VECM(1) model, but you can generalize it
fit1 <- lm(lnHO.diff ~ lnHO.diff.lag1 + lnCO.diff.lag1 + z, data=dat)
fit2 <- lm(lnCO.diff ~ lnHO.diff.lag1 + lnCO.diff.lag1 + z, data=dat)


