int main(){
    double x1;
    double x2;

    assume(x1>=-50);
    assume(x1<=50);
    assume(x2>=-50);
    assume(x2<=50);


    //pre-condition
    assume(-0.99 + 2*x1 - x1*x1 >= 0);
    assume( 0.2*x2 - x2*x2 >= 0);

    //loop-body
    while(2 - x1*x1 - x2*x2>= 0){
        x1=0.5*x1*x1 + 0.4*x2*x2;
        x2=-0.6*x1*x1 + 0.3*x2*x2;
    }

    //post-condition
    assert(x2 + 2*x1 - 2<= 0);
    return 0;
}