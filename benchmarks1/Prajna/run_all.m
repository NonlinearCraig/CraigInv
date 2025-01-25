function result = run_all()

    % modify it to your benchmarks directory
    path = "C:\Users\zhaoy\Desktop\CraigInv\benchmarks1\Prajna\benchmarks";
    cd(path);

    % Cluster benchmark
    benchmarks = ["motivate","transcend","sgd","sgd_001","cav13_1","car","bound","bound2","contrived","logistic","cav13_2","unicycle","circuit","discrete","deter","basin","lyapunov"];
    for i = 1:length(benchmarks)
        tic
        disp(strcat("========",benchmarks(i),"========"))
        fprintf('benchmark is %s\n', benchmarks(i));
        Prajna(benchmarks(i))
        fprintf('------------------\n');
        toc
    end
end