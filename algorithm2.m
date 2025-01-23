%seek for better initialization
yalmip('clear');
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
basin;
% motivate;
% lyapunov;



% epsilon = 0;
max_iter=20;
% initial h0 to get p_val(initial coef of h)
% a denotes coefficient of inv.
%sdp_var use coefficient as vars


sdp_cons=sdp_cons_init();
sdp_cons{1}=vars;
sdp_cons{2}=[a];


p_y=replace(p_x,xvars,y_vars);

% pre cond
for i=1:length(prelist)
    sdp_cons = SOSnew(prelist{i},inv-1,sdp_cons,0,wi_deg);
end

%in post should be negpostlist and -loop_cond_ineq;
for i=1:length(negpostlist)
    sdp_cons = SOSnew([negpostlist{i};-loop_cond_ineq], -inv-1, sdp_cons, 0,wi_deg);
end


%disjunction of prelist and disjunction of looplist;
for i=1:length(prelist)
    for j=1:length(looplist)
    sdp_cons = Loop(inv-1,p_y,[looplist{j};prelist{i}],0,0,sdp_cons,xvars,wi_deg,wp_deg);
    end
end

sdp_var = sdp_cons{2};
constraints = sdp_cons{3};

fprintf("Begin Solving...\n");
% 


options = sdpsettings('solver','mosek','verbose', 0, 'sos.newton',1,'sos.congruence',1);
diagnostics =  solvesdp(constraints, 0, options, sdp_var);
if diagnostics.problem == 0
    fprintf('A feasible initial solution is found.\n')
    sol = 1;
    p_val = double(a);
    for i = 1:length(p_val)
        if abs(p_val(i)) <= 10^(-6)
            p_val(i) = 0.0;
        end
    end
    h_0=replace(h_x,a,double(a));
    s=string(sdisplay(h_0));
    s = strrep(s, 'vars(1)', 'x1');
    s = strrep(s, 'vars(2)', 'x2');
    s = strrep(s, 'vars(3)', 'x3');
    sdisplay(s);
else
    fprintf('No initial solution is found:\n'); 
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
function sum=generate_txy(p,h_x,wi_deg,d_neg,vars,wp_deg)
    %compute degree k first, k is even.
    k=max(wi_deg+degree(h_x),degree(p)+wp_deg);
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
function sdp_cons = Loop(ht_y,p_x,square_list,t_xy,lambda,sdp_cons,y_vars,wi_deg,wp_deg)
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
        [delta_cell{tail}, delta_coef_cell{tail}] = polynomial(vars,wp_deg);    
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
 
 