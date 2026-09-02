
sdpvar vx vy vq vr vd;
xvars = [vx,vy,vq,vr,vd];
% x_bound=[];
x_bound=[100-vx,100+vx,100-vy,100+vy,100-vq,100+vq,100+vr,100-vr,100+vd,100-vd];
% pre-conditions
%conjunction shall written in one cell
%disjunction shall written in different cell;
pre_ineq = [vr-vx, vx-vr, vq, -vq];
prelist={pre_ineq};

% neg_post-condtion
neg_post_ineq = [-1];
negpostlist={neg_post_ineq};
d_neg=1;


%guard condition

guard= [vr-vy];

%loop condition

loop_cond = [1
];


% while body

f = [
       [vy, vd, vr - vy*vd, vq + vd, vx], 
      
];
f_deg=degree(f);
r_num=size(f,1);

%to get template free h, we need to set h_degree first.
h_degree=1;
%set degree of delta(x) except the inductive condition
wi_deg=4;

% inv: q^2 + 2*r*p == a && err > 0
inv_eq=[vq*vy+vr];
zvars=[vx];

% zvars and inv_ineq
[inv_ineq,coef]=polynomial([vr,vy,vd],h_degree);
coef_bound=[];
% epsilon

epsilon=0;