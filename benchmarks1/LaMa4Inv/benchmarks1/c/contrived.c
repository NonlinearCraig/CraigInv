int main(){
    double x1;
    double x2;

    assume(x1>=-50);
    assume(x1<=50);
    assume(x2>=-50);
    assume(x2<=50);

    //pre-condition
    assume(-8 - x1*x1 + 6*x2 - x2*x2 >= 0);

    //loop-body
    while(-5 - x1*x1 + 6*x2 - x2*x2>=0){
        x1=0.9*x1 + 0.1*x2;
        x2=0.9*x2;
    }

    //post-condition
    assert(-1 - 4*x1 + x1*x1 - 4*x2 + x2*x2<= 0);
    return 0;
}