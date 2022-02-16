module NewtonsMethod

using ForwardDiff, LinearAlgebra

export newtonroot

function iterativesolver(f, x₀, checkconvergence, updatex)
    xold = x₀.*10
    fold = 10*f(x₀)
    xnew = x₀
    fnew = f(xnew)
    iter = 1
    while !checkconvergence(xold, xnew, fold, fnew, iter)
        xold = xnew
        xnew = updatex(f, xold)
        fold = fnew
        fnew = f(xnew)
        iter += 1
    end
    return(value = xnew, iter=iter)
end

function newtonroot(f, f′; x₀, tol=1e-7, maxiter=1000)
    res = iterativesolver(f,
                          x₀,
                          (xold, xnew, fold, fnew, iter) -> norm(xnew - xold) < tol || iter > maxiter,
                          (f, x) -> x - f(x) / f′(x))
    if res.iter <= maxiter
        return res
    else
        return (value = nothing, iter=res.iter)
    end
end

function newtonroot(f; x₀, tol=1e-7, maxiter=1000)
    return newtonroot(f, x -> ForwardDiff.derivative(f, x); x₀, tol, maxiter)
end

end
