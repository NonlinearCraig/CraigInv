function result = run_all()

    % cd into the current directory
    full_path = "C:\Users\zhaoy\Desktop\template1";
    [path, name, ext] = fileparts(full_path);
    cd(path);

    % Cluster benchmark
    benchmarks = ["basin","bound","bound2","car","cav13_1","cav13_2","circuit","contrived","deter","discrete","logistic","lyapunov","motivate","sgd","sgd_001","transcend","unicycle"];
    D = [2,2,2,2,2,2,2,2,2,2];
    for i = 1:length(benchmarks)
        tic
        disp(strcat("========",benchmarks(i),"========"))
        for d = 1:D(i)
            fprintf("d = %d", d);
            algorithm1(benchmarks(i), d);
        end
        toc
    end
    

end