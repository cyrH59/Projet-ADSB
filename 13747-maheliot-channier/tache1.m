clear 
clc
close all


%% sous tâche 1 : 

b= [1 0 0 1 0];
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


taillesl=20*length(b);
abscisse=linspace(0,5*Ts);
abscisse2=linspace(0,5*Ts,119);
sl= zeros(1,taillesl);
for k=1:length(b)
    if b(k)==0
        sl(1+(k-1)*20:20+(k-1)*20)=po;
    end
    
    if b(k)==1
        sl(1+(k-1)*20:20+(k-1)*20)=p1;
    end
end
rl=conv(pet,sl);
rm=rl(20:Fse:119);
for k=1:length(b)
    if rm(k)==-5
         bkbar(k)=0;
    end
    
    if rm(k)==5
        bkbar(k)=1;
    end
    
    
    
    
end

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

        taillesl2=20*length(bitalea);
        abscisse3=linspace(0,length(bitalea)*Ts,20000);
        abscisse4=linspace(0,5*Ts,20019);
        sl2= zeros(1,taillesl2);
        for k=1:length(bitalea)
            if bitalea(k)==0
                sl2(1+(k-1)*20:20+(k-1)*20)=po;
            end

            if bitalea(k)==1
                sl2(1+(k-1)*20:20+(k-1)*20)=p1;
            end
        end
        nl=sqrt(sigma2(i)/2)*(randn(size(sl2))+1j*randn(size(sl2)));
        sl2=sl2+nl;
        rl2=conv(pet,sl2);
        rm2=rl2(20:Fse:length(rl2));
        bkbar2= zeros(1,length(bitalea));
        for k=1:length(bitalea)
            if rm2(k)<= 0
                 bkbar2(k)=0;
            end

            if rm2(k)>0
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








%% representation

figure()
plot(abscisse,sl);
ylim([-0.15;1.15])
xlabel("Temps")
ylabel("sl(t)")
title('sl(t) pour  [1,0,0,1,0]')

figure()
plot(abscisse2,rl);
ylim([-6;6]);
xlabel("Temps")
ylabel("rl(t)")
title('rl(t) pour  [1,0,0,1,0]')


abscisse3=zeros(1,5);
for k=1:5
abscisse3(1,k)=k*Ts;
end
figure()
plot(abscisse3,rm,'*');
ylim([-6;6]);
xlabel("Temps")
ylabel("rm")
title('rm pour  [1,0,0,1,0]')




figure()
plot(abscisse3,sl2);

xlim([0; 0.1*10e-7])


figure()
plot(abscisse4,rl2);
ylim([-6;6]);

figure()
semilogy(eb_n0_dB,TEB);
hold on;

semilogy(eb_n0_dB,PEB)
grid on
ylabel('PEB')
xlabel('E_b/N_0 (dB)')
title('Comparaison PEB théorique/expérimentale')
legend('PEB (expérimental)','PEB théorique')



