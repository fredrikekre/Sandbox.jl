# Alternative build process where the package provides a `deps/Project.toml`
# project that Pkg activates and instantiate before running the build script.
#
# The code in this file would be internal to Pkg, and packages would provide
# what's in `make.jl`.

append!(empty!(LOAD_PATH), Base.DEFAULT_LOAD_PATH)
using Pkg

build_project = @__DIR__
makefile = joinpath(@__DIR__, "make.jl")

Pkg.activate(build_project)
Pkg.instantiate()

withenv("JULIA_LOAD_PATH" => build_project) do
    run(`$(Base.julia_cmd()) --startup-file=no $(makefile)`)
end
