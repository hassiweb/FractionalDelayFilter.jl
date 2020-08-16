module FractionalDelayFilter

using Distributions
using LinearAlgebra
using DSP

export filtord, getfdfcoef, fdfilter, fdfilter!

function filtord(D; maxorder=-1)
    # Input arguments:
    #   - D: delay in sample
    # Output: Filter order that satisfies causal filter
    if maxorder < 0
        return convert(Int, floor(2D+1))
    else
        return min(convert(Int, floor(2D+1)), maxorder)
    end
end

function getfdfcoef(N, D)
    # Input arguments:
    #   - N: Filter Order
    #   - D: delay in sample
    # Output:
    #   - fdfcoef: Filter coefficient
    #   - M: Non-zero sample index
    
    U = vandermonde(N+1)
    Q = invcramer(U)  # inverse matrix by using Cramer's rule
    T = transmat(N)
    Qf = T*Q
    
    # Fractional delay: d
    # The first non-zero sample index: M
    d = D%1
    if mod(N,2)==0  # even
        M = convert(Int, round(D+0.5,RoundNearestTiesAway) - N/2)
    else  # odd
        M = convert(Int, floor(D) - (N-1)/2)
    end
    fdfcoef = transpose(transpose(d.^(0:N)) * Qf)
    return (fdfcoef, M)
end

function fdfilter(in, fdfcoef)
    # By using the modified Farrow structure, a value of inputted delay is updated as follow: D'=D+1
    # This means that the first value of the output of the filter is useless.
    return conv(in, fdfcoef)[2:end]
end

function fdfilter!(delayedsignal, in, fdfcoef, nonzeroindex)
    delayedsignal[1+nonzeroindex:length(in)+nonzeroindex+length(fdfcoef)-2] = conv(in, fdfcoef)[2:end]
end

function fdfilter(in::Array{T}, fdfcoef, nonzeroindex) where T
    out = zeros(T, length(in)+length(fdfcoef)-2+nonzeroindex)
    fdfilter!(out, in, fdfcoef, nonzeroindex)
    return out
end

function vandermonde(N::Int)
    out = repeat(convert.(Float64, collect(0:N-1)), 1, N)
    for n = 0:N-1
        @. out[:,n+1] ^= n
    end
    return out
end

function invcramer(in::Array{T}) where T
    N = size(in,1)
    out = zeros(T, N, N)
    for m = 1:N
        for n = 1:N
            out[n,m] = (-1)^(m+n) * det(in[[1:m-1; m+1:N],[1:n-1; n+1:N]])
        end
    end
    out /= det(in)
    return out
end

function transmat(N::Int)
    T = zeros(Float64, N+1, N+1)
    for n = 0:N
        for m = 0:N
            if n >= m
                T[m+1,n+1] = round(N/2,RoundNearestTiesAway)^(n-m) * binomial(n,m)
            end
        end
    end
    return T
end


end
