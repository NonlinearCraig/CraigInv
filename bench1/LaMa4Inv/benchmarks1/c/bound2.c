int main(){
    double x1;
    double x2;

    assume(x1>=-50);
    assume(x1<=50);
    assume(x2>=-50);
    assume(x2<=50);


    //pre-condition
    assume(-0.35 + 1.2*x1 - x1*x1 >= 0);
    assume(-0.35 + 1.2*x2 - x2*x2 >= 0);

    //loop-body
    while(1 - x1*x1 - x2*x2>= 0){
        x1=0.5*x1*x1*x1 + 0.4*x2*x2;
        x2=-0.6*x1*x1 + 0.3*x2*x2;
    }

    //post-condition
    assert(x1*x1 + x2*x2 - 0.36<= 0);
    return 0;
}