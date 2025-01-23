
sdpvar x1 ;
xvars = [x1];
x_bound=[];

% pre-conditions
%conjunction shall written in one cell
%disjunction shall written in different cell;
pre_ineq = x1*(1-x1);
prelist={pre_ineq};

% neg_post-condtion
neg_post_ineq = [(x1-1.5)*(x1+1)];
negpostlist={neg_post_ineq};
d_neg=2;


%loop condition
loop_cond_ineq= [(x1+0.3)*(1.7-x1)];
looplist={loop_cond_ineq};
%loop

p_x=[-1.6*x1*(1-x1)];
    


%to get template free h, we need to set h_degree first.
h_degree=2;
%set degree of delta(x) except the inductive condition
wi_deg=2;
%set degree of polynomials for p_i(x)
wp_deg=2;




% template 1
[inv,a]=polynomial(xvars,h_degree);
a_bound=[];

%epsilon
epsilon =0; % tolerance for >= 

%vars definition
sdpvar y1;
y_vars=[y1];
vars=[xvars,y_vars];

%generate lambda as obj
sdpvar lambda;

h_x=inv;
h_y=replace(inv,xvars,y_vars);

