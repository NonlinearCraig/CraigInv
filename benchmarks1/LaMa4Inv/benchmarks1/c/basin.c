int main(){
    double x1;
    double x2;
    
    assume(x1>=-50);
    assume(x1<=50);
    assume(x2>=-50);
    assume(x2<=50);

    //pre-condition
    assume(0.25 - x1*x1 - x2*x2 >= 0);

    //loop-body
    while(3 - x1*x1 - x2*x2>=0){
        x1=-0.23*x1*x1 - 0.1*x1*x1*x1 + 0.958*x1 - 0.05*x1*x2 - 0.105*x2;
        x2=x2 + 0.198*x1 + 0.1*x1*x2;
    }

    //post-condition
    assert(2*x2 + x1*x1 - 1<=0);
    return 0;
}