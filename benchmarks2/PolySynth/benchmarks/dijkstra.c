
real vp, vq, vr, vn, vh;
  //precondition
@pre(((((vp==0) and (vq<=(4*vn))) and (vq>=(1+vn))) and(vr==vn)));
  
  // loop body
  while(vq>=2,([(vp,vq,vr,vn,vh),1]>=0)){
        if(vr>=vh){
            vp= ((vp*0.5) + (vq*0.25));
            vq = (vq*0.25);
            vr =((vr - vp) - (vq*0.25));
            vn =vn;
            vh=((vq*0.25) + vp);
        } 
        if(((vr - vh) + 1)<=0) 
        {
           vp= (vp*0.5);
           vq = (vq*0.25);
           vr =vr;
           vn =vn;
           vh=((vq*0.25) + vp);   
        } 
        else{
        vp=vp;
        vq=vq;
        vr=vr;
        vn=vn;
        vh=vh;
        }
  }
@post(vq<=2);


