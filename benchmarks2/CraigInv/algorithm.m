yalmip('clear');
clear;
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

euclidex2;
% wensely;


% epsilon = 0;
max_iter=20;
% a denotes coefficient of inv.
%sdp_var use coefficient as vars

sdp_cons=sdp_cons_init();
sdp_cons{1}=[xvars];
sdp_cons{2}=[coef];

% pre cond

for i=1:length(prelist)
    sdp_cons = SOSnew([prelist{i},x_bound],inv_ineq, sdp_cons,0,wi_deg);
end


% % post cond

for i=1:length(negpostlist)
   sdp_cons = SOSnew([negpostlist{i},-guard,x_bound],replace(-inv_ineq,zvars,inv_eq), sdp_cons,0,wi_deg);
end


% set optimization problem
vars = sdp_cons{1};
sdp_var = sdp_cons{2};
constraints = sdp_cons{3};
sigma_cell  = sdp_cons{4}; 
sigma_coef_cell = sdp_cons{5};
tail = sdp_cons{6};

% options = sdpsettings('solver','sdpa','verbose', 0);
options = sdpsettings('solver','mosek','verbose', 0, 'sos.newton',1,'sos.congruence',1);
diagnostics =  solvesdp(constraints, 0, options, sdp_var);

toc;

if diagnostics.problem == 0
    fprintf('A feasible initial solution is found.\n');
    sol = 1;
    p_val = double(coef);
    for i = 1:length(p_val)
        if abs(p_val(i)) <= 10^(-6)
            p_val(i) = 0.0;
        end
    end
    h_0=replace(inv_ineq,coef,p_val);
    s=string(sdisplay(h_0));
    s = strrep(s, 'vars(1)', 'x1');
    s = strrep(s, 'vars(2)', 'x2');
    s = strrep(s, 'vars(3)', 'x3');
    sdisplay(s);
else
    fprintf('No initial solution is found:\n'); 
end

%generate p_val
p_val=double(coef);
%generate txy
t_xy=generate_txy(f_deg,h_degree,wi_deg,d_neg,vars);



% wh_coef: the sos polynomial accompany with h_i(x)
% wh_xy: the coef of h_x 
wh_coef=cell(1,r_num);
for i=1:r_num
    wh_coef{i}=[];
end

% generate monolist
wht_xy_m=monolist(xvars,wi_deg);

sdpvar lambda;
for times=1:max_iter

    %iteration 1;

    %sdp init
    sdp_cons=sdp_cons_init();
    sdp_cons{1}=vars;

    %generate ht_y,ht_x
    ht_y=replace(inv_ineq,zvars,inv_eq);
    ht_y=replace(ht_y,coef,p_val);

    ht_x=replace(inv_ineq,coef,p_val);

    %solve constraint
    for i =1:r_num
        sdp_cons=Loop(replace(ht_y,xvars,f(i,:)),[ht_x,guard,loop_cond(i)],t_xy,lambda,sdp_cons,wi_deg);
        wh_coef{i}=sdp_cons{7};
    end
    sdp_var = sdp_cons{2};
    constraints = sdp_cons{3};
    diagnostics=  solvesos(constraints, lambda, options, sdp_var);
    
    %print info.
    for i=1:r_num
        wh_coef{i}=double(wh_coef{i});
    end
    % myprint(diagnostics,times,lambda);
    % sdisplay(wht_xy);



    %iteration 2
    sdpvar lambda;
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

    sdp_cons{1}=vars;


    for i =1:r_num
        inv_ineq_y=replace(inv_ineq,xvars,f(i,:));
        wht_xy=dot(wht_xy_m,wh_coef{i});
        sdp_cons=Loop(-inv_ineq*wht_xy+inv_ineq_y,[guard,x_bound,loop_cond(i)],t_xy,lambda,sdp_cons,wi_deg);
    end


    %solve constraints
    sdp_var = sdp_cons{2};
    constraints = sdp_cons{3};
    constraints=[constraints;coef_bound];
    diagnostics=  solvesos(constraints, lambda, options, sdp_var);

    toc;
    myprint(diagnostics,times,lambda);

    p_val=double(coef);

    sdisplay(replace(inv_ineq,coef,p_val));


end



%the function used for iteration

%generate p_val(real_value)* monolist
function h_t=generate_h(p_val,vars,h_degree)
    monolist_h=monolist(vars,h_degree);
    h_t=dot(p_val,monolist_h);
end


%translate loop condition in iteration 1;
%the first parameter of square_list must be ht_x)
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


%generate txy
%generate txy
function sum=generate_txy(deg_f,h_degree,wi_deg,deg_n,vars)
    %compute degree k first, k is even.
    k=max(wi_deg+h_degree,deg_f*h_degree);
    k=max(k,deg_n+wi_deg);
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


%print lambda
function myprint(diagnostics,times,lambda)
    lam=double(lambda);
    if diagnostics.problem == 0
        fprintf('%5d iteration solution is found. lambda is %12.10f \n',times,lam);
    else
        fprintf('No solution is found:\n'); 
    end
end
