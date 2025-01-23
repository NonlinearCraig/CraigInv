function algorithm(benchmark, adeg)

yalmip('clear')

run(strcat(benchmark,'.m'))

epsilon = 0;
M = -1;

a=coef;
lvars = [a', xvars];

a_range=[ones(2*length(a),1)];
for i=1:length(a)
    a_range(2*i-1)=-10;
    a_range(2*i)=10;
end
sdeg=6;
degrees=[sdeg*ones(length(xvars),1);2*ones(length(a),1)];
[p_a, coef_p] = polynomial(a, adeg);
a_monomials = monolist(a, adeg);

% Scaling "a" variables
% 
a_scaled = a;
for i = 1:length(a)
    min = a_range(2*i-1);
    max = a_range(2*i);
    a_scaled(i) = (max-min)/2*a_scaled(i)+(max+min)/2;
end

inv_ineq = replace(inv_ineq, a, a_scaled);

moments = [];
for i = 1:length(a_monomials)
    moments(i) = compute_moment(a, a_monomials(i));
end
obj = dot(moments,coef_p);

% make box constraints for a_var and x_var
for i = 1:length(a)
    a_range_cond(2*i-1) = -1-a(i);
    a_range_cond(2*i) = a(i)-1;
end
range_cond= [a_range_cond, x_bound];
% fprintf(fileID,string(range_cond));
% Encode SOS constraints
%


sdp_cons=sdp_cons_init();
sdp_cons{1}=[lvars];
sdp_cons{2}=[coef_p];

% pre cond

poly1=inv_ineq+p_a;
for i=1:length(prelist)
    sdp_cons = SOSnew([prelist{i},range_cond],poly1, sdp_cons,0,degrees);
end


% % post cond

poly2=replace(-inv_ineq,zvars,inv_eq)+p_a;
for i=1:length(negpostlist)
   sdp_cons = SOSnew([negpostlist{i},-guard,range_cond],poly2, sdp_cons,0,degrees);
end

% M

sdp_cons = SOSnew([range_cond],p_a+1, sdp_cons,0,degrees);


%generate ht_y,ht_x
ht_yz=replace(inv_ineq,zvars,inv_eq);

%loop cond
for i =1:r_num
    ht_y=replace(ht_yz,xvars,f(i,:))+p_a;
    sdp_cons= SOSnew([inv_ineq,guard,loop_cond(i),x_bound],ht_y,sdp_cons,0,degrees);
end




% set optimization problem
vars = sdp_cons{1};
sdp_var = sdp_cons{2};
constraints = sdp_cons{3};
sigma_cell  = sdp_cons{4}; 
sigma_coef_cell = sdp_cons{5};
tail = sdp_cons{6};

options = sdpsettings('solver','mosek','verbose', 0, 'sos.newton',1,'sos.congruence',1);

% toc 
% fprintf("Begin Solving...\n");

diagnostics=  solvesos(constraints, obj, options, sdp_var);  

if diagnostics.problem == 0
    %fprintf('A feasible solution is found.\n')
    sol = 1;
    p_val = double(coef_p);
    for i = 1:length(p_val)
        p_val(i) = round(p_val(i), 5);
    end
    p_a_val = dot(p_val,a_monomials);
    
    
    s = string(sdisplay(dot(p_val,a_monomials)));
    s = strrep(s, 'a(1)', 'a1');
    s = strrep(s, 'a(2)', 'a2');
    s = strrep(s, 'a(3)', 'a3');
    s = strrep(s, 'a(4)', 'a4');
    display(s);
else
    fprintf('No solution is found:\n'); 
end


end



function moment = compute_moment(a,a_monomial)
    exp_list = degree(a_monomial,a);
    moment = 1;
    for i=1:length(exp_list)
        upper = 1/(exp_list(i)+1);
        lower = (-1)^(exp_list(i)+1)*1/(exp_list(i)+1);
        moment = moment*(upper-lower);
    end
end


%encode precondition and post condition
function sdp_cons = SOSnew(pre_list,inv,sdp_cons, epsilon, degrees)
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
        [delta_cell{tail}, delta_coef_cell{tail}] = polynomial(vars, degrees);    
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



