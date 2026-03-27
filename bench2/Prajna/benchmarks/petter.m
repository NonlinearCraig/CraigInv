


% read benchmarks;
sdpvar n s;
xvars = [n,s];

%x_bound;
x_bound=[100-n,100+n,100-s,100+s];

% pre-conditions
%conjunction shall written in one cell
pre_ineq = [s, -s, n, -n];
prelist={pre_ineq};

%neg_post_cond
negpostlist={-1};
d_neg=1;


%guard condition

guard= [1];

%loop condition

loop_cond = [   
      1
];


% while body

% xvars = [va,ve,vr,vq,vp];

f = [
          [n + 1, s + n^5]
];
f_deg=degree(f);
r_num=size(f,1);

%to get template free h, we need to set h_degree first.
h_degree=2; 
%set degree of delta(x) except the inductive condition
wi_deg=2;

% inv: q^2 + 2*r*p == a && err > 0
inv_eq=[xvars];
coef_bound=[];
zvars=[xvars];

% zvars and inv_ineq
[inv_ineq,coef]=polynomial([xvars],h_degree);

% epsilon

epsilon=1e-8;