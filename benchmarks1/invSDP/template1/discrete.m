% template1: inv = a(1)*x1^2 + a(2)*x2^2 - 1<=0; 
%No solution is found:



% example: simple
sdpvar x1 x2;
xdim = 2;
vars = [x1, x2];

% Program body
%
% branches
loop_cond = 0;

branch_num = 1;
f1 = [  0.9 * ( x1 - 0.01 * x2); 
        0.9 * ( x2 + 0.01 * x1)];

f_list = [f1];
guard_cond_list = [-1];


% variable range
for i = 1: length(vars)
        range_cond(2*i-1) = -5 - vars(i);
        range_cond(2*i)   = vars(i) - 5;
end
% x_range = [-4, 4, -4, 4];

% pre-conditions
pre_cond_eq = [x1, x2]; 
pre_cond_ineq = [x1^2 + x2^2 - 1];
% post-condtion
post_cond_ineq = [1/4 - x1^2 - (x2-2)^2];

% invariant template




a_range = [ -10, 10, -10,  10,-10,  10,-10,  10,-10,  10,-10,  10];
a = sdpvar(1,6);
inv = a(1)+a(2)*x1+a(3)*x2+a(4)*x1*x2+a(5)*x1^2+a(6)*x2^2; 
inv_ineq = [];



M = -10;

sdeg = 6; % max deg in SOS
degrees = [sdeg, sdeg,sdeg,sdeg,sdeg,sdeg, 4,4];
epsilon = 0; % tolerance for >= 


