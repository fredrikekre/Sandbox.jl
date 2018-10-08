# Alternative build process where the package provides a `deps/Project.toml`
# project that Pkg activates and instantiate before running the build script.
#
# The code in this file would be internal to Pkg, and packages would provide
# `make.jl`.

append!(empty!(LOAD_PATH), Base.DEFAULT_LOAD_PATH)
using Pkg

project = @__DIR__
make = joinpath(@__DIR__, "make.jl")

Pkg.activate(project)
Pkg.instantiate()

run(`$(Base.julia_cmd()) --startup-file=no --project=$(project) $(make)`)
