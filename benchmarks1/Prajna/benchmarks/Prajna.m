function Prajna(benchmark)
yalmip('clear')
run(strcat(benchmark,'.m'))
diary on;
diary(strcat(strcat(benchmark,'.txt')));
tic;
% Read benchmark
% car;
% discrete;
% logistic;
% sgd;
% sgd_001;
% cav13_1;
% cav13_2;
% unicycle;
% circuit;
% deter;
% bound;
% bound2;
% contrived;
% transcend;  
% motivate;
% lyapunov;
% basin;





% epsilon = 0;
max_iter=20;
% initial h0 to get p_val(initial coef of h)
% a denotes coefficient of inv.
%sdp_var use coefficient as vars

%
a_len=length(a);
p_val=zeros(a_len,1);


for times=1:max_iter

    %iteration 1;

    sdp_cons=sdp_cons_init();
    sdp_cons{1}=xvars;
    sdp_cons{2}=[a];
    % pre cond
    for i=1:length(prelist)
         sdp_cons = SOSnew([prelist{i},x_bound],h_x,sdp_cons,0,wi_deg);
    end
    %post with -loopcond
    for i=1:length(negpostlist)
        sdp_cons = SOSnew([negpostlist{i},-loop_cond_ineq,x_bound], -h_x, sdp_cons, epsilon,wi_deg);
    end
    
    %initial sdp_cons;
    
    
    sdp_cons=sdp_cons_init();
    sdp_cons{1}=vars;
    
    %generate ht_y,ht_x
    ht_y=replace(h_x,a,p_val);
    ht_y=replace(ht_y,xvars,y_vars);
    ht_x=replace(h_x,a,p_val);
    
    
    %solve constrain
    sdp_cons=Loop(ht_y,p_x,[ht_x,loop_cond_ineq],0,0,sdp_cons,y_vars,wi_deg,wp_deg);
    sdp_var = sdp_cons{2};
    constraints = sdp_cons{3};
    options = sdpsettings('solver','mosek','verbose', 0, 'sos.newton',1,'sos.congruence',1);
    diagnostics=  solvesos(constraints, 0, options, sdp_var);
    
    %print info.lambda
    wh_xy_coef=double(sdp_cons{7});
    % wh_degree=deltadegree;
    wht_xy=generate_h(wh_xy_coef,vars,wi_deg);
    % myprint(diagnostics,times,lambda);
    sdisplay(wht_xy);
    
    
    
    %iteration 2
    sdp_cons=sdp_cons_init();
    sdp_cons{1}=xvars;
    sdp_cons{2}=[a];
    % pre cond
    for i=1:length(prelist)
         sdp_cons = SOSnew([prelist{i},x_bound],h_x,sdp_cons,0,wi_deg);
    end
    %post with -loopcond
    for i=1:length(negpostlist)
        sdp_cons = SOSnew([negpostlist{i},-loop_cond_ineq,x_bound], -h_x, sdp_cons, epsilon,wi_deg);
    end
    %loop condition
    
    sdp_cons{1}=vars;
    sdp_cons=Loop(-h_x*wht_xy+h_y,p_x,[loop_cond_ineq,x_bound],0,0,sdp_cons,y_vars,wi_deg,wp_deg);
    %solve constrainte
    sdp_var = sdp_cons{2};
    constraints = sdp_cons{3};
    constraints=[constraints;a_bound];
    diagnostics=  solvesos(constraints, 0, options, sdp_var);
    
    toc;
    

    fprintf("iteration %d\n",times);
    p_val = double(a);
    for i = 1:length(p_val)
        if abs(p_val(i)) <= 10^(-5)
            p_val(i) = 0.0;
        end
    end
    h_0=replace(h_x,a,p_val);
    s=string(sdisplay(h_0));
    s = strrep(s, 'vars(1)', 'x1');
    s = strrep(s, 'vars(2)', 'x2');
    s = strrep(s, 'vars(3)', 'x3');
    sdisplay(s);
 
    
end


diary off;
end



%the universal function
%convert degree to even
function even_d=even_degree(degree)
    if even(degree)==1
        even_d=degree;
    else
        even_d=degree+1;
    end
end

%encode precondition and post condition
function sdp_cons = SOSnew(pre_list,inv,sdp_cons, epsilon, deltadegree)
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
        [delta_cell{tail}, delta_coef_cell{tail}] = polynomial(vars, deltadegree);    
        sum = sum + delta_cell{tail} * pre_list(i);
        constraints = [constraints, sos(delta_cell{tail})];
        sdp_var = [sdp_var; delta_coef_cell{tail}];
        tail = tail + 1;
    end
    % generate h-epsilon-sigma(delat(x)f(x))
    constraints = [constraints, sos( inv - sum -epsilon)];
    sdp_cons = {vars, sdp_var, constraints, delta_cell, delta_coef_cell, tail};
end


%the function used for iteration

%generate p_val(real_value)* monolist
function h_t=generate_h(p,vars,h_degree)
    monolist_h=monolist(vars,h_degree);
    h_t=dot(p,monolist_h);
end


%translate loop condition in iteration 1;
%the first parameter of square_list must be ht_x)
function sdp_cons = Loop(ht_y,p_x,square_list,t_xy,lambda,sdp_cons,y_vars,wi_deg,wi_xy_degree)
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
    %compute sigma(w_i(x,y)(y_i-p_i(x))
    p_len=length(p_x);
    y_len=length(y_vars);
    
    for i = 1:y_len
        %delta_cell{tail} : a set of polynomials.
        %delta_coef_cell{tail} coefficient assembled together.  
        [delta_cell{tail}, delta_coef_cell{tail}] = polynomial(vars,wi_xy_degree);    
        sum = sum + delta_cell{tail} * (y_vars(i)-p_x(i));
        sdp_var = [sdp_var; delta_coef_cell{tail}];
        tail = tail + 1;
    end
    % constraints = [constraints, sos( h_y - sum +lambda*t_xy-wht_xy*h_x)];
    constraints = [constraints, sos( ht_y - sum +lambda*t_xy)];
    constraints=[constraints,lambda>=-1];
    sdp_cons = {vars, sdp_var, constraints, delta_cell, delta_coef_cell, tail,wh_xy_coef};
end



function sdp_con=sdp_cons_init()
    sdp_var = [];
    constraints = [];
    delta_cell = {};
    delta_coef_cell = {};
    tail = 1;
    vars=[];
    sdp_con= {vars, sdp_var, constraints, delta_cell, delta_coef_cell, tail};
end
 