clear all
clc
close all

%% tâche 2 : 

% test fonction welch : 


%% variables : 
echantillon_test = randi([0 1], 1, 1000);
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
Fe=100;


taillesl=20*length(echantillon_test);
sl= zeros(1,taillesl);
Nfft=256;

%% pwelch : 
for k=1:length(echantillon_test)
    if echantillon_test(k)==0
        sl(1+(k-1)*20:20+(k-1)*20)=po;
    end
    
    if echantillon_test(k)==1
        sl(1+(k-1)*20:20+(k-1)*20)=p1;
    end
end

figure();
plot(sl);
xlim([0 1*10^3]);
ylim([0 2]);
title('sl(t)');
xlabel('Temps(s)')

%y2 = Mon_Welch2(sl,Nfft,Fe);
y = Mon_Welch(sl,Nfft,Fe);
abscisse = linspace(-Fe/2,Fe/2,Nfft);
abscisse2 = linspace(-Fe/2,Fe/2,10000);
f=0.06;




%% DSP théo : 
v= conv(pet,conj(flip(pet)))/Fse;
taillef=1024;
gam=zeros(1,taillef);
TF=fftshift(fft(v,taillef));
for i=1:length(gam)
gam(i)=(abs(TF(i)).^2)/Ts;

end
gam(513)=gam(513)+0.5;
abscissetheo=linspace(-1e6,1e6,taillef);
figure;
semilogy(abscissetheo,abs(gam));
title('DSP théorique')
xlabel('Frequence (Hz)');
ylabel('Amplitude');
%exf= linspace(-10,10,400);
%dsptheo = sinc(1/2*exf)*sinc(1/2*exf)*sin(1/4*exf)*sin(1/4*exf)
%figure()
%plot(dsptheo)


% 