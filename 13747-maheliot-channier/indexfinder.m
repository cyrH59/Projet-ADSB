function [index] = indexfinder(buff,Fse)
%INDEXFINDER Summary of this function goes here
%   Detailed explanation goes here
    treshold = 100;
    rl=abs(buff.*buff);
    figure;
    x = linspace(0,length(rl),length(rl));
    plot(x,rl);
    k = 100;
    i = 1;
    while k<length(rl) - 120*Fse
        if rl(k) > treshold
            index(i) = k; 
            %disp(k);
            i = i +1;
            k = k + 120*Fse ;
        end
        k = k+1 ;
    end
end

