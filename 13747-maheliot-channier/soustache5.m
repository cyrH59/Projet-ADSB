clc; clear all; close all;

% sous tâche 5 

b = randi([0 1], 1, 112);
bkbar= zeros(1,length(b));

Te=1/20*10e-6;
Fse=20;
Ts=20*Te;
po=zeros(1,Fse);
p1=zeros(1,Fse);
po(11:20)=1;
p1(1:10)=1;
pet=po;
pet(1:10)=-0.5;
pet(11:20)=0.5;
Tp=8*10e-6;
preambule= zeros(1,161);
preambule(1:20)=p1;
preambule(21:40)=p1;
preambule(61:80)=po;
preambule(81:100)=po;
Nbpointsdt = 100;
Nbpointsdf = 100; 
dt = randi([0 100])*Te;
df = randi([-1000 1000]);
val_dt=dt/Te;

retard = randi([0 1], 1, floor(dt/Te));
retard2= zeros(1,length(retard)*20);
for k=1:length(b)
    if b(k)==0
        sl(1+(k-1)*20:20+(k-1)*20)=po;
    end
    
    if b(k)==1
        sl(1+(k-1)*20:20+(k-1)*20)=p1;
    end
end

taillesl=20*length(b);

abscisse2=linspace(0,length(b)*Ts,20*length(b)+19);
sl= zeros(1,taillesl);
for k=1:length(b)
    if b(k)==0
        sl(1+(k-1)*20:20+(k-1)*20)=po;
    end
    
    if b(k)==1
        sl(1+(k-1)*20:20+(k-1)*20)=p1;
    end
end

yl2 = [retard2 preambule sl];
yl = [retard preambule sl];
abscisse=linspace(0,length(yl)*Te,length(yl));
abscisse2=linspace(0,length(yl2)*Te,length(yl2));
yl = yl.*exp(-1*j*2*pi*df.*abscisse);
yl2 = yl2.*exp(-1*j*2*pi*df.*abscisse2);

%detection

dfest=Synchrof(yl2,abscisse2);
disp("df est :")
disp(df);
disp("df estimé : ")
disp(dfest);
rld2=abs(yl2.*yl2);
rld=abs(yl.*yl);

[dtmax,maxi,corr] = Synchro(rld2, preambule, Te, Tp,Fse);


vl2=conv(pet,rld2);
vl=conv(pet,rld);

abscisseyl2=linspace(0,length(yl2)*Te,length(yl2));
figure()
plot(abscisseyl2,yl2);
ylabel("yl(t)")
xlabel("Temps(s)");
ylim([1.2*min(abs(yl2)) 1.2*max(abs(yl2))])

%% TEB :

sigA2=1; 
Eg= 10;

eb_n0_dB=0:10;
eb_n0=10.^(eb_n0_dB/10);
sigma2=sigA2*Eg./(2*eb_n0);
TEB=zeros(size(eb_n0));
for i=1:length(eb_n0)
    error_cnt=0;
    bit_cnt=0;
    while error_cnt < 100

        bitalea=randi([0,1],1,1000);

        
        retard2= zeros(1,length(retard)*20);

        taillesl=20*length(bitalea);

        abscisse2=linspace(0,length(bitalea)*Ts,20*length(bitalea)+19);
        sl= zeros(1,taillesl);
            for k=1:length(bitalea)
                 if bitalea(k)==0
                    sl(1+(k-1)*20:20+(k-1)*20)=po;
                 end
    
                if bitalea(k)==1
                    sl(1+(k-1)*20:20+(k-1)*20)=p1;
                end
            end
       nl = sqrt(sigma2(i)/2)*(randn(size(sl))+1j*randn(size(sl)))
       sl=sl+nl;
       yl = [retard2 preambule sl];
       %  on désynchronyse 
       for h=1:(length(yl)-dtmax*20-length(preambule))
            yl(h)=yl(h+dtmax*20+length(preambule));
       end
       abscisse=linspace(0,length(yl)*Te,length(yl));
       yl = yl.*exp(-j*2*pi*df.*abscisse);
       yl= yl./exp(-j*2*pi*dfest.*abscisse);
       bkbar2= zeros(1,length(bitalea));



       rl=abs(yl.*yl);
       vl=conv(pet,rl);
       vm=vl(20:Fse:(length(vl)-1));
       
        for k=1:length(bitalea)
            if vm(k)<= 0
                 bkbar2(k)=0;
            end

            if vm(k)>0
                bkbar2(k)=1;
            end
        end
        for s=1:1:1000
            
            if bitalea(s)~= bkbar2(s)
                error_cnt=error_cnt+1;
            end 
        end
        bit_cnt = bit_cnt+1000;
    end
    TEB(i)=error_cnt/bit_cnt;
end

PEB = 1/2.*erfc(sqrt(eb_n0));
semilogy(eb_n0_dB,PEB)
grid on
ylabel('BER')
xlabel('E_b/N_0 (dB)')
title('Bit Error Rate for Binary Phase-Shift Keying')



figure()
semilogy(eb_n0_dB,TEB);
hold on;

semilogy(eb_n0_dB,PEB)
grid on
ylabel('PEB')
xlabel('E_b/N_0 (dB)')
title('Comparaison PEB théorique/expérimentale tâche 5')
legend('PEB (expérimental)','PEB théorique')







%% representation



%représentation sp(t)

abscissesp=linspace(0,8*Tp, length(preambule));
figure()
plot(abscissesp,preambule);
ylabel("représentation sp(t)");
xlabel("Temps");

abscisseyl=linspace(0,length(yl2)*Te,length(yl2));
figure()
plot(abscisseyl,yl2);
ylabel("yl(t)")
xlabel("Temps(s)");
ylim([1.2*min(abs(yl2)) 1.2*max(abs(yl2))])

abscisserld=linspace(0,length(rld2)*Te,length(rld2));
figure()
plot(abscisserld,rld2);
ylabel("rl(t)");
xlabel("Temps(s)");
title('rl(t) + retard')
ylim([0 1.2*max(rld2)])

abscisse=linspace(0,length(rld2)*Te,length(corr));
figure()
plot(abscisse, corr);
xlabel('Temps(s)')
title('correlation sous tâche 4')

disp("La valeur de df estimée est de :");
disp(df);
disp("La valeur de df initial est de :")
disp(dfest);