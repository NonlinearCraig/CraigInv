
sdpvar x1 x2;
xvars = [x1,x2];
x_bound=[50-x1,50+x1,50-x2,50+x2];
% pre-conditions
%conjunction shall written in one cell
%disjunction shall written in different cell;
pre_ineq = [0.25-x1^2-x2^2];
prelist={pre_ineq};

% neg_post-condtion
neg_post_ineq = [2*x2+x1^2-1];
negpostlist={neg_post_ineq};
d_neg=2;


%loop condition
loop_cond_ineq= [3-x1^2-x2^2];
looplist={loop_cond_ineq};
%loop

p_x=[(-0.42*x1-1.05*x2-2.3*x1^2-0.5*x1*x2-x1^3)*0.1+x1,
    x2+0.1*(1.98*x1+x1*x2)
    ];
    


%to get template free h, we need to set h_degree first.
h_degree=2;
%set degree of delta(x) except the inductive condition
wi_deg=2;
%set degree of polynomials for p_i(x)
wp_deg=2;

%template1
[inv,a]=polynomial(xvars,h_degree);
a_bound=[];
% tempalte2
% sdpvar a0 a1 a2 a3 a4
% 
% inv=a0+a1*x1^2+a2*x2^2+a3*x1+a4*x2;
% 
% a=[a0;a1;a2;a3;a4;];

%epsilon
epsilon =1e-6; % tolerance for >= 

%vars definition
sdpvar y1 y2;
y_vars=[y1,y2];
vars=[xvars,y_vars];

%generate lambda as obj
sdpvar lambda;

h_x=inv;
h_y=replace(inv,xvars,y_vars);

