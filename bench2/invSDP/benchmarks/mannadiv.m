% 0.282646 
% A feasible initial solution is found.
%     "14.8422331624+10.412293336*x2+0.0330805407845*y1+0.0332271086509*y2+0.000121735469463*guard"

sdpvar x1 x2 y1 y2 y3;
xvars = [x2, y1, y2, y3];
x_bound=[100-x2,100+x2,100-y1,100+y1,100-y2,100+y2,100-y3,100+y3];

% pre-conditions
%conjunction shall written in one cell
%disjunction shall written in different cell;
pre_ineq = [-y1, y1, -y2, y2, y3-x1, x1-y3, x2];
prelist={pre_ineq};

% neg_post-condtion
negpostlist={-1};
d_neg=1;

%guard condition

guard= [y3];

%loop condition

loop_cond =  [
    [-y2-1+x2, -x2+y2+1],
    [-y2-2+x2, 1],
    [-x2+y2, 1]
];

% while body

f = [
         [  x2, y1 + 1, 0, y3 - 1],
        [  x2, y1, y2 + 1, y3 - 1],
        [  x2, y1, y2 + 1, y3 - 1] 
];
f_deg=degree(f);

r_num=size(f,1);

%to get template free h, we need to set h_degree first.
h_degree=1;
%set degree of delta(x) except the inductive condition
wi_deg=2;


%epsilon
epsilon =1e-8; % tolerance for >= 


% inv: q^2 + 2*r*p == a && err > 0
inv_eq=[xvars];
coef_bound=[];
zvars=[xvars];

% zvars and inv_ineq
[inv_ineq,coef]=polynomial([xvars],h_degree);

% epsilon

epsilon=0;
