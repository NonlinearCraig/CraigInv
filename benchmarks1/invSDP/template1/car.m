
% template: 
% inv=a(3)+a(1)*x1+a(2)*x1^2<=0;
% Failed



% example: simple
sdpvar x1;
xdim = 1;
vars = [x1];

% Program body
%
% branches
loop_cond = (x1+1)*(x1-82);

branch_num = 1;
f1 = [x1+0.0005*(1000-0.5418*x1^2)];

f_list = [f1];
guard_cond_list = [-1];


% variable range
for i = 1: length(vars)
        range_cond(2*i-1) = -5 - vars(i);
        range_cond(2*i)   = vars(i) - 5;
end
% x_range = [-4, 4, -4, 4];

% pre-conditions
pre_cond_eq = [x1]; 
pre_cond_ineq = [x1*(x1-80)];
% post-condtion
post_cond_ineq = [(x1+10)*(x1-79)];

% invariant template

a = sdpvar(1,3);
for i = 1: length(a)
        a_range(2*i-1) = -10;
        a_range(2*i)   = 10;
end

% a_range = [ -10, 10, -10,  10,-10,10,-10,10];

% inv = a(1)*x1^2 + a(2)*x2^2 -1; 
inv_ineq = [];

inv=a(3)+a(1)*x1+a(2)*x1^2;

% Parameters in SOS constraints translation

% deg 1=0.8
% deg 2=1.9
% deg 3=1.9



M = -10;
sdeg = 6; % max deg in SOS
degrees = [sdeg,sdeg,sdeg,2];
epsilon = 0; % tolerance for >= 