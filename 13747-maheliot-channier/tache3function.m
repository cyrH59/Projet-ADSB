function [outdata] = tache3function(b)
%TACHE3FUNCTION Summary of this function goes here
%   Detailed explanation goes here
    %% sous tâche 1 : 

    %preambule = randi([0,1],1,8);
    %b= randi([0,1],88,1);
    polynom = [1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 1];
    h = crc.generator(polynom);
    indata = generate(h, b);

    bkbar= zeros(1,length(b));
    fe=20*10e6;
    Te=1/fe;
    Fse=20;
    Ts=20*Te;
    po=zeros(1,Fse);
    p1=zeros(1,Fse);
    po(11:20)=1;
    p1(1:10)=1;
    pet=po;
    pet(1:10)=-0.5;
    pet(11:20)=0.5;

    taillesl=20*length(indata);
    sl= zeros(1,taillesl);
    %% Emetteur
    for k=1:length(indata)
        if indata(k)==0
            sl(1+(k-1)*20:20+(k-1)*20)=po;
        end

        if indata(k)==1
           sl(1+(k-1)*20:20+(k-1)*20)=p1;
        end
    end
    %% Canal

    %% Recepteur
    rl=conv(pet,sl);
    rm=rl(Fse:Fse:length(indata)*Fse+(Fse-1));
    for k=1:length(indata)
        if rm(k) <= 0
             bkbar(k)=0;
        end

        if rm(k) > 0
            bkbar(k)=1;
        end   
    end
    detector = crc.detector('Polynomial',polynom);
    [outdata] = detect(detector, indata);
end

