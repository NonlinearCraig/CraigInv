
% template 2
% 0.971798 second
% 3 iteration solution is found. lambda is -0.0000000500 
% -0.0733780053491+3.09723393784*x2-x1^2-x2^2

sdpvar x1 x2;   
xvars=[x1,x2];
x_bound=[10-x1,10+x1,10+x2,10-x2];
% pre-conditions
%conjunction shall written in one cell
%disjunction shall written in different cell;

% x2>=0 and 1-x1^2-x2^2>=0
pre_ineq = [1-x1^2-(x2-2)^2];
prelist={pre_ineq};

% neg_post-condtion
% 1<=x2<=2 and -2<=x1<=2 
neg_post_ineq = [0.2*x2^2-2+x2];

negpostlist={neg_post_ineq};
d_neg=2;
    

%loop condition
loop_cond_ineq= [3-x1^2-(x2-2)^2];
looplist={loop_cond_ineq};

%loop

p_x=[0.9*x1; 
    x2-0.1*x2*(1+x1);
    ];


%template free  

%to get template free h, we need to set h_degree first.
h_degree=2;
%set degree of delta(x) except the inductive condition
wi_deg=2;
%set degree of polynomials for p_i(x)
wp_deg=2;


epsilon=1e-8;
%a is coef of inv, inv is h(x) here
%inv is in this form:a(1)+x1*a(2)+x2*a(3)+x1^2*a(4)+x1*x2*a(5)+x2^2*a(6)

sdpvar a0 a1 a2 a3;
inv=a0-x1^2-x2^2+a3*x2;
a=[a0;a1;a2;a3];
a_bound=[];
%vars definition
sdpvar y1 y2;
y_vars=[y1,y2];
vars=[xvars,y_vars];

%generate lambda as obj
sdpvar lambda;

h_x=inv;
h_y=replace(inv,xvars,y_vars);



