function result = run_all()

    % modify it to your benchmarks directory
    path = "CraigInv\benchmarks2\CraigInv\benchmarks";
    cd(path);

    % Cluster benchmark
    % benchmarks = ["fermat2","firefly","illinois","lcm","mannadiv","mesi","moesi","petter","readerwriter","wensely","z3sqrt","ex_sqrt","freire1","freire2","berkeley","cohencu","cohendiv","euclidex2"];
    benchmarks = ["ex_sqrt"];
    for i = 1:length(benchmarks)
        disp(strcat("========",benchmarks(i),"========"))
        fprintf('benchmark is %s\n', benchmarks(i));
        algorithm(benchmarks(i))
        fprintf('------------------\n');
    end
end