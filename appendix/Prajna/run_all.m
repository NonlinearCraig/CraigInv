function result = run_all()

    % modify it to your benchmarks directory
    path = "CraigInv\appendix\Prajna\template2";
    cd(path);

    % Cluster benchmark
    benchmarks = ["bound_2","bound2_2","contrived_2","logistic_2","cav13_2_2","unicycle_2","circuit2","discrete_2","deter_2","basin_2","lyapunov_2","motivate_2","transcend_2","sgd_2","sgd_001_2","cav13_1_2","car_2"];
    
    for i = 1:length(benchmarks)
        tic
        disp(strcat("========",benchmarks(i),"========"))
        fprintf('benchmark is %s\n', benchmarks(i));
        Prajna(benchmarks(i))
        fprintf('------------------\n');
        toc
    end
end