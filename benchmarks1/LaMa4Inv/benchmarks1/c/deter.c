int main(){
    double x1;
    double x2;

    assume(x1>=-50);
    assume(x1<=50);
    assume(x2>=-50);
    assume(x2<=50);


    //pre-condition
    assume(-19 + 4*x1 - x1*x1 + 8*x2-x2*x2>=0);

    //loop-body
    while(-16 + 4*x1 - x1*x1 + 8*x2 - x2*x2>= 0){
        x1=x1 + 0.1*x2;
        x2=-0.1*x1 + 1.1*x2 - 0.1*x1*x1*x2;
    }

    //post-condition
    assert(x2 - 4 <= 0);
    return 0;
}