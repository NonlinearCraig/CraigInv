

sdpvar vp vq vr vs va vb vx vy;
xvars = [vp, vq, vr, vs,va, vb,vx,vy];
x_bound=[];
x_bound=[100-va,100+va,100-vb,100+vb,100-vp,100+vp,100+vq,100-vq,100-vr,100+vr,100-vs,100+vs];
% pre-conditions
%disjunction shall written in different cell;
pre_ineq = [va-vx, vx-va, vy-vb, vb-vy, vp-1, 1-vp, vq, -vq, vr, -vr , 1-vs, vs-1,vx-1,vy-1];
prelist={pre_ineq};

% neg_post-condtion
neg_post_ineq = [-1];
negpostlist={neg_post_ineq};
d_neg=0;


%guard condition

guard= [1];

%loop condition

loop_cond = [
    va-vb-1
    vb-va
];


% while body

f = [
       [vp-vq, vq, vr-vs, vs, va-vb, vb,vx,vy], 
       [vp, vq-vp, vr, vs-vr, va, vb-va,vx,vy],
];

f_deg=degree(f);
r_num=size(f,1);

%to get template free h, we need to set h_degree first.
h_degree=1;
%set degree of delta(x) except the inductive condition
wi_deg=2;


% inv_ineq
% [inv_ineq,coef]=polynomial([va,vx,vr,vp],h_degree);
sdpvar a0 a1 a2 a3 a4 a5 a6 a7;

inv_ineq=a0*vb+a1*vx*vq +a2*vy*vs+a3+a4*vy+a5*vs+a6*vx+a7*vq;
coef=[a0;a1;a2;a3;a4;a5;a6;a7];
coef_bound=[];
% inv_eq
inv_eq=[vy*vr + vx*vp];
zvars=[va];
% epsilon

epsilon=0;