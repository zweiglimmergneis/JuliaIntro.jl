# JuliaIntro.jl
Introduce the basic concepts of the Julia programming language

To read and examine the BonitoBook-book
- clone the repository
- change into the directory
- then execute

``` julia
using Pkg
Pkg.activate(abspath("."))
Pkg.resolve()
using BonitoBook
BonitoBook.book("julia-intro-topics.md")
```

The book will open in your browser. The first time this will take one or two minutes.