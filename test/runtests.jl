using Atom, Test, JSON, Logging, CSTParser


joinpath′(files...) = Atom.fullpath(joinpath(files...))

atomjldir = joinpath′(@__DIR__, "..")
atomsrcdir = joinpath′(atomjldir, "src")
atomjlfile = joinpath′(atomsrcdir, "Atom.jl")
webiofile = joinpath′(atomsrcdir, "display", "webio.jl")

# files in `Atom` module (except files in its submodules)
atommodfiles = let
    files = []
    debuggerdir = joinpath′(atomsrcdir, "debugger")
    profilerdir = joinpath′(atomsrcdir, "profiler")

    for (d, ds, fs) in walkdir(atomsrcdir)
        # NOTE: update directories below when you create an new submodule
        # the 2 files below are in Atom module
        if d == debuggerdir
            push!(files, joinpath′(d, "debugger.jl"))
            continue
        end
        if d == profilerdir
            push!(files, joinpath′(d, "profiler.jl"))
            push!(files, joinpath′(d, "traceur.jl"))
            continue
        end

        for f in fs
            # NOTE: currently both Revise-like and CSTPraser-based approach fails
            # to detect display/webio.jl as a file in Atom module
            f == "webio.jl" && continue

            # .jl check is needed for travis, who creates hoge.cov files
            endswith(f, ".jl") && push!(files, joinpath′(d, f))
        end
    end

    files
end

# mock modules
fixturedir = joinpath′(@__DIR__, "fixtures")
junkpath = joinpath′(fixturedir, "Junk.jl")
subjunkspath = joinpath′(fixturedir, "SubJunks.jl")
include(junkpath)

# basics
include("utils.jl")
include("misc.jl")
include("display.jl")
include("static/static.jl")
include("modules.jl")

include("eval.jl")
include("outline.jl")
include("completions/completions.jl")
include("goto.jl")
include("datatip.jl")
include("workspace.jl")
include("docs.jl")
