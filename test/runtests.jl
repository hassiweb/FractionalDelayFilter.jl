using FractionalDelayFilter
using Test

@testset "Max filter order" begin
    delaystep = 0.25
    delays = 0.0:delaystep:5.0
    numdelays = length(delays)
    fdfcoefs = Vector{Vector{Float64}}(undef, numdelays)
    nonzeroindices = Vector{Int}(undef, numdelays)
    filterorders = Vector{Int}(undef, numdelays)
    sinewave = sin.(0:π/40:4π)

    maxorder = 3
    @testset "Odd value: $maxorder" begin
        for delayindex = 1:numdelays
            filterorders[delayindex] = filtord(delays[delayindex], maxorder=maxorder)
            (fdfcoefs[delayindex], nonzeroindices[delayindex]) = getfdfcoef(filterorders[delayindex], delays[delayindex])
        end

        delayedwave = zeros(Float64, length(sinewave)*2, numdelays)
        for delayindex = 1:numdelays
            delayedwave[1+nonzeroindices[delayindex]:length(sinewave)+nonzeroindices[delayindex]+length(fdfcoefs[delayindex])-2,delayindex] = fdfilter(sinewave, fdfcoefs[delayindex])
        end
        @test sortperm(delayedwave[7,:], rev=true) == collect(1:numdelays)
    end

    maxorder = 4
    @testset "Even value: $maxorder" begin
        for delayindex = 1:numdelays
            filterorders[delayindex] = filtord(delays[delayindex], maxorder=maxorder)
            (fdfcoefs[delayindex], nonzeroindices[delayindex]) = getfdfcoef(filterorders[delayindex], delays[delayindex])
        end

        delayedwave = zeros(Float64, length(sinewave)*2, numdelays)
        for delayindex = 1:numdelays
            delayedwave[1+nonzeroindices[delayindex]:length(sinewave)+nonzeroindices[delayindex]+length(fdfcoefs[delayindex])-2,delayindex] = fdfilter(sinewave, fdfcoefs[delayindex])
        end
        @test sortperm(delayedwave[7,:], rev=true) == collect(1:numdelays)
    end
    
end

