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
    name::String
    repo::String
    projectname::String
end

export WORKSHOPS

WORKSHOPS = Dict("LearnJulia"=>Workshop("LearnJulia", "https://github.com/dpsanders/LearnJulia2020.git", "LearnJulia2020"),
            "LightGraphs"=>Workshop("LightGraphs", "https://github.com/matbesancon/lightgraphs_workshop.git", "lightgraphs_workshop"))

function checkworkshopdir(name)
    wspath = joinpath(WORKSHOP_DIR, name)
    isdir(wspath) || mkpath(wspath)
    return nothing
end

function getworkshop(name)
    ws = WORKSHOPS[name]
    checkworkshopdir(ws.projectname)
    repodir = joinpath(WORKSHOP_DIR, ws.projectname)
    git() do git
        run(`$git clone $(ws.repo) $repodir`)
    end
end

function updateworkshop(name; force = false)
    currdir = pwd()
    ws = WORKSHOPS[name]
    repodir = joinpath(WORKSHOP_DIR, ws.projectname)
    isdir(repodir) || error("""Workshop: $name is not cloned! Run getworkshop("$name") first""")
    cd(repodir)
    git() do git
        if force
            run(`$git stash -qu`)
        end
        run(`$git pull -q`)
    end
    cd(currdir)
    return nothing
end

function initworkshop(name)
    ws = WORKSHOPS[name]
    repodir = joinpath(WORKSHOP_DIR, ws.projectname)
    isdir(repodir) || error("""Workshop: $name is not cloned! Run getworkshop("$name") first""")
    notebook(detached=true, dir=repodir)
    return nothing
end


end
