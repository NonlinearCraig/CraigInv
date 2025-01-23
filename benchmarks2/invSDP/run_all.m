function result = run_all()

    % modify it to your benchmarks directory
    path = "";
    cd(path);

    % Cluster benchmark
    benchmarks = ["berkeley","cohencu","cohendiv","euclidex2","fermat2","firefly","illinois","lcm","mannadiv","mesi","moesi","petter","readerwriter","wensely","z3sqrt","ex_sqrt","freire1","freire2"];
    D = [4*ones(length(benchmarks),1)];
    for i = 1:length(benchmarks)
        tic
        disp(strcat("========",benchmarks(i),"========"))
        for d=1:D(i)
            fprintf("d = %d", d);
            algorithm(benchmarks(i), d)
            fileID = fopen('result.txt', 'w');
            
        end
        toc
    end
end