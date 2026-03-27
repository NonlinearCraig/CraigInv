int main(){
    double x1;
    double x2;
    double x3;

    //pre-condition
    assume( x1*x1 + x2*x2 + x3*x3 - 1/4 <= 0);

    //loop-body
    while(-16 + 6*x1 - x1*x1 - x2*x2 + 6*x3 - x3*x3>=0){
        x1=1.2*x1 + 0.1*x2;
        x2=0.1*x1 + 1.9*x2 + 0.05*x3;
        x3=0.2*x2 + 2.6*x3;
    }

    //post-condition
    assert(-x3 + 0.5*x2*x2 + 1<=0);
    return 0;
}