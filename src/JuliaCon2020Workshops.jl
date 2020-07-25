module JuliaCon2020Workshops

using GitCommand
using IJulia

export  getworkshop,
        getworkhops,
        updateworkshop,
        updateworkshops,
        initworkshop

WORKSHOP_DIR = joinpath(dirname(@__DIR__), "workshops")

struct Workshop
    repo::String
    projectname::String
end

workshopdir(ws::Workshop) = joinpath(WORKSHOP_DIR, ws.projectname)

export WORKSHOPS

WORKSHOPS = Dict("LearnJulia"=>Workshop("https://github.com/dpsanders/LearnJulia2020.git", "LearnJulia2020"),
            "LightGraphs"=>Workshop("https://github.com/matbesancon/lightgraphs_workshop.git", "lightgraphs_workshop"),
            "CxxWrap"=>Workshop("https://github.com/barche/cxxwrap-juliacon2020", "cxxwrap-juliacon2020"),
            "DataFrames"=>Workshop("https://github.com/bkamins/JuliaCon2020-DataFrames-Tutorial", "JuliaCon2020-DataFrames-Tutorial"),
            "MLJ"=>Workshop("https://github.com/ablaom/MachineLearningInJulia2020", "MachineLearningInJulia2020"))


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
