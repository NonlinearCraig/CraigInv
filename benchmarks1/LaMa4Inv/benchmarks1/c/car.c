int main(){
    double x1;

    //pre-condition
    assume(x1>=-50);
    assume(x1<=-50);
    assume(80*x1-x1*x1>=0);

    //loop-body
    while(82 + 81*x1 - x1*x1>=0){
        x1=0.5 + x1 - 0.0002709*x1*x1;
    }

    //post-condition
    assert(-790 - 69*x1 + x1*x1>= 0);
    return 0;
}