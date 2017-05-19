module TestOIFITS

using OIFITS
using Base.Test
using Compat

dir = dirname(@__FILE__)

files = ("contest-2004-obj1.oifits" ,"contest-2004-obj2.oifits",
         "contest-2008-binary.oifits", "contest-2008-obj1-H.oifits",
         "contest-2008-obj1-J.oifits", "contest-2008-obj1-K.oifits",
         "contest-2008-obj2-H.oifits", "contest-2008-obj2-J.oifits",
         "contest-2008-obj2-K.oifits", "contest-2008-obj1-J.oifits")

counter = 0

quiet = true

function tryload(dir, file)
    global counter
    try
        db = OIFITS.load(joinpath(dir, file))
        counter += 1
        quiet || info("file \"", file, "\" successfully loaded")
        return true
    catch
        warn("failed to load \"", file, "\"")
        return false
    end
end

# Macro `@testset` may not exists, so we provide a poor replacement.
if ! isdefined(Symbol("@testset"))
    macro testset(args...)
        prefix = (length(args) ≥ 2 ? args[1]*": " : "")
        tests = args[end]
        quote
            $tests
            println($prefix, "all ", counter, " tests were successful")
        end
    end
end

@testset "OIFITS.load" begin
    for file in files
        @test tryload(dir, file) == true
    end
end

end

nothing
