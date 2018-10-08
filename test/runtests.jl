# Alternative test process where the package provides a `test/Project.toml`
# project that Pkg activates and instantiate before running the test script.
#
# The code in this file would be internal to Pkg, and packages would provide
# what's in `tests.jl`.

append!(empty!(LOAD_PATH), Base.DEFAULT_LOAD_PATH)
using Pkg

mktempdir() do tmp
    test_project = joinpath(@__DIR__, "Project.toml")
    test_manifest = joinpath(@__DIR__, "Manifest.toml")
    package_project = joinpath(@__DIR__, "..", "Project.toml")
    testfile = joinpath(@__DIR__, "tests.jl")

    tmp_test_project = joinpath(tmp, "Project.toml")
    tmp_test_manifest = joinpath(tmp, "Manifest.toml")

    # Copy test project to tmp directory
    cp(test_project, tmp_test_project)
    if isfile(test_manifest) # ??
        cp(test_manifest, tmp_test_manifest)
    end
    # Activate and instantiate
    Pkg.activate(tmp_test_project)
    Pkg.instantiate()
    Pkg.develop(PackageSpec(path = dirname(package_project)))
    # Run tests
    withenv("JULIA_LOAD_PATH" => tmp_test_project) do
        run(`$(Base.julia_cmd()) --startup-file=no $(testfile)`)
    end
end
