

sdpvar vd vs ve vi;
xvars = [vd, vs, ve, vi];
% x_bound=[];
x_bound=[10-vd,10+vd,10-vs,10+vs,10-ve,10+ve,10-vi,10+vi];
% pre-conditions
%conjunction shall written in one cell
%disjunction shall written in different cell;
pre_ineq =  [vd, -vd, vs, -vs, ve, -ve, vi-1];
prelist={pre_ineq};

% neg_post-condtion
neg_post_ineq = [];
negpostlist={-1};
d_neg=1;


%guard condition

guard= [1];

%loop condition

loop_cond  = [    
        [-vd, -vs, -ve, vi-1],
        [-1+vi, -1+vd, 1, 1],
        [-1+vi, vs-1, 1, 1],
        [-1+vi, ve-1, 1, 1],
        [-1+ve, 1, 1, 1],
        [-1+vs, 1-vs, 1, 1],
        [-1+vi, 1, 1, 1]
];


% while body

f = [
        [  vd, vs, ve + 1, vi - 1],
        [  vd - 1, vs + 2, ve, vi - 1], 
        [  vd, vs + ve + 1, 0, vi - 1], 
        [  vd, vs + ve + 1, 0, vi - 1],
        [  vd + 1, vs, ve - 1, vi],
        [  vd, vs - 1, ve + 1, vi],
        [  1, 0, 0, vi + ve + vd + vs - 1]
];

f_deg=degree(f);
r_num=size(f,1);

%to get template free h, we need to set h_degree first.
h_degree=1;
%set degree of delta(x) except the inductive condition
wi_deg=1;


zvars=[xvars];
inv_eq=[xvars];




% zvars and inv_ineq
[inv_ineq,coef]=polynomial([vd,vs,ve],h_degree);
coef_bound=[];

% sdpvar a0 a1 a2 a3 a4
% inv_ineq=a0*vd+a1*vs+a2*ve+a3*vt+a4;
% coef=[a0;a1;a2;a3;a4];
% coef_bound=[];
% epsilon

epsilon=0;