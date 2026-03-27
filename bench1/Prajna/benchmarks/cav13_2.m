
sdpvar x1 x2;
xdim = 2;
xvars = [x1,x2];
x_bound=[];

% pre-conditions
%conjunction shall written in one cell
%disjunction shall written in different cell;
pre_ineq = [2-x1^2-x2^2];
prelist={pre_ineq};

% neg_post-condtion
neg_post_ineq = [-x2 + 0.2*x1^2 - 1.21];
negpostlist={neg_post_ineq};
d_neg=2;

%loop condition
loop_cond_eq=[];
loop_cond_ineq= [3-x1^2-x2^2];
looplist={loop_cond_ineq};
%loop
% y1=x1^2+x2-1;
% y2=x2+y1*x2+1;
% y=[y1,y2];
y1=x1^2+x2-1;
p_x=[x1^2+x2-1;
    x2+y1*x2+1;
    ];



%template free 

%to get template free h, we need to set h_degree first.
h_degree=2;
%set degree of delta(x) except the inductive condition
wi_deg=2;
%set degree of polynomials for p_i(x)
wp_deg=2;



% template 1
[inv,a]=polynomial(xvars,h_degree);

a_bound=[];

%epsilon
epsilon = 0; % tolerance for >= 

%vars definition
sdpvar y1 y2;
y_vars=[y1,y2];
vars=[xvars,y_vars];

%generate lambda as obj
sdpvar lambda;

h_x=inv;
h_y=replace(inv,xvars,y_vars);
