using Gurobi, AnyMOD

# choose scenario here ("expansion", "fixed", "decentral")
scenario = "expansion"

model_NA = anyModel(["baseInput","scenarioInput/" * scenario], "results/" * scenario, reportLvl = 3)

#plotEnergyFlow(:graph,model_NA)
createOptModel!(model_NA)
setObjective!(:costs,model_NA)

set_optimizer(model_NA.optModel, Gurobi.Optimizer)
set_optimizer_attribute(model_NA.optModel, "Method", 2)
set_optimizer_attribute(model_NA.optModel, "Crossover", 0)
optimize!(model_NA.optModel)

plotEnergyFlow(:sankey,model_NA, dropDown = (:timestep,))

reportResults(:summary, model_NA)
reportResults(:costs, model_NA)
reportTimeSeries(:electricity,model_NA)