

% read benchmarks;
sdpvar su t n a;
xvars = [su,t,n,a];

%x_bound;
x_bound=[100-su,100+su,100-t,100+t,100-n,n,100-a,100+a];

% pre-conditions
%conjunction shall written in one cell
pre_ineq = [a, -a, su-1, 1-su, t-1, 1-t,n];
prelist={pre_ineq};

%neg_post_cond
negpostlist={[a^2-n],[n-(a+1)^2]};
d_neg=2;


%guard condition

guard= [1];

%loop condition

loop_cond = [   
    n-su
];


% while body

% xvars = [va,ve,vr,vq,vp];

f = [
        [su + t + 2, t + 2, n, a + 1]
];
f_deg=degree(f);
r_num=size(f,1);

%to get template free h, we need to set h_degree first.
h_degree=2; 
%set degree of delta(x) except the inductive condition
wi_deg=3;

inv_eq=[2*a + 1,(a + 1)^2 ];
coef_bound=[];
zvars=[t,su];

% zvars and inv_ineq
[inv_ineq,coef]=polynomial([n,a],h_degree);

% epsilon

epsilon=1e-8;