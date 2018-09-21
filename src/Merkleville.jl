module Merkleville
using Random
import Random.rand

struct Town
    A::Matrix{Int64}
    H::Matrix{Int64}
    neighbours::Vector{Tuple{Int64,Int64}}
end

function rand(::Type{Town},r::Int64,c::Int64)
    A = init(r,c)
    H = fill!(similar(A), 0)
    neighbours = [(-1,0),(1,0),(0,-1),(0,1)]
    compute_happiness!(H,A,neighbours)
    Town(A,H,neighbours)
end

function init(r,c=r)
    A = fill(0, r,c)
    rand!(A, [-1,1])
    A
end

function get_neighbour(A,i,j,Δi,Δj)
    r,c = size(A)
    nb = 0
    if 0 < i + Δi <= r
        ip = i+Δi
    else
        ip = i-Δi
    end
    if 0 < j + Δj <= c
        jp = j+Δj
    else
        jp = j-Δj
    end
    A[ip,jp]
end

function compute_happiness(A,i,j,neighbours)
    aij = A[i,j]
    ss = 0
    nb = 0
    for (ii,jj) in neighbours
        nb = get_neighbour(A, i,j,ii,jj)
        if nb == aij
            ss += 1
        end
    end
    ss
end

function compute_happiness!(H::Matrix{T1}, A::Matrix{T2}, neighbours::Vector{Tuple{Int64, Int64}}) where T1 <: Real where T2 <: Real
    r,c = size(A)
    for j in 1:c 
        for i in 1:r
            aij = A[i,j]
            # check neighbours
            H[i,j] = compute_happiness(A, i, j,neighbours)
        end
    end
    H
end

function compute_happiness(A::Matrix{T2},neighbours::Vector{Tuple{Int64, Int64}}) where T2 <: Real
    H = fill(0,r,c)
    compute_happiness!(H, A,neighbours)
end

function compute_happiness!(town::Town)
    compute_happiness!(town.H, town.A, town.neighbours)
end

function step!(town::Town,n=2)
    compute_happiness!(town)
    relocate!(town,n)
end

function simulate!(town::Town,n=2,niter=500,callback=(X)->nothing)
    for i in 1:niter
        step!(town,n)
        callback(town)
        yield()
    end
end

relocate!(town::Town,n::Int64) = relocate!(town, Dict(-1 => n, 1 => n))

function relocate!(town::Town,n::Dict{Int64,Int64})
    A = town.A
    H = town.H
    neighbours = town.neighbours
    K = Vector{CartesianIndex{2}}()
    r,c = size(A)
    for j in 1:c
        for i in 1:r
            if H[i,j] < n[A[i,j]]
                push!(K,CartesianIndex(i,j)) 
            end
        end
    end
    for k1 in K
        a1 = A[k1]
        for k2 in K
            if k1 == k2
                continue
            end
            a2 = A[k2]
            #can we swap these two?
            A[k1] = a2
            A[k2] = a1
            h1 = compute_happiness(A, k1.I[1], k1.I[2], neighbours)
            h2 = compute_happiness(A, k2.I[1], k2.I[2], neighbours)
            #did both increase their happiness?
            if h1 >= H[k2] && h2 >= H[k1]
                H[k2] = h1
                H[k1] = h2
                break
            else
                #they did not; cancel the swap
                A[k1] = a1
                A[k2] = a2
            end
        end
    end
end

end # module
