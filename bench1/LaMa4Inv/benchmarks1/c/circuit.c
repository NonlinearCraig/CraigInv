int main(){
    double x1;
    double x2;
    
    assume(x1>=-50);
    assume(x1<=50);
    assume(x2>=-50);
    assume(x2<=50);


    //pre-condition
    assume(0.125 +x1-x1*x1+x2-x2*x2>=0);

    //loop-body
    while(1>= 0){
        x1=8/9*x1 - 1/18*x2;
        x2=0.1*x1 + 0.9*x2;
    }

    //post-condition
    assert(x2*x2 - 4 <= 0);
    return 0;
}