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


function HansenSPATest(d::Array{Float64,1}, dstar::Array{Float64,2})
	dbar = mean(d)
	dbar_b = mean(dstar,2)
	(B,n) = size(dstar)
	w_hat2 = mean((sqrt(n) * dbar_b - sqrt(n) * dbar).^2)
	t_spa = max((sqrt(n) * dbar) / sqrt(w_hat2), 0.0)

	gl = max(0.0, dbar)
	gu = dbar
	rhs = -sqrt((w_hat2 / n) * 2 * log(log(n)))
	ind = 0.0
	if dbar >= rhs
		ind = 1.0
	end
	gc = dbar * ind
	
	Zl = dstar - gl
	Zc = dstar - gc
	Zu = dstar - gu

	Zlbar = mean(Zl, 2)
	Zcbar = mean(Zc, 2)
	Zubar = mean(Zu, 2)

	z_spa_l = max.((sqrt(n) .* Zlbar) / sqrt(w_hat2), 0.0)
	z_spa_c = max.((sqrt(n) .* Zcbar) / sqrt(w_hat2), 0.0)
	z_spa_u = max.((sqrt(n) .* Zubar) / sqrt(w_hat2), 0.0)

	p_spa_l = 0.0
	p_spa_c = 0.0
	p_spa_u = 0.0

	for b in 1:B
		if z_spa_l[b] > t_spa
			p_spa_l += 1.0
		end

		if z_spa_c[b] > t_spa
			p_spa_c += 1.0
		end

		if z_spa_u[b] > t_spa
			p_spa_u += 1.0
		end
	end

	p_spa_l /= B
	p_spa_c /= B
	p_spa_u /= B

	return (p_spa_l, p_spa_c, p_spa_u)
end

function main()
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


	## Now run Hansen's SPA test and get p-values
	(pl, pc, pu) = HansenSPATest(d, dstar)
end
