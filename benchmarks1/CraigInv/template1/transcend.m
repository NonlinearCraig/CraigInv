
sdpvar x1 x2;   
xvars=[x1,x2];
x_bound=[50-x1,50+x1,50+x2,50-x2];
% pre-conditions
%conjunction shall written in one cell
%disjunction shall written in different cell;

% x2>=0 and 1-x1^2-x2^2>=0
pre_ineq = [1-x1^2-(x2-2)^2];
prelist={pre_ineq};

% neg_post-condtion
% 1<=x2<=2 and -2<=x1<=2 
neg_post_ineq = [0.2*x2^2-2+x2];

negpostlist={neg_post_ineq};
d_neg=2;
    

%loop condition
loop_cond_ineq= [3-x1^2-(x2-2)^2];
looplist={loop_cond_ineq};

%loop

p_x=[0.9*x1; 
    x2-0.1*x2*(1+x1);
    ];


%template free  

%to get template free h, we need to set h_degree first.
h_degree=2;
%set degree of delta(x) except the inductive condition
wi_deg=2;
%set degree of polynomials for p_i(x)
wp_deg=2;


epsilon=1e-8;
%a is coef of inv, inv is h(x) here
%inv is in this form:a(1)+x1*a(2)+x2*a(3)+x1^2*a(4)+x1*x2*a(5)+x2^2*a(6)
%h_x: 2*x1^2+2*x2^2
%difference is the coef
[inv,a]=polynomial(xvars,h_degree);
a_bound=[];
%vars definition
sdpvar y1 y2;
y_vars=[y1,y2];
vars=[xvars,y_vars];

%generate lambda as obj
sdpvar lambda;

h_x=inv;
h_y=replace(inv,xvars,y_vars);



