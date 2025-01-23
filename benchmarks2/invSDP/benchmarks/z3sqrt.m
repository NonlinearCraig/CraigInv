


% read benchmarks;
sdpvar va ve vr vq vp;
xvars = [va,ve,vr,vq,vp];

%x_bound;
x_bound=[100-va,100+va,100-ve,100+ve,100-vr,100+vr,100+vq,100-vq,100+vp,100-vp];
% x_bound=[];

% pre-conditions
%conjunction shall written in one cell
pre_ineq = [vr-va+1, va-1-vr, vq-1, 1-vq, vp-0.5,0.5-vp,va-1,ve];
prelist={pre_ineq};

%neg_post_cond
neg_post1=[va-ve-vq^2];
negpostlist=[neg_post1];
d_neg=2;


%guard condition

guard= [2*vp*vr-ve];

%loop condition

loop_cond = [   
        [2*vr-2*vq-vp],
        [-2*vr+2*vq+vp]
];


% while body

% xvars = [va,ve,vr,vq,vp];

f = [
        [  va, ve, 2*vr-2*vq-vp, vq+vp, vp/2], 
        [  va, ve, 2*vr, vq, vp/2 ]
];
f_deg=degree(f);
r_num=size(f,1);

%to get template free h, we need to set h_degree first.
h_degree=1; 
%set degree of delta(x) except the inductive condition
wi_deg=3;

% inv: q^2 + 2*r*p == a && err > 0
inv_eq=[vq^2+2*vr*vp];
coef_bound=[];
zvars=[va];

% zvars and inv_ineq
[inv_ineq,coef]=polynomial([ve],h_degree);


%epsilon
epsilon =1e-8; % tolerance for >= 
