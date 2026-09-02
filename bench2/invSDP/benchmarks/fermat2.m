

sdpvar n rr u v r;
xvars = [rr,u,v,r,n];
% x_bound=[];
x_bound=[100-rr,100+rr,100-u,100+u,100-v,100+v,100+r,100-r,100+n,100-n];
% pre-conditions

pre_ineq = [u-2*rr-1, 2*rr+1-u, v-1, 1-v, r-rr^2+n, rr^2-n-r,n-(rr-1)^2,n-1,rr^2-n];
prelist={pre_ineq};

% neg_post-condtion
neg_post_ineq = [-1];
negpostlist={neg_post_ineq};
d_neg=1;


%guard condition

guard= [1];

%loop condition

loop_cond = [r-1,
    -r
];


% while body

f = [
        [  rr, u, v+2, r-v, n  ],
        [  rr, u+2, v, r+u, n  ] 
];
f_deg=degree(f);
r_num=size(f,1);

%to get template free h, we need to set h_degree first.
h_degree=1;
%set degree of delta(x) except the inductive condition
wi_deg=2;


% inv: q^2 + 2*r*p == a && err > 0
inv_eq=[1/4*u^2-1/4*v^2-1/2*u+1/2*v-n];
zvars=[r];

% zvars and inv_ineq
[inv_ineq,coef]=polynomial([n],h_degree);
coef_bound=[];
% epsilon

epsilon=0;