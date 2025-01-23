# README

- Please add the path of benchmarks before running the **Matlab** codes.

- The following two files run with **Matlab** on Windows.

  **Algorithm1.m** means the original algorithm in Section 4.

​       **Algorithm2.m** means the algorithm in Section 5.

​       Open the algorithm files, choose the benchmark, and hit run. 

- The way to implement your own benchmark is ( take ex2 as an example) :

  ```matlab
  % 1. preset your vars
  
  sdpvar x1 x2;
  
  xvars=[x1,x2];
  
  % 2. set the domain of  your vars
  
  
  x_bound=[5-x1,5+x1,5-x2,5+x2];
  
  
  % 3. set pre condition, post condition, and loop condition. 
  
  
  % the algorithm support conjunction and disjunction of different conditions.
  
  
  % pre_condition
  
  % conjunction shall written in one cell, separate by commas, enclosed with middle brackets.
  
  % the precondition here is 1-x1^2-x2^2>=0
  
  pre_ineq = [1-x1^2-x2^2];
  
  % disjunction shall written in different cell, enclosed with curly brackets.
  
  prelist={pre_ineq};
  
  % the neg post-condtion here is 0.25-x1^2-(x2-2)^2>=0
  
  neg_post_ineq = [0.25-x1^2-(x2-2)^2];
  
  negpostlist={neg_post_ineq};`
  
  %loop condition
  
  loop_cond_ineq= [1-x1^2-x2^2];`
  
  looplist={loop_cond_ineq};`
  
  % 4. Set the loop
  
  
  p_x=[0.9*(x1-0.01*x2);
  
  0.9*(x2+0.01*x1);
  
  ];
  
  
  % 5. Set your own template.
  
  
  %to get template free h, we need to set h_degree first.`
  
  h_degree=2;
  
  %set degree of delta(x) except the inductive condition`
  
  wi_deg=2;`
  
  %set degree of polynomials for p_i(x)`
  
  wp_deg=2;`
  
  epsilon=1e-6;`
  
  % template 1
  
  [inv,a]=polynomial(xvars,h_degree);`
  
  %a_bound.(optional) 
  
  a_bound=[];
  
  % 6. Set the tolerance.
  
  
  %epsilon is setted with 0 ~ 1e-6
  
  epsilon = 1e-8; % tolerance for >=
  
  % 7. Generate yvars corresponding your benchmark.
  
  
  % vars definition, with new introduced vars, the algorithms can run faster.
  
  sdpvar y1 y2;
  
  y_vars=[y1 y2];
  
  vars=[xvars,y_vars];
  
  %generate lambda as obj
  
  sdpvar lambda;
  
  h_x=inv;
  
  h_y=replace(inv,xvars,y_vars);
  
  
  ```

  After running, use tools such as  Z3 or Mathematica to make post-verification, the verification template using Z3 can be found in check..ipynb 

- For other tools,  cvc5 runs on Linux, and Z3 runs with JupyterLab on Windows. PolySynth runs on Linux with scripts from their websites: https://github.com/polysynth Meanwhile, there is a **Readme.md** file for each tool, you can follow the instructions to run the benchmarks.

