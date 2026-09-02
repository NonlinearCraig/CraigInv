
sdpvar x1 x2 x3;   
xvars=[x1,x2,x3];
x_bound=[5-x1,5+x1,5+x2,5-x2,5-x3,5+x3];

% pre-conditions
%conjunction shall written in one cell
%disjunction shall written in different cell;
pre_ineq = [0.25-x1^2 -x2^2-x3^2];
prelist={pre_ineq};

% neg_post-condtion
neg_post_ineq = [-2*x1-2*x2-2*x3-x1^2-x2^2-x3^2+x1*x2+x1*x3+x2*x3;];
negpostlist={neg_post_ineq};
d_neg=2;
% % post-condtion
% post_cond_ineq = [2.5*x1^2+4*x1-x2, x2-3.5*x1^2-3*x1];


%loop condition
loop_cond_ineq= [9-x1^2-x2^2-x3^2];
looplist={loop_cond_ineq};

%loop
% y1=x1^2+x2-1;
% y2=x2+y1*x2+1;
% y=[y1,y2];




p_x=[x1-0.1*x2;
    x2-0.1*x3;
    x3+(-x1-2*x2 -x3 + x1^3)*0.1;
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
%inv is in this form:a(1)+x1*a(2)+x2*a(3)+x1^2*a(4)+x1*x2*a(5)+x2^2*a(6)
%h_x: 2*x1^2+2*x2^2
%difference is the coef
[inv,a]=polynomial(xvars,h_degree);
a_bound=[];


%vars definition
sdpvar y1 y2 y3;
y_vars=[y1,y2,y3];
vars=[xvars,y_vars];

%generate lambda as obj
sdpvar lambda;

h_x=inv;
h_y=replace(inv,xvars,y_vars);



