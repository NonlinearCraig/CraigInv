

sdpvar n x y z;
xvars = [n,x,y,z];
% x_bound=[];
x_bound=[100-n,100+n,100-x,100+x,100-y,100+y,100+z,100-z];
% pre-conditions
%conjunction shall written in one cell
%disjunction shall written in different cell;
pre_ineq = [n, -n, x, -x, 1-y, y-1, z-6, 6-z];
prelist={pre_ineq};

% neg_post-condtion
neg_post_ineq = [-1];   
negpostlist={neg_post_ineq};
d_neg=1;


%guard condition

guard= [1];

%loop condition

loop_cond = [1
];


% while body

f = [ [n + 1, x + y, y + z, z + 6] ];

f_deg=degree(f);
r_num=size(f,1);

%to get template free h, we need to set h_degree first.
h_degree=1;
%set degree of delta(x) except the inductive condition
wi_deg=2;


% inv: q^2 + 2*r*p == a && err > 0
inv_eq=[3*n^2+3*n+1,n^3];
zvars=[y,x];



% zvars and inv_ineq
[inv_ineq,coef]=polynomial([n,z],h_degree);
coef_bound=[];

% epsilon

epsilon=0;