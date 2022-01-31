 function [dfest] = Synchro(yl,abscisse)
 
 dfest=0;
 for k=-1000:1:1000
 yl2=yl./exp(-j*2*pi*k.*abscisse);
 

 if(max(imag(yl2))==0)
 dfest=k+1;

 end
 
 
 end
 
 
 end