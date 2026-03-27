int main(){
    double x1;
    double x2;
    double x3;

    assume(x1>=-5);
    assume(x1<=5);
    assume(x2>=-5);
    assume(x2<=5);
    assume(x3>=-5);
    assume(x3<=5);


    //pre-condition
    assume( x1*x1 + x2*x2 + x3*x3 - 0.25 <= 0);

    //loop-body
    while(9 - x1*x1 - x2*x2-x3*x3>=0){
        x1=x1 - 0.1*x2;
        x2=x2 - 0.1*x3;
        x3=-0.1*x1 + 0.1*x1*x1*x1 - 0.2*x2 + 0.9*x3;
    }

    //post-condition
    assert(-2*x1 - 2*x2 - 2*x3 - x1*x1 - x2*x2 - x3*x3 + x1*x2 + x1*x3 + x2*x3<=0);
    return 0;
}