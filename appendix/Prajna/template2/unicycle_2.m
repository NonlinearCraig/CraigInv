
% with template:inv=a0+a1*x1*x2+a2*x2^2+a3*x1^2;
% 1.479543 seconds。
% 4 iteration solution is found. lambda is -0.0000000002 
% 2.88026566586+0.0122370333583*x1^2+0.012177439725*x2^2

sdpvar x1 x2;   
xvars=[x1,x2];
x_bound=[5-x1,5-x2,5+x1,5+x2];

% pre-conditions
%conjunction shall written in one cell
%disjunction shall written in different cell;
pre_ineq = [-x1^2 -(x2-1)^2 + 1];
prelist={pre_ineq};

% neg_post-condtion
neg_post_ineq = [x1^2 + (x2-1)^2-4];
negpostlist={neg_post_ineq};
d_neg=2;
% % post-condtion
% post_cond_ineq = [2.5*x1^2+4*x1-x2, x2-3.5*x1^2-3*x1];


%loop condition
loop_cond_ineq= [1];
looplist={loop_cond_ineq};

%loop
% y1=x1^2+x2-1;
% y2=x2+y1*x2+1;
% y=[y1,y2];
d = 0.01;
w = 1.0178 + 1.8721 * x1 - 0.0253 * x2; 

p_x=[x1 + d*(1-x2*w); 
    x2 + d*x1*w 
    ];




%template free 

%to get template free h, we need to set h_degree first.
h_degree=2;
%set degrees of polynomials for except the inductive condition
wi_deg=2;
%set degree of polynomials for p_i(x)
wp_deg=2;


epsilon=1e-8;
%a is coef of inv, inv is h(x) here
%inv is in this form:a(1)+x1*a(2)+x2*a(3)+x1^2*a(4)+x1*x2*a(5)+x2^2*a(6)

%template 2
sdpvar a0 a1 a2 a3;
inv=a0+a1*x1*x2+a2*x2^2+a3*x1^2;
a=[a0;a1;a2;a3];
a_bound=[];
%vars definition
sdpvar y1 y2;
y_vars=[y1 y2];
vars=[xvars,y_vars];

%generate lambda as obj
sdpvar lambda;

h_x=inv;
h_y=replace(inv,xvars,y_vars);
