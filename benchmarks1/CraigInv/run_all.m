
function result = run_all()

    % cd into the current directory
    current_file_fullpath = mfilename('fullpath');
    [current_folder, ~, ~] = fileparts(current_file_fullpath);
    added_paths = genpath(current_folder);
    addpath(added_paths);
    %% 
    cd(current_folder);
    fprintf(current_folder);
    % Cluster benchmark
    benchmarks = ["sgd","sgd_001","unicycle","transcend","motivate","lyapunov","logistic","discrete","deter","contrived","circuit","cav13_1","cav13_2","car","bound","bound2","basin"];
    for i = 1:length(benchmarks)
        tic
        disp(strcat("========",benchmarks(i),"========"))
        algorithm1(benchmarks(i))
        toc
    end
    rmpath(added_paths);
end
