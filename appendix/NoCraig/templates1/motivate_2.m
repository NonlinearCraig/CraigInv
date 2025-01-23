
% template2:a0+a1*x2+a2*x2^2+a3*x3
% 1.026327 second 1 iteration
% -12.5168016208-0.912662070749*x2+5.47029073943*x3-3.87285688028*x2^2
sdpvar x1 x2 x3;   
xvars=[x1,x2,x3];
x_bound=[10-x1,10+x1,10+x2,10-x2,10-x3,10+x3];

% pre-conditions
%conjunction shall written in one cell
%disjunction shall written in different cell;
pre_ineq = [-(x1-3)^2 - x2^2 - (x3-3)^2 + 0.25];
prelist={pre_ineq};

% neg_post-condtion
neg_post_ineq = [-x3 + 0.5*x2^2 + 1];
negpostlist={neg_post_ineq};
d_neg=2;
% % post-condtion
% post_cond_ineq = [2.5*x1^2+4*x1-x2, x2-3.5*x1^2-3*x1];


%loop condition

loop_cond_ineq= [-(x1-3)^2 - x2^2 - (x3-3)^2 + 2];
looplist={loop_cond_ineq};

%loop
% y1=x1^2+x2-1;
% y2=x2+y1*x2+1;
% y=[y1,y2];




p_x=[(2*x1 + x2)*0.1+x1;
    (x1+9*x2+1/2*x3)*0.1+x2;
    (2*x2+16*x3)*0.1+x3;
    ];


%template free 

%to get template free h, we need to set h_degree first.
h_degree=2;
%set degree of delta(x) except the inductive condition
wi_deg=2;
%set degree of polynomials for p_i(x)
wp_deg=2;


epsilon=1e-6;
%a is coef of inv, inv is h(x) here


sdpvar a0 a1 a2 a3;
inv=a0+a1*x2+a2*x2^2+a3*x3;
a=[a0;a1;a2;a3];
a_bound=[];
%vars definition
sdpvar y1 y2 y3;
y_vars=[y1,y2,y3];
vars=[xvars,y_vars];

%generate lambda as obj
sdpvar lambda;

h_x=inv;
h_y=replace(inv,xvars,y_vars);
