int main(){
    double x1;


    //pre-condition
    assume(3 + 2*x1 - x1*x1>=0);

    //loop-body
    while(7+ 1.5*x1 - x1*x1 >= 0){
        x1=0.992*x1 + 0.006*x1*x1 - 0.001*x1*x1*x1;
    }

    //post-condition
    assert(10 - 7*x1 + x1*x1 >= 0);
    return 0;
}