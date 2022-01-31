% fonction sous tâche 4 : 
 function [dtmax,maxi,corr] = synchro(rl, preambule, Te, Tp,Fse)

dt= [0:1:120*Fse-1];
corr=zeros(1,length(rl));
denombis=zeros(1,101*Fse);
rapportTpTe=Tp/Te;
taillepreambule=length(preambule);
denom2=0;
for j=1:1:(taillepreambule)
denom2=denom2 + preambule(j)*preambule(j);

end
denom2=sqrt(denom2);
for k=1:(length(corr)-rapportTpTe-1)
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

maxi=max(corr);

for u=1:1:length(corr)
    if (corr(u)==maxi)
        dtmax=dt(floor(u/Fse)+1);
    end
    
end
% ensemble des valeurs de  la corrélation : 



 
 
end
