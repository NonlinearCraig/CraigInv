
%define vars
sdpvar vp vq ve va vb vd vy;
xvars = [vp,vq,ve,va,vb,vd,vy];

%define var bound;
x_bound=[100-vp,100+vp,100-vq,100+vq,100-ve,100+ve,100+va,100-va,100+vb,100-vb,100+vd,100-vd,100+vy,100-vy];


% pre-conditions
%conjunction shall written in one cell
%disjunction shall written in different cell;
pre_ineq =  [vd-1,1-vd,vy,-vy,vq-vp-1,vp-1,ve-1,va,-va,vb-vq/2,-vb+vq/2];
prelist={pre_ineq};

% neg_post-condtion
neg_post_ineq1 = [vy*vq-vp];
neg_post_ineq2 = [-ve*vq+vp-vq*vy-1];
negpostlist={ neg_post_ineq1,neg_post_ineq2 };
% negpostlist={-vp + vq*vy};
d_neg=2;

%guard condition
guard= [vd-ve+1];
d_guard=degree(guard);

%loop condition
loop_cond = [
       1-vp+va+vb, 
       -va-vb+vp, 
];
d_guard=max(degree(loop_cond,d_guard));

% while body
f = [
       [  vp, vq, ve, vd/2, vy, va, vb/2], 
       [  vp, vq, ve, vd/2, vy+vd/2, va+vb, vb/2]
];

f_deg=degree(f);
r_num=size(f,1);

%to get template free h, we need to set h_degree first.
h_degree=2;
%set degree of delta(x) except the inductive condition
wi_deg=2;

% inv_eq to be substitute
inv_eq=[vq*vy,vq*vd/2];
coef_bound=[];
zvars=[va,vb];


% zvars and inv_ineq
[inv_ineq,coef]=polynomial([vp,vy,vq],h_degree);

%epsilon
epsilon =1e-8; % tolerance for >= 


