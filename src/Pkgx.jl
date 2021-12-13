using Pkg
using FilePathsBase
using TOML

module Pkgx

export add

function add(pkg::String; bindir=joinpath(home(), ".local", "bin"))
    # Start off adding the package to a temp environment
    dir = mktempdir()
    Pkg.activate(dir)
    Pkg.add(pkg)

    # Check for an "Application.toml" file
    appconfig = joinpath(parent(parent(Path(Base.find_package(pkg)))), "Application.toml")
    if exists(appconfig)
        entrypoints = TOML.parsefile(string(appconfig))["entrypoints"]
    else
        entrypoints = Dict{String,String}()
        entrypoints[lowercase(pkg)] = "julia_main"
    end #if

    # Create a place for the environment to live permanently
    dest = mkpath(joinpath(home(), ".local", "share", "Pkgx", "environments", pkg))
    cp(joinpath(dir, "Project.toml"), dest)
    cp(joinpath(dir, "Manifest.toml"), dest)

    # Create shims
    for pt in entrypoints
        execname = pt.first
        execpath = joinpath(pt.first, execname)
        funname = pt.second
        shimtext =
        """
        #!/bin/sh
        julia --project=$dest -e 'using $pkg; $pkg.$funname()'
        """
        open(string(execpath)) do f
            write(f, shimtext)
        end #do
        chmod(execpath, "+x")
    end #for

end #function

end
