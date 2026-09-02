function CraigPrajna(benchmark)

yalmip('clear');

run(strcat(benchmark,'.m'))

tic; 
max_iter = 20;
% Initialize Constraints
sdp_cons = sdp_cons_init();
sdp_cons{1} = xvars;
sdp_cons{2} = [a];

if ~isempty(inv_poly)
    disp("inv_poly content:");
    % sdisplay(inv_poly); 
else
    disp("Polynomial function did not generate inv_poly!");
end

% -------------------------------------------------------
% ITERATION 0 (Initialization)
% -------------------------------------------------------

% Pre cond
for i = 1:length(prelist)
    sdp_cons = SOSnew([prelist{i}, x_bound], inv_poly, sdp_cons, 0, wi_deg);
end

% Post with -loopcond
for i = 1:length(negpostlist)
   sdp_cons = SOSnew([negpostlist{i}, -loop_cond_ineq, x_bound], -inv_poly, sdp_cons, epsilon, wi_deg);
end

sdp_var = sdp_cons{2};
constraints = sdp_cons{3};

fprintf("Begin Solving Initial Step...\n");

options = sdpsettings('solver','mosek','verbose', 0, 'sos.newton',1,'sos.congruence',1);
diagnostics = solvesdp(constraints, 0, options, sdp_var);


if diagnostics.problem == 0
    fprintf('A feasible initial solution is found.\n')
    sol = 1;
    p_val = double(a);
    for i = 1:length(p_val)
        if abs(p_val(i)) <= 10^(-6)
            p_val(i) = 0.0;
        end
    end
    h_0=replace(h_x,a,p_val);
    hx_str = sdisplay(h_0);
    fileID = fopen(strcat('results/', benchmark,'.txt'), 'w');
    elapsedTime=toc;
    fprintf(fileID, 'elapsedtime\n%.2f\n', elapsedTime);
    output_str=strcat("hx=",hx_str);
    fprintf(fileID, '%s\n', output_str);
    sdisplay(h_0);

else
    fprintf('No initial solution is found:\n'); 
end


p_val=double(a);



% -------------------------------------------------------
% MAIN LOOP
% -------------------------------------------------------

for times = 1:max_iter
    fprintf("----------------------------------------------\n");
    fprintf("iteration %d\n", times);
    
    % --- SUB-ITERATION 1: Find witness wht_xy ---
    
    sdp_cons = sdp_cons_init();
    sdp_cons{1} = xvars;
    sdp_cons{2} = [a];
    
    % Re-assert Pre/Post conditions
    for i=1:length(prelist)
         sdp_cons = SOSnew([prelist{i},x_bound],h_x,sdp_cons,0,wi_deg);
    end
    for i=1:length(negpostlist)
        sdp_cons = SOSnew([negpostlist{i},-loop_cond_ineq,x_bound], -h_x, sdp_cons, epsilon,wi_deg);
    end
    
    % Prepare for Loop condition synthesis
    sdp_cons{1} = vars;
    
    % Generate ht_y, ht_x based on previous p_val
    ht_y = replace(h_x, a, p_val);
    ht_y = replace(ht_y, xvars, y_vars);
    ht_x = replace(h_x, a, p_val);
    
    % Solve constraint to find Witness
    sdp_cons = Loop(ht_y, p_x, [ht_x, loop_cond_ineq], 0, 0, sdp_cons, y_vars, wi_deg, wp_deg);
    sdp_var = sdp_cons{2};
    constraints = sdp_cons{3};
    
    diagnostics = solvesos(constraints, 0, options, sdp_var);
    
    if diagnostics.problem ~= 0
        fprintf('Mosek warning (Step 1): %s\n', diagnostics.info);
    end

    wh_xy_coef = double(sdp_cons{7});
    wht_xy = generate_h(wh_xy_coef, vars, wi_deg);

    % --- SUB-ITERATION 2: Update inv_polyariant h(x) ---

    sdp_cons = sdp_cons_init();
    sdp_cons{1} = xvars;
    sdp_cons{2} = [a];
    
    % Pre cond
    for i = 1:length(prelist)
         sdp_cons = SOSnew([prelist{i}, x_bound], h_x, sdp_cons, 0, wi_deg);
    end
    
    % Post with -loopcond
    for i = 1:length(negpostlist)
        sdp_cons = SOSnew([negpostlist{i}, -loop_cond_ineq, x_bound], -h_x, sdp_cons, epsilon, wi_deg);
    end
    
    % Loop condition
    sdp_cons{1} = vars;
    sdp_cons = Loop(-h_x * wht_xy + h_y, p_x, [loop_cond_ineq, x_bound], 0, 0, sdp_cons, y_vars, wi_deg, wp_deg);
    
    % Solve
    sdp_var = sdp_cons{2};
    constraints = sdp_cons{3};
    constraints = [constraints; a_bound];
    
    diagnostics = solvesos(constraints, 0, options, sdp_var);
    
    % Update p_val
    p_val = double(a);
    
    % Display result
    p_val=double(a);
    TOLERANCE = -1e-9;
    sdisplay(replace(h_x, a, p_val));
  
    max_abs_p = max(abs(p_val(:)));
    lam=double(lambda);
    if lam < TOLERANCE && max_abs_p>1
        elapsedTime=toc;
        fprintf(fileID, 'success\n');
        fprintf(fileID, 'lambda\n%.8f\n', lam);
        fprintf(fileID, 'times\n%d\n', times);
        fprintf(fileID, 'elapsedtime\n%.2f\n', elapsedTime);
        hx_str = sdisplay(replace(h_x, a, p_val));
        output_str=strcat("hx=",hx_str);
        if iscell(output_str)
            for i = 1:length(output_str)
                fprintf(fileID, '%s\n', output_str{i});
            end
        else
            fprintf(fileID, '%s\n', output_str);
        end
        fclose(fileID);
        break;
    end
