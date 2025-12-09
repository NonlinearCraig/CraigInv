
sdpvar vd vs ve vi ;
xvars = [vd, vs, ve, vi];
% x_bound=[];
x_bound=[100-vd,100+vd,100-vs,100+vs,100+ve,100-ve,100-vi,100+vi];
% pre-conditions
%conjunction shall written in one cell
%disjunction shall written in different cell;
pre_ineq =  [vd,-vd, vs, -vs, ve, -ve, vi-1];
prelist={pre_ineq};
 
% neg_post-condtion
negpostlist={-1};
d_neg=0;


%guard condition

guard= [1];

%loop condition

loop_cond  = [    
        [vi-1, -vd, -vs, -ve],
        [vi-1, vd-1, 1, 1],
        [vi-1, vs-1, 1, 1],
        [vi-1, ve-1, 1, 1],
        [ve-1, 1, 1, 1],
        [vs-1, 1, 1, 1],
        [vd-1, 1, 1, 1],
        [vs-1, 1, 1, 1],
        [vi-1, 1, 1, 1]
];



% while body

 f = [
        [  vd, vs, ve + 1, vi - 1],
        [  vd - 1, vs + 2, ve, vi - 1],
        [  vd, vs + ve + 1, 0, vi - 1],
        [  vd, vs + ve + 1, 0, vi - 1],
        [  vd + 1, vs, ve - 1, vi ],
        [  vd + 1, 0, ve, vi + vs - 1],
        [  vd - 1, vs, ve, vi + 1],
        [  vd, vs - 1, ve, vi + 1],
        [  vd, vs, ve - 1, vi + 1]
];

f_deg=degree(f);
r_num=size(f,1);

%to get template free h, we need to set h_degree first.
h_degree=1;
%set degree of delta(x) except the inductive condition
wi_deg=1;

% inv: q^2 + 2*r*p == a && err > 0
inv_eq=[xvars];
coef_bound=[];
zvars=[xvars];

% zvars and inv_ineq
[inv_ineq,coef]=polynomial([vd, vs, ve, vi],h_degree);

% epsilon

epsilon=1e-8;