%     8 iteration solution is found. lambda is -0.0000000179 
% -4.90556480509+0.0163372661239*x+9.81848314122*r-4.91684385463*r^2-0.00114011363939*x^2-0.0134442296969*x*r
sdpvar x r s a;
xvars = [x,r,s,a];
% x_bound=[];
x_bound=[100-a,a-1,100-x,x-1,100-r,r-1,100-s,s-1];
% pre-conditions
%conjunction shall written in one cell
%disjunction shall written in different cell;
pre_ineq =  [x-a, a-x,r-1,1-r,s-3.25,3.25-s,a-1];
prelist={pre_ineq};

% neg_post-condtion
negpostlist={ 4*r^3-6*r^2+3*r-4*a-1, 4*a-4*r^3-6*r^2-3*r};
d_neg=3;


%guard condition

guard= [1];

%loop condition

loop_cond = [x-s-1
];


% while body

f = [
       [x-s, r+1, s+6*r+3,a]
];

f_deg=degree(f);
r_num=size(f,1);

%to get template free h, we need to set h_degree first.
h_degree=2;
%set degree of delta(x) except the inductive condition
wi_deg=2;


% inv: q^2 + 2*r*p == a && err > 0 &&
inv_eq=[r^3-3/2*r^2+3/4*r+x-1/4,3*r^2+1/3];
zvars=[a,s];
% inv_eq=[xvars];
% zvars=[xvars];
% zvars and inv_ineq
[inv_ineq,coef]=polynomial([x,r],h_degree);
coef_bound=[]; 
% sdpvar a1
% inv_ineq=x+a+a1*s;
% coef=[a1];

epsilon=0;