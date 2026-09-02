function Prajna(benchmark)
yalmip('clear')
run(strcat(benchmark,'.m'))
diary on;
diary(strcat(strcat(benchmark,'.txt')));
tic;




% read benchmarks;
% z3sqrt;
% cohendiv;
% berkeley;
% cohencu;
% firefly;
% freire1;
% freire2;
% mannadiv;
% illinois;
% lcm;
% mesi; 
% moesi;
% petter;
% readerwriter;
% ex_sqrt;
% fermat2;

% euclidex2;
% wensely;

% epsilon = 0;
max_iter=20;

% set optimization problem
vars = xvars;

% options = sdpsettings('solver','sdpa','verbose', 0);
options = sdpsettings('solver','mosek','verbose', 0, 'sos.newton',1,'sos.congruence',1);

%generate p_val
p_val=0;



% wh_coef: the sos polynomial accompany with h_i(x)
% wh_xy: the coef of h_x 
wh_coef=cell(1,r_num);
for i=1:r_num
    wh_coef{i}=[];
end

% generate monolist
wht_xy_m=monolist(xvars,wi_deg);

for times=1:max_iter

    %iteration 1;

    %sdp init
    sdp_cons=sdp_cons_init();
    sdp_cons{1}=vars;

    %generate ht_y,ht_x
    ht_y=replace(inv_ineq,zvars,inv_eq);
    ht_y=replace(ht_y,coef,p_val);

    ht_x=replace(inv_ineq,coef,p_val);



    for i=1:length(prelist)
        sdp_cons = SOSnew([prelist{i},x_bound],ht_y, sdp_cons,0,wi_deg);
    end


    % % post cond

    for i=1:length(negpostlist)
        sdp_cons = SOSnew([negpostlist{i},-guard,x_bound],replace(-ht_y,zvars,inv_eq), sdp_cons,0,wi_deg);
    end

    %solve constraint
    for i =1:r_num
        sdp_cons=Loop(replace(ht_y,xvars,f(i,:)),[ht_x,guard,loop_cond(i)],0,0,sdp_cons,wi_deg);
        wh_coef{i}=sdp_cons{7};
    end
    sdp_var = sdp_cons{2};
    constraints = sdp_cons{3};
    diagnostics=  solvesos(constraints, 0, options, sdp_var);
    
    %print info.
    for i=1:r_num
        wh_coef{i}=double(wh_coef{i});
    end
    % myprint(diagnostics,times,lambda);
    % sdisplay(wht_xy);



    %iteration 2
    sdp_cons=sdp_cons_init();
    sdp_cons{1}=xvars;
    sdp_cons{2}=[coef];
    % pre cond
    for i=1:length(prelist)
         sdp_cons = SOSnew([prelist{i},x_bound],inv_ineq,sdp_cons,0,wi_deg);
    end
    %post with negguard
    for i=1:length(negpostlist)
        sdp_cons = SOSnew([negpostlist{i},-guard,x_bound], -inv_ineq, sdp_cons, epsilon,wi_deg);
    end
    %loop condition




    for i =1:r_num
        wht_xy=dot(wht_xy_m,wh_coef{i});
        inv_ineq_y=replace(inv_ineq,xvars,f(i,:));
        sdp_cons=Loop(-inv_ineq*wht_xy+inv_ineq_y,[guard,x_bound,loop_cond(i)],0,0,sdp_cons,wi_deg);
    end


    %solve constrainte
    sdp_var = sdp_cons{2};
    constraints = sdp_cons{3};
    constraints=[constraints;coef_bound];
    diagnostics=  solvesos(constraints, 0, options, sdp_var);

    toc;

    p_val=double(coef);
    fprintf("iter:%d\n",times);
    fprintf("inv is:\n");
    sdisplay(replace(inv_ineq,coef,p_val));


end
diary off;
end


%the function used for iteration

%generate p_val(real_value)* monolist
function h_t=generate_h(p_val,vars,h_degree)
    monolist_h=monolist(vars,h_degree);
    h_t=dot(p_val,monolist_h);
end


%translate loop condition in iteration 1;
%the first parameter of square_list must be ht_x
function sdp_cons = Loop(ht_y,square_list,t_xy,lambda,sdp_cons,wi_deg)
    vars = sdp_cons{1};
    sdp_var = sdp_cons{2};
    constraints = sdp_cons{3};
    delta_cell  = sdp_cons{4}; 
    delta_coef_cell = sdp_cons{5};
    tail = sdp_cons{6};
    sum = 0;
    %compute w_h(x,y)h_t(x)+w_c(x,y)c(x)
    for i = 1:length(square_list)
        %delta_cell{tail} : a set of polynomials.
        %delta_coef_cell{tail} coefficient assembled together.  
        [delta_cell{tail}, delta_coef_cell{tail}] = polynomial(vars,wi_deg);    
        sum = sum + delta_cell{tail} * square_list(i);
        constraints = [constraints, sos(delta_cell{tail})];
        sdp_var = [sdp_var; delta_coef_cell{tail}];
        if i==1
            wh_xy_coef=delta_coef_cell{tail};
        end
        tail = tail + 1;
    end
 
    % constraints = [constraints, sos( h_y - sum +lambda*t_xy-wht_xy*h_x)];
    constraints = [constraints, sos( ht_y - sum +lambda*t_xy)];
    constraints=[constraints,lambda>=-1];
    sdp_cons = {vars, sdp_var, constraints, delta_cell, delta_coef_cell, tail,wh_xy_coef};
end






%the universal function
%convert degree to even
function even_d=even_degree(degree)
    if logical(even(degree))
        even_d=degree;
    else
        even_d=degree+1;
    end
end

%encode precondition and post condition
function sdp_cons = SOSnew(pre_list,inv,sdp_cons, epsilon, wi_deg)
    vars = sdp_cons{1};
    sdp_var = sdp_cons{2};
    constraints = sdp_cons{3};
    delta_cell  = sdp_cons{4}; 
    delta_coef_cell = sdp_cons{5};
    tail = sdp_cons{6};
    sum = 0;
    for i = 1:length(pre_list)
        %delta_cell{tail} : a set of polynomials.
        %delta_coef_cell{tail} coefficient assembled together.  
        [delta_cell{tail}, delta_coef_cell{tail}] = polynomial(vars, wi_deg);    
        sum = sum + delta_cell{tail} * pre_list(i);
        constraints = [constraints, sos(delta_cell{tail})];
        sdp_var = [sdp_var; delta_coef_cell{tail}];
        tail = tail + 1;
    end
    % generate h-epsilon-sigma(delat(x)f(x))
    constraints = [constraints, sos( inv - sum -epsilon)];
    sdp_cons = {vars, sdp_var, constraints, delta_cell, delta_coef_cell, tail};
end




function sdp_cons=sdp_cons_init()
    sdp_var = [];
    constraints = [];
    delta_cell = {};
    delta_coef_cell = {};
    tail = 1;
    vars=[];
    sdp_cons= {vars, sdp_var, constraints, delta_cell, delta_coef_cell, tail};
end


