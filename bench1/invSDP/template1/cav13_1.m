%template: inv=a(1)+a(2)*x1^2+a(3)*x2^2;
% s = 
% 
%     "11.8307622507+7.05808243617*a1+1.86087875631*a2+3.29693420365*a3-3.90032524983*a1^2+1.17103664702*a1*a2+2.09897476547*a2^2-1.77690567142*a1*a3-2.6132981394*a2*a3-1.39922473614*a3^2-5.04855822738*a1^3+4.00834453567*a1^2*a2-0.802144731132*a1*a2^2-0.265925756093*a2^3-4.0424300935*a1^2*a3+3.80000066755*a1*a2*a3-0.544184394045*a2^2*a3-4.30133712096*a1*a3^2+2.03898152727*a2*a3^2-1.40152332418*a3^3+6.23396666775*a1^4-5.43725399763*a1^3*a2+0.854070310435*a1^2*a2^2+0.816726703524*a1*a2^3+0.16076513983*a2^4+5.45624232289*a1^3*a3-7.42727973981*a1^2*a2*a3+1.79781659846*a1*a2^2*a3+1.39761877486*a2^3*a3+9.51685970033*a1^2*a3^2-6.37588058861*a1*a2*a3^2-1.59941143485*a2^2*a3^2+4.44364476712*a1*a3^3-2.22192132359*a2*a3^3+3.00549280538*a3^4"
% 
% 14.349597s

% example: simple
sdpvar x1 x2;
xdim = 2;
vars = [x1, x2];

% Program body
%
% branches
loop_cond = 0;

branch_num = 1;
f1 = [  x1^2+x2-1; 
        (x1^2+x2-1)*x2+x2+1];

f_list = [f1];
guard_cond_list = [x1^2 + x2^2 - 3];


% variable range
for i = 1: length(vars)
        range_cond(2*i-1) = -5 - vars(i);
        range_cond(2*i)   = vars(i) - 5;
end
% x_range = [-4, 4, -4, 4];

% pre-conditions
pre_cond_eq = [x1,x2]; 
pre_cond_ineq = [x1^2 + x2^2 - 1];
% post-condtion
post_cond_ineq = [-x2 + 0.2*x1^2 - 1];

% invariant template

a = sdpvar(1,6);
for i = 1: length(a)
        a_range(2*i-1) = -10;
        a_range(2*i)   = 10;
end

% a_range = [ -10, 10, -10,  10,-10,10,-10,10];

inv=a(1)+a(2)*x1^2+a(3)*x2^2+a(4)*x1+a(5)*x2+a(6)*x1*x2;
inv_ineq=[];

% Parameters in SOS constraints translation


M = -10;
sdeg = 4; % max deg in SOS
degrees = [sdeg, sdeg,sdeg,sdeg,sdeg, sdeg,2,2];
epsilon = 0; % tolerance for >= 



