
sdpvar a x r;
xvars = [x,r,a];
% x_bound=[];
x_bound=[100-a,100+a,100-x,100+x,100-r,100+r];
% pre-conditions
%conjunction shall written in one cell
%disjunction shall written in different cell;
pre_ineq =  [a, x-a/2,a/2-x,r,-r];
prelist={pre_ineq};

% neg_post-condtion
% neg_post_ineq1 = [-r^2-r+a];
% neg_post_ineq2 = [r^2-r-a];
% negpostlist={a-r-r^2};

neg_post_ineq1 = [-a-r+r^2];
neg_post_ineq2 = [a-r-r^2];
negpostlist={neg_post_ineq1,neg_post_ineq2};

d_neg=2;


%guard condition

guard= [1];

%loop condition

loop_cond = [x-r-1
];


% while body

f = [
       [x-r, r+1, a]
];

f_deg=degree(f);
r_num=size(f,1);

%to get template free h, we need to set h_degree first.
h_degree=2;
%set degree of delta(x) except the inductive condition
wi_deg=1;


% inv: q^2 + 2*r*p == a && err > 0
inv_eq=[2*x + r^2-r];
coef_bound=[];
zvars=[a];

% zvars and inv_ineq
[inv_ineq,coef]=polynomial([x,r],h_degree);

% epsilon

epsilon=0;