function result = run_all()

    % modify it to your benchmarks directory
    path = "C:\Users\zhaoy\Desktop\CraigInv\appendix\NoCraig\templates1";
    cd(path);

    % Cluster benchmark
    % benchmarks = ["discrete_2","deter_2","basin_2","lyapunov_2","car_2","motivate_2","transcend_2","sgd_2","sgd_001_2","cav13_1_2","bound_2","bound2_2","contrived_2","logistic_2","cav13_2_2","unicycle_2","circuit2"];
    benchmarks=["motivate_2"]
    for i = 1:length(benchmarks)
        tic
        disp(strcat("========",benchmarks(i),"========"));       
        fprintf('benchmark is %s\n', benchmarks(i));
        noCraig(benchmarks(i))
        t=toc;
        fprintf('Elapsed time: %.6f seconds\n', t);
        fprintf('------------------\n');
        toc
    end
end