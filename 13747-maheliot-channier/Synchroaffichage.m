% tracer corr : 
function [corr] = Synchroaffichage(rl, preambule, Te, Tp,Fse)
corr=zeros(1,length(rl));
rapportTpTe=Tp/Te;
taillepreambule=length(preambule);
denom2=0;
for j=1:1:(taillepreambule)
denom2=denom2 + preambule(j)*preambule(j)

end
denom2=sqrt(denom2);
for k=1:length(corr)
    numerateur=0;
    denom1=0;
    
    for i=(k+1):1:(k+rapportTpTe)
      numerateur=numerateur+rl(i)*preambule(i-k); 
      denom1 = rl(i)*rl(i)+denom1;
      
    end
    denom1=sqrt(denom1);
    denominateur=denom1*denom2;
    if (denominateur==0)
        corr(k)=0;
    end
    denombis(k)=denominateur;
    
    if (denominateur~= 0)
         corr(k)=numerateur/denominateur;
    end
  
end  


end