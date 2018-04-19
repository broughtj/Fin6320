using DataFrames

function MovingAverageStrategy(x::Array{Float64,1}, long::Int64=40, short::Int64=5)
	N = length(x)
	signals = Array{Float64,1}(N-long)
	
	for i in 1:(N - long)
		iend = i + long - 1 
		ibeg = i + long - short
		malong = mean(x[i:iend])
		mashort = mean(x[ibeg:iend])
		signals[i] = sign(malong - mashort)
	end

	signals
end


function StationaryBootstrap(y::Array{Float64,1}, m::Int64, B::Int64)
	N = length(y)
	ystar = zeros(B, N)
	u = rand(1:N, N)
	q = 1 / m

	for b in 1:B
		u = rand(1:N, N)
		v = rand(N)

		for t in 2:N
			if v[t] < q
				u[t] = rand(1:N)
			else
				u[t] = u[t] + 1
				if u[t] > N
					u[t] = u[t] - N
				end
			end
		end

		ystar[b,:] = y[u]
	end

	ystar
end


## Read data and transfor to log-prices and spread
raw = readtable("petro.csv")
lnCL = log.(convert(Array, raw[:Crude]))
lnHO = log.(convert(Array, raw[:Heating]))
sprd = lnHO - lnCL

## Generate signals and calculate loss, relative loss
signals = MovingAverageStrategy(sprd)
long = 40
δ = -diff(signals .* sprd[(1+long):end])
δ0 = diff(lnCL[(1+long):end])
d = δ0 - δ

## Bootstrap the relative loss values
m = 10
B = 10000
dstar = StationaryBootstrap(d, m, B)
dstar

## Calculate the SPA test statistic
dbar = mean(d)
dbar_b = mean(dstar,2)
(bob,n) = size(dstar)
w_hat2 = mean((sqrt(n) * dbar_b - sqrt(n) * dbar).^2)
t_spa = max((sqrt(n) * dbar) / sqrt(w_hat2), 0.0)

