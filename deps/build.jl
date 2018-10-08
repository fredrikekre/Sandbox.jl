# Alternative build process where the package provides a `deps/Project.toml`
# project that Pkg activates and instantiate before running the build script.
#
# The code in this file would be internal to Pkg, and packages would provide
# what's in `make.jl`.

append!(empty!(LOAD_PATH), Base.DEFAULT_LOAD_PATH)
using Pkg

mktempdir() do tmp
    build_project = joinpath(@__DIR__, "Project.toml")
    build_manifest = joinpath(@__DIR__, "Manifest.toml")
    makefile = joinpath(@__DIR__, "make.jl")

    tmp_build_project = joinpath(tmp, "Project.toml")
    tmp_build_manifest = joinpath(tmp, "Manifest.toml")

    # Copy build project to tmp directory
    cp(build_project, tmp_build_project)
    if isfile(build_manifest)
        cp(build_manifest, tmp_build_manifest)
    end
    # Activate and instantiate
    Pkg.activate(tmp_build_project)
    Pkg.instantiate()
    # Run build script
    withenv("JULIA_LOAD_PATH" => tmp_build_project) do
        run(`$(Base.julia_cmd()) --startup-file=no $(makefile)`)
    end
end
