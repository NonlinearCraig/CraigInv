% template1: inv = a(1)*x1^2 + a(2)*x2^2 - 1<=0; 
% s = 
% 
%     "3.55538692265+3.58231232157*a1+3.58231249904*a2+3.39272866461*a1^2-3.20336387432*a1*a2+3.39272854598*a2^2+1.01882435732*a1^3-2.23422879709*a1^2*a2-2.23422838837*a1*a2^2+1.01882428497*a2^3"
% 
% 1.268954 s



% example: simple
sdpvar x1 x2;
xdim = 2;
vars = [x1, x2];

% Program body
%
% branches
loop_cond = 0;

branch_num = 1;
f1 = [  x1+0.1*x2; 
        x2+(x2*(1-x1^2)-x1)*0.1];

f_list = [f1];
guard_cond_list = [-4+(x1-2)^2+(x2-4)^2];


% variable range
for i = 1: length(vars)
        range_cond(2*i-1) = -5 - vars(i);
        range_cond(2*i)   = vars(i) - 5;
end
% x_range = [-4, 4, -4, 4];

% pre-conditions
pre_cond_eq = [x1, x2]; 
pre_cond_ineq = [-1+(x1-2)^2+(x2-4)^2];
% post-condtion
post_cond_ineq = [x2-4];

% invariant template




a_range = [ -10, 10, -10,  10,-10,  10,-10,  10,-10,  10,-10,  10];
a = sdpvar(1,4);
inv =a(1)+a(2)*x2^2+a(3)*x1^2+a(4)*x1; 
inv_ineq = [];
% a = sdpvar(1,6);
% inv=a(1)+a(2)*x1+a(3)*x2+a(4)*x1*x2+a(5)*x1^2+a(6)*x2^2;
% a_range = [ -10, 10, -10,  10,-10,  10,-10,  10,-10,  10,-10,  10];
% Parameters in SOS constraints translation

adeg = 2;  
% 4 6
% deg 1: 0.8s
% deg 2: 1.7s
% deg 3: 1.8s
% deg 4: 3.2s   
M = -10;

sdeg = 6; % max deg in SOS
degrees = [sdeg, sdeg,sdeg,sdeg, 2,2];
epsilon = 0; % tolerance for >= 


% a = sdpvar(1,2);
% a_range = [ -1, 1, -1,  1];
% inv = x1^2 + 10*a(1)*x2^2 + 10*a(2); 
% inv_ineq = [];
% % Parameters in SOS constraints translation

% adeg = 4;  
% % 4 6
% % deg 1: 0.8s
% % deg 2: 1.7s
% % deg 3: 1.8s
% % deg 4: 3.2s
% M = -10;

% sdeg = 6; % max deg in SOS
% degrees = [sdeg, sdeg, 2,2];
% epsilon = 0; % tolerance for >= 
