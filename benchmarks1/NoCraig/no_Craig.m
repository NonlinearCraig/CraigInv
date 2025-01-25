yalmip('clear');
clear;
tic;
% Read benchmark
% ex1;
% ex2;
% ex3;
% ex4;
% ex4_001;
% cav13_1;
% cav13_2;
% cohencu; 
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

% ex1_2;
% ex2_2;
% ex3_2;
% ex4_2;
% ex4_001_2;
% cav13_1_2;
% cav13_2_2;
% cohencu_2; 
% unicycle_2;
% circuit_2;
% deter_2;
% bound_2;
% bound2_2;
% contrived_2;
% transcend_2;  
% motivate_2;
% lyapunov_2;
% basin_2;




% epsilon = 0;
max_iter=20;
% initial h0 to get p_val(initial coef of h)
% a denotes coefficient of inv.
%sdp_var use coefficient as vars


fprintf("Begin Solving...\n");
% 


options = sdpsettings('solver','mosek','verbose', 0, 'sos.newton',1,'sos.congruence',1);
%generate p_val
p_val=0;
%generate txy
t_xy=generate_txy(p_x,h_x,wi_deg,d_neg,vars,wp_deg);


for times=1:max_iter

    %iteration 1;
    
    %initial sdp_cons;
    
    
    sdp_cons=sdp_cons_init();
    sdp_cons{1}=vars;
    
    %generate ht_y,ht_x
    ht_y=replace(h_x,a,p_val);
    ht_y=replace(ht_y,xvars,y_vars);
    ht_x=replace(h_x,a,p_val);
    
    
    %solve constrain
    sdp_cons=Loop(ht_y,p_x,[ht_x,loop_cond_ineq],t_xy,lambda,sdp_cons,y_vars,wi_deg,wp_deg);
    sdp_var = sdp_cons{2};
    constraints = sdp_cons{3};
    diagnostics=  solvesos(constraints, lambda, options, sdp_var);
    
    %print info.
    wh_xy_coef=double(sdp_cons{7});
    wht_xy=generate_h(wh_xy_coef,vars,wi_deg);
    % myprint(diagnostics,times,lambda);
    % sdisplay(wht_xy);
    
    
    
    %iteration 2
    sdpvar lambda;
    sdp_cons=sdp_cons_init();
    sdp_cons{1}=xvars;
    sdp_cons{2}=[a];
    % pre cond
    for i=1:length(prelist)
         sdp_cons = SOSnew([prelist{i},x_bound],inv,sdp_cons,0,wi_deg);
    end
    %post with -loopcond
    for i=1:length(negpostlist)
        sdp_cons = SOSnew([negpostlist{i},-loop_cond_ineq,x_bound], -inv, sdp_cons, epsilon,wi_deg);
    end
    %loop condition
    
    sdp_cons{1}=vars;
    sdp_cons=Loop(-h_x*wht_xy+h_y,p_x,[loop_cond_ineq,x_bound],t_xy,lambda,sdp_cons,y_vars,wi_deg,wp_deg);
    %solve constrainte
    sdp_var = sdp_cons{2};
    constraints = sdp_cons{3};
    constraints=[constraints;a_bound];
    diagnostics=  solvesos(constraints, lambda, options, sdp_var);
    
    toc;
    myprint(diagnostics,times,lambda);
    
    p_val=double(a);
  
    sdisplay(replace(h_x,a,p_val));
 
    
end



%seek for better initialization




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


%the function used for iteration

%generate p_val(real_value)* monolist
function h_t=generate_h(p,vars,h_degree)
    monolist_h=monolist(vars,h_degree);
    h_t=dot(p,monolist_h);
end

%generate txy
function sum=generate_txy(p,h_x,wi_deg,d_neg,vars,wh_deg)
    %compute degree k first, k is even.
    k=max(wi_deg+degree(h_x),degree(p)+wh_deg);
    k=max(k,d_neg+wi_deg);
    k=even_degree(k);
    %compute 
    % monolist_var=monolist(vars,k/2);
    % len=length(monolist_var);
    % for i=1:len
    %     monolist_var{i}=monolist_var{i}*monolist_var{i};
    % end
    len_vars=length(vars);
    %n balls into m boxes, y is the pemutation.
    n=k/2;
    m=len_vars;
    r = nchoosek(1:n+m-1,m-1);
    subs = {r(:) repmat((1:size(r,1)).',m-1,1)};
    y = reshape(filter([1 -1],1,find([accumarray(subs,1); ones(1,size(r,1))])),m,[]).'-1;
    %
    y=2*y;
    [m,n]=size(y);
    sum=1;
    for i=1:m
        temp=1;
        for j=1:n
            temp = power(vars(j),y(i,j))*temp;
        end
        sum=sum+temp;
    end  
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



%print lambda
function myprint(diagnostics,times,lambda)
    lam=double(lambda);
    if diagnostics.problem == 0
        fprintf('%5d iteration solution is found. lambda is %12.10f \n',times,lam);
    else
        fprintf('No solution is found:\n'); 
    end
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
 