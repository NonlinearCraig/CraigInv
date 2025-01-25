function result = run_all()

    % modify it to your benchmarks directory
    path = "CraigInv\benchmarks1\invSDP\template1";
    cd(path);

    % Cluster benchmark
    benchmarks = ["motivate","transcend","sgd","sgd_001","cav13_1","car","bound","bound2","contrived","logistic","cav13_2","unicycle","circuit","discrete","deter","basin","lyapunov"];
    D = [4*ones(length(benchmarks),1)];
    for i = 1:length(benchmarks)
        tic
        disp(strcat("========",benchmarks(i),"========"))
        for d=1:D(i)
            fprintf("d = %d", d);
            fileID = fopen('output.txt', 'a');
            fprintf(fileID, 'benchmark is %s\n', benchmarks(i));
            fprintf(fileID, 'd is %d\n', d);
            algo_under1(benchmarks(i), d)
            t=toc;
            fprintf(fileID, 'Elapsed time: %.6f seconds\n', t);
            fprintf(fileID, '------------------\n');
            fclose(fileID);
        end
        toc
    end
end