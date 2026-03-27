

sdpvar x1 x2;
xvars=[x1,x2];
x_bound=[50-x1,50+x1,50-x2,50+x2];

% pre-conditions
%conjunction shall written in one cell
%disjunction shall written in different cell;
%if you want to add bound for x, add them in all cells;
pre_ineq = [1-x1^2-x2^2];
prelist={pre_ineq};

% neg_post-condtion
%conjunction shall written in one cell
%disjunction shall written in different cell;
neg_post_ineq = [0.25-x1^2-(x2-2)^2];
negpostlist={neg_post_ineq};
d_neg=2;
% post-condtion


%loop condition
loop_cond_ineq= [1-x1^2-x2^2];
looplist={loop_cond_ineq};

%loop

p_x=[0.9*(x1-0.01*x2); 
    0.9*(x2+0.01*x1);
    ];


%template free 

%to get template free h, we need to set h_degree first.
h_degree=2;
%set degree of delta(x) except the inductive condition
wi_deg=2;
%set degree of polynomials for p_i(x)
wp_deg=2;

epsilon=1e-6;



% template 1
[inv,a]=polynomial(xvars,h_degree);

%a_bound.(optional) 
a_bound=[];
%epsilon
epsilon = 0; % tolerance for >= 

%vars definition
sdpvar y1 y2;
y_vars=[y1 y2];
vars=[xvars,y_vars];

%generate lambda as obj
sdpvar lambda;

h_x=inv;
h_y=replace(inv,xvars,y_vars);