% s = 
% 
%     "18.8527205092-0.202059500076*a1-0.0187782660226*a2-3.71868819329*a3+0.853446721341*a4-0.00215271692186*a1^2+0.0347022332688*a1*a2+0.674087388156*a2^2-0.354587448245*a1*a3+0.119500686116*a2*a3-5.65228085247*a3^2-0.00733423423922*a1*a4-0.0514457018125*a2*a4+2.02943888154*a3*a4-0.135485821508*a4^2-0.00126114342338*a1^3-0.000398668891825*a1^2*a2-0.00397703702477*a1*a2^2-0.0098175185067*a2^3+0.00728343631391*a1^2*a3+0.0337743945021*a1*a2*a3-0.0330425579833*a2^2*a3-0.106732558526*a1*a3^2+0.189753408239*a2*a3^2-1.66346566272*a3^3+0.000857770032185*a1^2*a4-0.00342776931277*a1*a2*a4+0.0114247802972*a2^2*a4-0.0214632576148*a1*a3*a4-0.18317266072*a2*a3*a4+1.23547583215*a3^2*a4+0.00448713034134*a1*a4^2+0.0145782502659*a2*a4^2-0.180941010546*a3*a4^2+0.0040984896067*a4^3"
% 
%  12.147493
sdpvar x1 x2 x3;
xdim = 3;
vars = [x1, x2, x3];

% Program body
%
% branches
loop_cond = 0;

branch_num = 1;
f1 = [ (2*x1 + x2)*0.1+x1;
    (x1+9*x2+1/2*x3)*0.1+x2;
    (2*x2+16*x3)*0.1+x3];

f_list = [f1];
guard_cond_list = [(x1-3)^2 + x2^2 + (x3-3)^2 - 2];


% variable range
for i = 1: length(vars)
        range_cond(2*i-1) = -5 - vars(i);
        range_cond(2*i)   = vars(i) - 5;
end
% x_range = [-4, 4, -4, 4];

% pre-conditions
pre_cond_eq = [x1;x2;x3]; 
pre_cond_ineq = [(x1-3)^2 + x2^2 + (x3-3)^2 - 0.25 ];
% post-condtion
post_cond_ineq = [-x3 + 0.5*x2^2 + 1];

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
