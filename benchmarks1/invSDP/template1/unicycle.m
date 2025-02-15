

sdpvar x1 x2
xdim = 2;
vars = [x1, x2];

% loop condition 
loop_cond = -1;

% body
branch_num = 1;

d = 0.01;
w = 1.0178 + 1.8721 * x1 - 0.0253 * x2;    

f1 = [ x1 + d*(1-x2*w); 
       x2 + d*x1*w 
];

f_list = [f1];

guard_cond_list = [-1];

% variable range
for i = 1: length(vars)
       range_cond(2*i-1) = -5 - vars(i);
       range_cond(2*i)   = vars(i) - 5;
end
% x_range = [0, 10, 0, 10];

% pre-conditions
pre_cond_eq = [x1,x2];
pre_cond_ineq = [x1^2 + (x2-1)^2 - 1];

% post-condtion
post_cond_ineq = [x1^2 + (x2-1)^2 - 4];

% ----- Invariant template ------
%

a = sdpvar(1,6);
a_range = [-10, 10, -10, 10, -10, 10,-10,10,-10, 10,-10, 10];

% invariant template
% inv = x1^2 + a(1)*x2^2 + a(2)*x2 + a(3); 
inv=a(1)+a(2)*x1*x2+a(3)*x2^2+a(4)*x1^2+a(5)*x1+a(6)*x2;
inv_ineq = [];


% 34 
% deg1 : 0.9
% deg2 : 3.3
% deg3 : 3.8
% deg4 : 13.3

% deg6: 44
sdeg = 4;
degrees = [sdeg, sdeg, sdeg, sdeg,sdeg,sdeg,2,2];
epsilon = 0;
M = -10;