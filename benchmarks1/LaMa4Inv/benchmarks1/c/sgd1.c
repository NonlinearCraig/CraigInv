int main(){
    double x1;


    //pre-condition
    assume(3 + 2*x1 - x1*x1>=0);

    //loop-body
    while(7+ 1.5*x1 - x1*x1 >= 0){
        x1=0.92*x1 + 0.06*x1*x1 - 0.01*x1*x1*x1;
    }

    //post-condition
    assert(15 - 8*x1 + x1*x1 >= 0);
    return 0;
}