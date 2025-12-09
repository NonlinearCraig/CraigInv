% example: simple
sdpvar x1 x2 x3;
xdim = 3;
vars = [x1, x2, x3];

% Program body
%
% branches
loop_cond = 0;

branch_num = 1;
f1 = [ x1-0.1*x2;
    x2-0.1*x3;
    x3+(-x1-2*x2 -x3 + x1^3)*0.1];

f_list = [f1];
guard_cond_list = [-9+x1^2+x2^2+x3^2];


% variable range
for i = 1: length(vars)
        range_cond(2*i-1) = -5 - vars(i);
        range_cond(2*i)   = vars(i) - 5;
end
% x_range = [-4, 4, -4, 4];

% pre-conditions
pre_cond_eq = [x1;x2;x3]; 
pre_cond_ineq = [-0.25+x1^2+x2^2+x3^2 ];
% post-condtion
post_cond_ineq = [-2*x1-2*x2-2*x3-x1^2-x2^2-x3^2+x1*x2+x1*x3+x2*x3 ];

% invariant template

inv_ineq = [];

[inv,a]=polynomial(vars,2);

for i = 1: length(a)
        a_range(2*i-1) = -10;
        a_range(2*i)   = 10;
end

a=a';

% Parameters in SOS constraints translation

% deg 1=0.8
% deg 2=1.9
% deg 3=1.9



M = -10;
sdeg = 6; % max deg in SOS
degrees = [sdeg,sdeg, sdeg,sdeg,sdeg,sdeg,sdeg,sdeg,sdeg,sdeg,2,2,2];
epsilon = 0; % tolerance for >= 
