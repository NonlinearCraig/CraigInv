real A,B,q,r,b;
@pre(((((q==0) and (r==A)) and (b==B)) and(b>=(r+1))));
while(((B + 1) - b)<=0,([(A,B,q,r,b),1]>=0)){
        if(r>=b){
            A = A;
            B = B;
            q = ((2*q) + 1);
            r = (r - (b*2));
            b = (b*0.5);
        } 
        if(((r - b) + 1)<=0) 
        {
           A = A;
           B = B;
           q = (2*q);
           r = r;
           b = (b*0.5);     
        } 
        else{
         A = A;
         B = B;
         q = q;
         r = r;
         b = b;    
        }
  }

@post( 1>=0);
