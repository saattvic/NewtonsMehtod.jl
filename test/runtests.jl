using NewtonsMethod
using Test

@testset "NewtonsMethod.jl" begin
    atol = 1e-4
    f1(x) = 2x+1
    g1(x) = 2
    f2(x) = (x-1)^2
    g2(x) = 2(x-1)
    f3(x) = exp(x)-1
    g3(x) = exp(x)
    f4(x) = 2 + x^2
    g4(x) = 2x

    # Tests for known functions - analytical derivatives
    @test isapprox(newtonroot(f1, g1; x₀ = 10.0).value, -0.5, atol=atol)
    @test isapprox(newtonroot(f2, g2; x₀ = 10.0).value, 1.0, atol=atol)
    @test isapprox(newtonroot(f3, g3; x₀ = 10.0).value, 0.0, atol=atol)

    # Tests for known functions - automatic derivatives
    @test isapprox(newtonroot(f1; x₀ = 10.0).value, -0.5, atol=atol)
    @test isapprox(newtonroot(f2; x₀ = 10.0).value, 1.0, atol=atol)
    @test isapprox(newtonroot(f3; x₀ = 10.0).value, 0.0, atol=atol)

    # Tests using BigFloat
    @test isapprox(newtonroot(f1, g1; x₀ = BigFloat(10.0)).value, -0.5, atol=atol)
    @test isapprox(newtonroot(f2, g2; x₀ = BigFloat(10.0)).value, 1.0, atol=atol)
    @test isapprox(newtonroot(f3, g3; x₀ = BigFloat(10.0)).value, 0.0, atol=atol)
    @test isapprox(newtonroot(f1; x₀ = BigFloat(10.0)).value, -0.5, atol=atol)
    @test isapprox(newtonroot(f2; x₀ = BigFloat(10.0)).value, 1.0, atol=atol)
    @test isapprox(newtonroot(f3; x₀ = BigFloat(10.0)).value, 0.0, atol=atol)

    # Tests for non-convergence handling
    @test isnothing(newtonroot(f4, g4; x₀ = 10.0).value)
    @test isnothing(newtonroot(f4; x₀ = 10.0).value)

    # Tests that maxiter is working
    @test newtonroot(f4, g4; x₀ = 10.0, maxiter = 5).iter == 6
    @test newtonroot(f4; x₀ = 10.0, maxiter = 5).iter == 6

    # Tests that tol is working
    @test abs(newtonroot(f2, g2; x₀ = 10.0, tol = 1e-1).value - 1.0) > 
          abs(newtonroot(f2, g2; x₀ = 10.0, tol = 1e-10).value - 1.0)
    @test abs(newtonroot(f2; x₀ = 10.0, tol = 1e-1).value - 1.0) >
          abs(newtonroot(f2; x₀ = 10.0, tol = 1e-10).value - 1.0)
    @test abs(newtonroot(f3, g3; x₀ = 10.0, tol = 1e-1).value) > 
          abs(newtonroot(f3, g3; x₀ = 10.0, tol = 1e-10).value)
    @test abs(newtonroot(f3; x₀ = 10.0, tol = 1e-1).value) >
          abs(newtonroot(f3; x₀ = 10.0, tol = 1e-10).value)
end
