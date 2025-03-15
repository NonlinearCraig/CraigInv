
#include "assert.h"

void main() {
    float a,b,d,y,P,Q,E;
    a=0;
    d=1;
    y=0;
    __VERIFIER_assume(P >=0);
    __VERIFIER_assume(Q >P);
    __VERIFIER_assume(E >0);
    __VERIFIER_assume(b ==Q/2);
    
    // variant 1
    while(d >= E) {

    if (P<a+b) {
	b=b/2;
        d=d/2;
    } else {
	a=a+b;
        y=y+d/2;
        b=b/2;
        d=d/2;
    }

    }
    __VERIFIER_assert(P>=Q*y);
    __VERIFIER_assert(Q*y+E*Q>P);
}
