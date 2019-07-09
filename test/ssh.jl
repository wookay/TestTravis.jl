module test_ssh

using Test
using Distributed

const test_exeflags = Base.julia_cmd()
const test_exename = popfirst!(test_exeflags.exec)

addprocs_with_testenv(machines; kwargs...) = addprocs(machines; exename=test_exename, exeflags=test_exeflags, kwargs...)

ws = workers()

machines = [("localhost", 1)]
try
    addprocs_with_testenv(machines)
catch err
    @test err isa CompositeException
end

@test Distributed.PGRP.workers[1] isa Distributed.LocalProcess
wsdiff = setdiff(workers(), ws)
if !isempty(wsdiff)
    @test Distributed.PGRP.workers[wsdiff[1]] isa Distributed.Worker
end

end # module test_ssh
