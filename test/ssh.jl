module test_ssh

using Test
using Distributed

const test_exeflags = Base.julia_cmd()
const test_exename = popfirst!(test_exeflags.exec)

addprocs_with_testenv(machines; kwargs...) = addprocs(machines; exename=test_exename, exeflags=test_exeflags, kwargs...)

ws = workers()

machines = [("localhost", 1)]
addprocs_with_testenv(machines)

wid = first(setdiff(workers(), ws))

@test Distributed.PGRP.workers[1] isa Distributed.LocalProcess
@test Distributed.PGRP.workers[wid] isa Distributed.Worker

end # module test_ssh
