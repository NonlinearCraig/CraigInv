int main(){
    double x1;
    double x2;

    assume(x1>=-50);
    assume(x1<=50);
    assume(x2>=-50);
    assume(x2<=50);


    //pre-condition
    assume(-x1*x1 + 2*x2 - x2*x2>=0);

    //loop-body
    while(1>= 0){
        x1=0.01 + x1 - 0.018721*x1*x2 - 0.010178*x2 + 0.000253*x2*x2;
        x2=0.018721*x1*x1 + x1*0.010178 - 0.000253*x1*x2 + x2;
    }

    //post-condition
    assert(-3 + x1*x1 - 2*x2 + x2*x2 <= 0);
    return 0;
}