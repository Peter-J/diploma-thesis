%function f = MichaelisMenten(k,doplot)
k = 10; doplot = 0;
tic;
for n = 1:k
    N = n * 100
    model = sbiomodel('Michaelis-Menten');
    r1 = addreaction(model, 'E + R -> H');
    r2 = addreaction(model, 'H -> E + R');
    r3 = addreaction(model, 'H -> E + P');
    k1 = addkineticlaw(r1, 'MassAction');
    k2 = addkineticlaw(r2, 'MassAction');
    k3 = addkineticlaw(r3, 'MassAction');
    p1 = addparameter(k1,'01','Value', N/200);
    p2 = addparameter(k2,'10','Value', N^3/200);
    p3 = addparameter(k3,'12','Value', N^2/200);
		k1.ParameterVariableNames = {'01'};
    k2.ParameterVariableNames = {'10'};
    k3.ParameterVariableNames = {'12'};
    model.species(1).InitialAmount = 100;
    model.species(2).InitialAmount = N;
    model.species(3).InitialAmount = 0;
    model.species(4).InitialAmount = 0;
    cs = getconfigset(model,'active');
    cs.SolverType = 'ssa' ;
    cs.StopTime = 3.01;
    cs.CompileOptions.DimensionalAnalysis = false;
    model.Species
    [t_ssa, x_ssa] = sbiosimulate(model);
    toc
    if doplot
        plot(t_ssa, x_ssa)
    end
end
