using FractionalDelayFilter
using Documenter

makedocs(;
    modules=[FractionalDelayFilter],
    authors="hassiweb <nryk.hashimoto@gmail.com>",
    repo="https://github.com/hassiweb/FractionalDelayFilter.jl/blob/{commit}{path}#L{line}",
    sitename="FractionalDelayFilter.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://hassiweb.github.io/FractionalDelayFilter.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/hassiweb/FractionalDelayFilter.jl",
)