end


end

% -----------------------------------------------------------
% HELPER FUNCTIONS
% -----------------------------------------------------------

function sdp_cons = SOSnew(pre_list, inv_poly, sdp_cons, epsilon, deltadegree)
    vars = sdp_cons{1};
    sdp_var = sdp_cons{2};
    constraints = sdp_cons{3};
    delta_cell  = sdp_cons{4}; 
    delta_coef_cell = sdp_cons{5};
    tail = sdp_cons{6};
    sum_poly = 0; 
    
    for i = 1:length(pre_list)
        [delta_cell{tail}, delta_coef_cell{tail}] = polynomial(vars, deltadegree);    
        sum_poly = sum_poly + delta_cell{tail} * pre_list(i);
        constraints = [constraints, sos(delta_cell{tail})];
        sdp_var = [sdp_var; delta_coef_cell{tail}];
        tail = tail + 1;
    end
    
    constraints = [constraints, sos(inv_poly - sum_poly - epsilon)];
    sdp_cons = {vars, sdp_var, constraints, delta_cell, delta_coef_cell, tail};
end

function h_t = generate_h(p, vars, h_degree)
    monolist_h = monolist(vars, h_degree);
    h_t = dot(p, monolist_h);
end

function sdp_cons = Loop(ht_y, p_x, square_list, t_xy, lambda, sdp_cons, y_vars, wi_deg, wi_xy_degree)
    vars = sdp_cons{1};
    sdp_var = sdp_cons{2};
    constraints = sdp_cons{3};
    delta_cell  = sdp_cons{4}; 
    delta_coef_cell = sdp_cons{5};
    tail = sdp_cons{6};
    sum_poly = 0;
    
    wh_xy_coef = []; 

    for i = 1:length(square_list)
        [delta_cell{tail}, delta_coef_cell{tail}] = polynomial(vars, wi_deg);    
        sum_poly = sum_poly + delta_cell{tail} * square_list(i);
        constraints = [constraints, sos(delta_cell{tail})];
        sdp_var = [sdp_var; delta_coef_cell{tail}];
        
        % Capture Witness Coefs (assumed first element)
        if i == 1
            wh_xy_coef = delta_coef_cell{tail};
        end
        tail = tail + 1;
    end
    
    y_len = length(y_vars);
    for i = 1:y_len
        [delta_cell{tail}, delta_coef_cell{tail}] = polynomial(vars, wi_xy_degree);    
        sum_poly = sum_poly + delta_cell{tail} * (y_vars(i) - p_x(i));
        sdp_var = [sdp_var; delta_coef_cell{tail}];
        tail = tail + 1;
    end
    
    constraints = [constraints, sos(ht_y - sum_poly + lambda*t_xy)];
    constraints = [constraints, lambda >= -1];
    
    sdp_cons = {vars, sdp_var, constraints, delta_cell, delta_coef_cell, tail, wh_xy_coef};
end

function sdp_con = sdp_cons_init()
    sdp_var = [];
    constraints = [];
    delta_cell = {};
    delta_coef_cell = {};
    tail = 1;
    vars = [];
    sdp_con = {vars, sdp_var, constraints, delta_cell, delta_coef_cell, tail};
end
