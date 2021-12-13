using Pkgx
using Documenter

DocMeta.setdocmeta!(Pkgx, :DocTestSetup, :(using Pkgx); recursive=true)

makedocs(;
    modules=[Pkgx],
    authors="Thomas A. Christensen II <25492070+MillironX@users.noreply.github.com> and contributors",
    repo="https://github.com/MillironX/Pkgx.jl/blob/{commit}{path}#{line}",
    sitename="Pkgx.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://MillironX.github.io/Pkgx.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/MillironX/Pkgx.jl",
    devbranch="master",
)
