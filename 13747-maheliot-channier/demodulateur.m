function [bits] = demodulateur(rl)
%BUFFERING Summary of this function goes here
%   Detailed explanation goes here
    Fse = 4;
    po=zeros(1,Fse);
    pet=po;
    pet(1:Fse/2)=-0.5;
    pet(Fse/2+1:Fse)=0.5;
   %rl=abs(buff.*buff);
   vl=conv(pet,rl);
   %disp(vl)
   vm=vl(Fse:Fse:(length(vl)-1));
   %disp(vm);
   bits = zeros(length(vm),1);
    for k=1:length(vm)
        if vm(k)<= 0
             bits(k)=0;
        end

        if vm(k)>0
            bits(k)=1;
        end
    end
end

