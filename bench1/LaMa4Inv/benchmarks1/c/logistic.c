int main(){
    double x1;

    assume(x1>=-50);
    assume(x1<=50);

    //pre-condition
    assume(x1-x1*x1>= 0);

    //loop-body
    while(0.51 + 1.4*x1 - x1*x1>=0){
        x1=-1.6*x1 + 1.6*x1*x1;
    }

    //post-condition
    assert(-1.5 - 0.5*x1 + x1*x1 <= 0);
    return 0;
}