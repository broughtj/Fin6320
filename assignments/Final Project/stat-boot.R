library(tseries)

MovingAverageStrategy <- function(x, long = 40, short = 5)
{
	N <- length(x)
	signals <- rep(0, (N - long))

	for(i in 1:(N - long))
	{
		iend <- i + long - 1
		ibeg <- i + long - short
		malong <- mean(x[i:iend])
		mashort <- mean(x[ibeg:iend])
		signals[i] <- sign(malong - mashort)
	}

	return(signals)
}


# Main
raw <- read.csv("petro.csv", header=T)
lnCL <- log(raw$Crude)
lnHO <- log(raw$Heating)
sprd <- lnHO - lnCL

## Generate signals and calculate loss, relative loss
signals <- MovingAverageStrategy(sprd)
long <- 40
N <- length(sprd)
del.k <- -diff(signals * sprd[(1+long):N])
del.0 <- diff(lnCL[(1+long):N])
d = del.0 - del.k


## Bootstrap the relative loss values
m <- 10
B <- 10000
dstar <- tsbootstrap(d, nb=B, b=m, type="stationary")
