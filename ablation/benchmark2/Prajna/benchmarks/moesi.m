


% read benchmarks;
sdpvar vm vs ve vi vo;
xvars = [vm, vs, ve, vi,vo];

%x_bound;
x_bound=[100-vm,100+vm,100-vs,100+vs,100-ve,100+ve,100+vi,100-vi,100+vo,100-vo];

% pre-conditions
%conjunction shall written in one cell
pre_ineq = [vm,-vm, vs, -vs, ve, -ve];
prelist={pre_ineq};

%neg_post_cond
negpostlist={-1};
d_neg=1;


%guard condition

guard= [1];

%loop condition

loop_cond = [   
        [vi-1],
        [ve-1],
        [vs-1],
        [vo-1],
        [vi-1]
];


% while body


f = [
        [  0, vs + ve + 1, 0, vi - 1, vo + vm], 
        [  vm + 1, vs, ve - 1, vi, vo ], 
        [  0, 0, 1,vi + vm + ve + vs + vo - 1, 0],
        [  0, 0, 1,vi + vm + ve + vs + vo - 1, 0],
        [  0, 0, 1,vi + vm + ve + vs + vo - 1, 0]
];
f_deg=degree(f);
r_num=size(f,1);

%to get template free h, we need to set h_degree first.
h_degree=1; 
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