using Merkleville
using Test


@testset "Neighbours" begin
    A = [[-1 1];[1 -1]]
    n1 = Merkleville.get_neighbour(A, 1,1, 1,0)
    @test n1 == 1
    n2 = Merkleville.get_neighbour(A, 1,1, -1,0)
    @test n2 == 1
    n3 = Merkleville.get_neighbour(A, 1,2, 0,1)
    @test n3 == -1
end

