function [registre] = tache8_recepteur(buff,Fse)
%INDEXFINDER Summary of this function goes here
%   Detailed explanation goes here
    po=zeros(1,Fse);
    p1=zeros(1,Fse);
    po(Fse/2+1:Fse)=1;
    p1(1:Fse/2)=1;
    preambule= zeros(1,Fse*8);
    preambule(1:Fse)=p1;
    preambule(Fse+1:2*Fse)=p1;
    preambule(3*Fse+1:4*Fse)=po;
    preambule(4*Fse+1:5*Fse)=po;
    Te=1/Fse*10e-6;
    Tp=8*10e-6;
    ref_lat = 44.8069;
    ref_lon = -0.6066;
    addpath(genpath('src'))
    rl=abs(buff.*buff);
    treshold = 0.75;
    k = 1;
    bits = zeros(120,1);
    i = 1;
    j=1;
    registre = bit2registre(bits(9:120,1),ref_lat,ref_lon);
    while k<length(rl) - 120*Fse*2 -1
        [dtmax,maxi,corr] = synchro(rl(k:k+120*Fse-1),preambule,Te,Tp,Fse);
        if maxi >= treshold
             disp(dtmax)
             disp(k)
             indice = k-Fse*8+120*Fse ;
            bits(:,i) = demodulateur(rl(indice:indice+120*Fse-1));
            registre1 = bit2registre(bits(9:120,i),ref_lat,ref_lon);
            if (strcmp(registre1.format,"ADS-B") == 1 && registre1.type == 11) || (strcmp(registre1.format,"ADS-B") == 1 && registre1.type <= 4)
                registre(j) = bit2registre(bits(9:120,i),ref_lat,ref_lon);
                j = j+1;
            end
            i = i+1;
            k = k+120*Fse;
            disp(registre)
        end
        %disp(k)
         k = k + 1;
    end
%     figure;
%     subplot(121)
%     plot(preambule);
%     subplot(122)
%     plot(rl(indice:indice+8*Fse));
end 