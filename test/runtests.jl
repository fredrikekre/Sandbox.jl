# Alternative test process where the package provides a `test/Project.toml`
# project that Pkg activates and instantiate before running the test script.
#
# The code in this file would be internal to Pkg, and packages would provide
# what's in `tests.jl`.

append!(empty!(LOAD_PATH), Base.DEFAULT_LOAD_PATH)
using Pkg

test_project = @__DIR__
package_project = joinpath(@__DIR__, "..")
testfile = joinpath(@__DIR__, "tests.jl")

Pkg.activate(test_project)
Pkg.instantiate()
Pkg.develop(PackageSpec(path = package_project))

withenv("JULIA_LOAD_PATH" => test_project) do
    run(`$(Base.julia_cmd()) --startup-file=no $(testfile)`)
end
