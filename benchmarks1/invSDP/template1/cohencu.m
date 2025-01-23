% template inv = a(1)+a(2)*n + a(3)*x +a(4)*n^2;
% s = 
% 
%     "87.5096828343-0.728921890661*a1-3.61688929664*a2+3.6074505892*a3-18.1933681218*a4-0.040419671288*a1^2-0.285433645246*a1*a2-1.16376706642*a2^2+0.0765222957674*a1*a3+1.22536937302*a2*a3+0.0517234937794*a3^2-0.440198425338*a1*a4-6.46089269302*a2*a4+0.0228641528255*a3*a4-0.0787270694387*a4^2"
% 
% 3.660942 s。
 



sdpvar n x;
xdim = 2;
vars = [n, x];

% loop condition 
loop_cond = n-5;

% while body
branch_num = 1;
f1 = [  n + 1, 
        x + 5.5*n + 5.5,
]; 
f_list = [f1]; 
% guard conditions
guard_cond_list = [-1];

% variable range
for i = 1: length(vars)
    range_cond(2*i-1) = -5 - vars(i);
    range_cond(2*i)   = vars(i) - 5;
end

% pre-condition
pre_cond_eq = [0, 0];
pre_cond_ineq = [-1]; % -a<=0

% post-condtion
post_cond_ineq = [2.5*n^2+4*n-x, x-3.5*n^2-3*n];


a = sdpvar(1,6);
a_range = [-10, 10,-10, 10,-10, 10,-10,10,-10,10,-10,10];


inv = a(1)+a(2)*n + a(3)*x +a(4)*n^2+a(5)*x^2+a(6)*x*n;
inv_ineq = [-n]; % -a<=0


% deg = 1: 3.5s 
% deg = 2: 4.3s -> found

M = -10;
sdeg = 4; % max deg in SOS
degrees = [sdeg, sdeg, sdeg,sdeg,2,2,2,2];
epsilon = 0; % tolerance for >= 