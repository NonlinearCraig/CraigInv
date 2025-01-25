
% template2 :a0+a1*x1+a2*x2+a3*x1^2
% 1.893327
% 4 iteration solution is found. lambda is -0.0000000015 
% 0.152000413348+0.766286963162*x1+0.349522902493*x2-0.873505559422*x1^2




sdpvar x1 x2;
xvars=[x1,x2];
x_bound=[x1,x2,10-x1,10-x2];

% pre-conditions
%conjunction shall written in one cell
%disjunction shall written in different cell;
pre_ineq1 = [x1,-x1,-x2,x2];

prelist={pre_ineq1};

% neg_post-condtion

neg_post_ineq1 = [2.5*x1^2+4*x1-x2;];
neg_post_ineq2 = [x2-3.5*x1^2-3*x1;];
negpostlist={neg_post_ineq1,neg_post_ineq2};
d_neg=2;

% % post-condtion
% post_cond_ineq = [2.5*x1^2+4*x1-x2, x2-3.5*x1^2-3*x1];


%loop condition

loop_cond_ineq= [5-x1];
looplist={loop_cond_ineq};


%loop
p_x=[x1 + 1,
    x2 + 5.5*x1 + 5.5,
    ];


%template free 

%to get template free h, we need to set h_degree first.
h_degree=2;
%set degree of delta(x) except the inductive condition
wi_deg=2;
%set degree of polynomials for p_i(x)
wp_deg=1;

%template 1
% [inv,a]=polynomial(xvars,h_degree);

% template 2
sdpvar a0 a1 a2 a3 a4
inv=a0+a1*x1+a3*x2+a4*x1^2;
a=[a0; a1;a2;a3;a4;];

a_bound=[a<=1];


%epsilon
epsilon = 1e-8; % tolerance for >= 
%vars definition
sdpvar y1 y2;
y_vars=[y1 y2];
vars=[xvars,y_vars];

%generate lambda as obj
sdpvar lambda;  

h_x=inv;
h_y=replace(inv,xvars,y_vars);
