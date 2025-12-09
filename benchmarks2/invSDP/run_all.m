    function result = run_all()
    
        % modify it to your benchmarks directory
        current_file_fullpath = mfilename('fullpath');
        [current_folder, ~, ~] = fileparts(current_file_fullpath);
        added_paths = genpath(current_folder);
        addpath(added_paths);
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
        rmpath(added_paths);
    end