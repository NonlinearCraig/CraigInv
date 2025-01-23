

% template 2: a0+a1*x1-x1^2
% 3 iter 0.886566s
% 3.52878594588+2.52573858015*x1-x1^2
% parameter : 2 2 2



sdpvar x1 ;
xvars = [x1];
x_bound=[10-x1,10+x1];

% pre-conditions
%conjunction shall written in one cell
%disjunction shall written in different cell;
pre_ineq = (x1+1)*(3-x1);
prelist={pre_ineq};

% neg_post-condtion
neg_post_ineq = [(3-x1)*(5-x1)];
negpostlist={neg_post_ineq};
d_neg=2;

%loop condition
loop_cond_ineq= [(x1+2)*(3.5-x1)];
looplist={loop_cond_ineq};
%loop
% y1=x1^2+x2-1;
% y2=x2+y1*x2+1;
% y=[y1,y2];
p_x=[x1-0.01*x1*(x1-2)*(x1-4)
    ];



%template free 

%to get template free h, we need to set h_degree first.
h_degree=2;
%set degree of delta(x) except the inductive condition
wi_deg=2;
%set degree of polynomials for p_i(x)
wp_deg=1;


% template 2
sdpvar a0 a1;
inv=a0+a1*x1-x1^2;
a=[a0;a1];
a_bound=[];
%epsilon
epsilon = 0; % tolerance for >= 

%vars definition
sdpvar y1;
y_vars=[y1];
vars=[xvars,y_vars];

%generate lambda as obj
sdpvar lambda;

h_x=inv;
h_y=replace(inv,xvars,y_vars);

