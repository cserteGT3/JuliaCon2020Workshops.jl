# JuliaCon2020Workshops

With this package, you can download all available workshop materials for [JuliaCon2020](https://juliacon.org/2020/).
You only need to have julia installed (at least version 1.3), every other dependency is included in the package.

## Install

You should install the package with:

```julia
] dev https://github.com/cserteGT3/JuliaCon2020Workshops.jl
  add GitCommand#master
```

You need to add the `GitCommand#master` package in order to get tha package working. (You can just paste the above commands to the Julia REPL.)

## Usage

Print the available workshops:

```julia
using JuliaCon2020Workshops
showworkshops()

The following workshops can be downloaded (by their shortname):
shortname: Workshop name
MLJ: MLJ: A Machine Learning Toolbox for Julia
LightGraphs: Building and analyzing Graphs at scale with Light Graphs
DataFrames: A Deep Dive into DataFrames.jl Indexing
LearnJulia: Learn Julia via Epidemic Modeling
CxxWrap: Wrapping a C++ Library with CxxWrap.jl
```

Then download the selected, with its shortened name:

```julia
getworkshop("MLJ")
```

You can start the jupyter notebooks for any downloaded workshop:

```julia
initworkshop("MLJ")
```

If you've already downloaded a workshop, but you want to update it, you can use the `updateworkshop()` function.
Note, that if you modified any files, the update may conflicts and terminates.
You can discard your changes by using the `force=true` keyword.

```julia
updateworkshop("MLJ")
updateworkshop("MLJ", force=true)
```
