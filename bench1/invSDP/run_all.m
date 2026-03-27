function result = run_all()

    % modify it to your benchmarks directory

    full_path = which('run_all.m');
    [path, name, ext] = fileparts(full_path);
    cd(path);
    addpath(genpath(path));

    % Cluster benchmark
    % benchmarks = ["motivate","transcend","sgd","sgd_001","cav13_1","car","bound","bound2","contrived","logistic","cav13_2","unicycle","circuit","discrete","deter","basin","lyapunov"];
    benchmarks = ["cav13_1"];
    D = [6];
    for i = 1:length(benchmarks)
        tic
        disp(strcat("========",benchmarks(i),"========"))
        
        for d=1:D(i)
            fprintf("d = %d", d);
            % fprintf(fileID, 'benchmark is %s\n', benchmarks(i));
            % fprintf(fileID, 'd is %d\n', d);
            algo_under1(benchmarks(i), d)
            % t=toc;
            % fprintf(fileID, 'Elapsed time: %.6f seconds\n', t);
            % fprintf(fileID, '------------------\n');
            % fclose(fileID);
        end
        toc
    end
    rmpath(genpath(path));
end