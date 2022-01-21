using Documenter
using Czoo
using Dates


makedocs(
    modules = [Czoo],
    sitename="Czoo.jl", 
    authors = "Matt Lawless",
    format = Documenter.HTML(),
)

deploydocs(
    repo = "github.com/lawless-m/Czoo.jl.git", 
    devbranch = "main",
    push_preview = true,
)
