module JuliaCon2020Workshops

using GitCommand
using IJulia

export  getworkshop,
        updateworkshop,
        initworkshop,
        showworkshops

WORKSHOP_DIR = joinpath(dirname(@__DIR__), "workshops")

struct Workshop
    repo::String
    projectname::String
    name::String
end

workshopdir(ws::Workshop) = joinpath(WORKSHOP_DIR, ws.projectname)

WORKSHOPS = Dict("LearnJulia"=>Workshop("https://github.com/dpsanders/LearnJulia2020.git", "LearnJulia2020", "Learn Julia via Epidemic Modeling"),
            "LightGraphs"=>Workshop("https://github.com/matbesancon/lightgraphs_workshop.git", "lightgraphs_workshop", "Building and analyzing Graphs at scale with Light Graphs"),
            "CxxWrap"=>Workshop("https://github.com/barche/cxxwrap-juliacon2020", "cxxwrap-juliacon2020", "Wrapping a C++ Library with CxxWrap.jl"),
            "DataFrames"=>Workshop("https://github.com/bkamins/JuliaCon2020-DataFrames-Tutorial", "JuliaCon2020-DataFrames-Tutorial", "A Deep Dive into DataFrames.jl Indexing"),
            "MLJ"=>Workshop("https://github.com/ablaom/MachineLearningInJulia2020", "MachineLearningInJulia2020", "MLJ: A Machine Learning Toolbox for Julia"))

function showworkshops()
    println("The following workshops can be downloaded (by their shortname):")
    println("shortname: Workshop name")
    for (k,v) in pairs(WORKSHOPS)
        println("$k: $(v.name)")
    end
    return nothing
end

function getworkshop(name)
    ws = WORKSHOPS[name]
    repodir = workshopdir(ws)
    isdir(repodir) || mkpath(repodir)
    git() do git
        run(`$git clone $(ws.repo) $repodir`)
    end
end

function updateworkshop(name; force = false)
    currdir = pwd()
    ws = WORKSHOPS[name]
    repodir = workshopdir(ws)
    isdir(repodir) || error("""Workshop: $name is not cloned! Run getworkshop("$name") first""")
    cd(repodir)
    git() do git
        if force
            run(`$git stash -u`)
        end
        println("Note: Please discard the messages below!")
        run(`$git pull`)
    end
    cd(currdir)
    return nothing
end

function initworkshop(name)
    ws = WORKSHOPS[name]
    repodir = workshopdir(ws)
    isdir(repodir) || error("""Workshop: $name is not cloned! Run getworkshop("$name") first""")
    notebook(detached=true, dir=repodir)
    return nothing
end

end
