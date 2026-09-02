int main(){
    double x1;
    double x2;

    assume(x1>=-50);
    assume(x1<=50);
    assume(x2>=-50);
    assume(x2<=50);


    //pre-condition
    assume(2-x1*x1-x2*x2>=0);

    //loop-body
    while(3- x2*x2 - x1*x1 >= 0){
        x1=x1*x1 + x2 - 1;
        x2=1 + x1*x1*x2 + x2*x2;
    }

    //post-condition
    assert(-x2 + 0.2*x1*x1 - 1.21 <= 0);
    return 0;
}