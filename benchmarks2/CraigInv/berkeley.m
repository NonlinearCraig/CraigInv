

sdpvar vu ve vn vi vt;
xvars = [vu,ve,vn,vi,vt];
x_bound=[];
x_bound=[100-vu,vu,100-ve,ve,100-vn,vn,100-vi,vi];
% pre-conditions
%disjunction shall written in different cell;
pre_ineq = [vu, -vu, ve, -ve, vn, -vn];
prelist={pre_ineq};

% neg_post-condtion
neg_post_ineq = [-1];
negpostlist={neg_post_ineq};
d_neg=1;


%guard condition

guard= [1];

%loop condition

loop_cond = [
       vi-1, 
       vi-1, 
       vn-1, 
       vu-1
];


% while body

f = [
       [vu + 1, 0, vn + ve, vi - 1,vt], 
       [0, 1, 0, vi + ve + vn + vu - 1,vt],
       [0, ve + 1, 0, vi + vn + vu - 1,vt],
       [0, ve + 1, 0, vi + vn + vu - 1,vt]
];

f_deg=degree(f);
r_num=size(f,1);

%to get template free h, we need to set h_degree first.
h_degree=1;
%set degree of delta(x) except the inductive condition
wi_deg=1;

% inv_ineq

[inv_ineq,coef]=polynomial([xvars],h_degree);
coef_bound=[];
% inv_eq
zvars=[xvars];
inv_eq=[xvars];
% epsilon

epsilon=0;