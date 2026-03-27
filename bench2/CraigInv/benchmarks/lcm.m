

sdpvar a b x y u v c;
xvars = [a, b, x, y, u, v,c];
% x_bound=[];
x_bound=[100-a,100+a,100-b,100+b,100+x,100-x,100-y,100+y,100-u,100+u,100-v,100+v];
% pre-conditions
%conjunction shall written in one cell
%disjunction shall written in different cell;
pre_ineq =  [x-a, a-x, y-b, b-y, u-b, b-u, v, -v, c-a*b, a*b-c];
prelist={pre_ineq};

% neg_post-condtion

negpostlist={x*u+y*v-c};
d_neg=2;


%guard condition

guard= [1];

%loop condition

loop_cond  = [    
      [x-y],
      [y-x]
];



% while body

 f = [
          [  a, b, x-y, y, u, v+u, c],
          [  a, b, x, y-x, u+v, v, c]
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