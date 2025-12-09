


function result = run_all()

    % cd into the current directory
    full_path = which('run_all.m');
    [path, name, ext] = fileparts(full_path);
    cd(path);
    addpath(genpath(path));
    % Cluster benchmark
    benchmarks = ["readerwriter","wensely","z3sqrt","ex_sqrt","freire1","freire2","berkeley","cohencu","cohendiv","euclidex2","fermat2","firefly","illinois","lcm","mannadiv","mesi","moesi","petter"];
    for i = 1:length(benchmarks)
        tic
        disp(strcat("========",benchmarks(i),"========"))
        CraigPrajna1(benchmarks(i))
        toc
    end
    rmpath(genpath(path));
end
