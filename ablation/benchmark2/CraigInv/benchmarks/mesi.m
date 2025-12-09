% 10.452847
% 8 iteration solution is found. lambda is -0.0000000010 
% 9.46074962452+0.0322608572367*vm-0.00798885671649*vs+0.0426129189407*ve+0.0328391288438*vi


% read benchmarks;
sdpvar vm vs ve vi;
xvars = [vm, vs, ve, vi];

%x_bound;
x_bound=[100-vm,100+vm,100-vs,100+vs,100-ve,100+ve,100+vi,100-vi];

% pre-conditions
%conjunction shall written in one cell
pre_ineq = [vm, -vm, vs, -vs, ve, -ve, vi-1];
prelist={pre_ineq};

%neg_post_cond
negpostlist={-1};
d_neg=2;


%guard condition

guard= [1];

%loop condition

loop_cond = [   
         [-1+vi],
        [-1+ve],
        [-1+vs],
        [-1+vi]
];


% while body

% xvars = [va,ve,vr,vq,vp];

f = [
           [  0, vs + ve + vm + 1, 0, vi - 1 ],
        [  vm + 1, vs, ve - 1, vi],
        [  0, 0, 1, vi + vm + ve + vs - 1],
        [  0, 0, 1, vi + vm + ve + vs - 1]
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