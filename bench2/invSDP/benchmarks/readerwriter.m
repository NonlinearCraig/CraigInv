

% read benchmarks;
sdpvar c1 c2 r w k;
xvars = [c1,c2,r,w,k];

%x_bound;
x_bound=[100-c1,100+c1,100-c2,100+c2,100-r,100+r,100-w,100+w,100-k,100+k];

% pre-conditions
%conjunction shall written in one cell
pre_ineq = [r, -r, w, -w, c1, c2 ];
prelist={pre_ineq};

%neg_post_cond
negpostlist={-1};
d_neg=1;


%guard condition

guard= [1];

%loop condition

loop_cond = [   
      [-w,w],
      [-r,r],
      [w,-w],
      [r,-r]
];


% while body

% xvars = [va,ve,vr,vq,vp];

f = [
        [c1, c2, r+1, w, k-c1], 
        [c1, c2, r, w+1, k-c2],
        [c1, c2, r-1, w, k+c1], 
        [c1, c2, r, w-1, k+c2]
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
[inv_ineq,coef]=polynomial([r,w],h_degree);

% epsilon

epsilon=1e-8;