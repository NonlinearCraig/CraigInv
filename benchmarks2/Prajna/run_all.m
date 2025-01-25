function result = run_all()

    % modify it to your benchmarks directory
    path = "C:\Users\zhaoy\Desktop\CraigInv\benchmarks2\Prajna\benchmarks";
    cd(path);

    % Cluster benchmark
    benchmarks = ["petter","readerwriter","wensely","z3sqrt","ex_sqrt","freire1","freire2","berkeley","cohencu","cohendiv","euclidex2","fermat2","firefly","illinois","lcm","mannadiv","mesi","moesi"];
    for i = 1:length(benchmarks)
        tic
        disp(strcat("========",benchmarks(i),"========"))
        fprintf('benchmark is %s\n', benchmarks(i));
        Prajna(benchmarks(i))
        fprintf('------------------\n');
        toc
    end
end