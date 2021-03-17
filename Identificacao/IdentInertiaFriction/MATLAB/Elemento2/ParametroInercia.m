%   Universidade Federal de Uberlândia
%   Faculdade de Engenharia Mecânica

%   Identificação da Inercia e atrito: I_2 e fs2 
%   Aluno: Gabriel Costa e Silva
% =================================

clear all;
close all;
clc;

global roll_0 roll_dot_0;
global ensaio_size;
global n_ensaio;

rad2deg=180/pi;
deg2rad=pi/180;

filename=['ensaio07_5.txt';'ensaio08_5.txt';'ensaio05_5.txt';'ensaio06_5.txt'];
Ts=0.02;

%[theta1,theta2,theta4,dottheta1,dottheta2,dottheta4,forca1,forca2]
n_ensaio=3;
data=importdata(filename(n_ensaio,:)); 

ensaio_size=499;
inicio=1;
fim=inicio+ensaio_size;
roll_0 = data(inicio:fim,2);
roll_dot_0 =data(inicio:fim,5);
A=[0.0417    0.0653    0.0559    0.0700];
vi=[0.0456    0.0220    0.0314    0.0173];

Tempoensaio=0:Ts:ensaio_size*Ts;

out = ga(@fitpos,3,[],[],[],[],[0.1 0.1 0.1],[5.5 2.5 5])

H = tf(out(1)*(out(3)^2),[1, 2*out(2)*out(3), out(3)^2]);
[y0,t]=step(H,Tempoensaio);
y0=y0*A(n_ensaio)+vi(n_ensaio);
ydot=diff(y0)/Ts;
yfit=[y0(1:end-1),ydot];

figure
subplot(2,1,1)
plot(0.02*[1:size(roll_0,1)],roll_0,'b',0.02*[1:size(yfit(:,1))],yfit(:,1),'r--')
xlabel('Time [s]')
ylabel('Rad')
legend('Exp.Data','Mod.Indent')
title('Ensaio 0')


subplot(2,1,2)
plot(0.02*[1:size(roll_dot_0,1)],roll_dot_0,'k',0.02*[1:size(yfit(:,2))],yfit(:,2),'r--')
xlabel('Time [s]')
ylabel('Rad/s')
legend('Exp.Data','Mod.Indent')

figure

y=fft(roll_0);
fs = 1/0.02;
n = length(roll_0);     % number of samples
f = (0:n-1)*(fs/n);     % frequency range
power = abs(y).^2/n; 

plot(f,power,'b-*')
xlabel('Frequency')
ylabel('Power')
title('Ensaio 0')
hold on

ymod=fft(yfit(:,1));
fs = 1/0.02;
n = length(roll_0);        % number of samples
fmod = (0:n-2)*(fs/n);     % frequency range
powermod = abs(ymod).^2/n;  
plot(fmod,powermod,'r')

legend('Exp.Data','Mod.Indent')

K=out(1);
xi=out(2);
wn=out(3);
Out=[K xi wn]
out =[1.1645 0.3557 3.6111]
%Valores teóricos
g=9.81; %[m/s^2]
m_2=2.761; %[Kg]
m_3=0.154; %[Kg]
m_4=0.115; %[Kg]
m_p=0.565; %[Kg]
l_1=0.325;%[m]
l_2=0.595;%[m]
l_3=0.173;%[m]
l_4=0.01474;%[m]
l_G3=0.0516;%[m]
Iy2=0.288;%[Kgm^2]
Iy3=1.835e-5;%[Kgm^2]
Iy4=7.608e-5;%[Kgm^2]
Iyp=5.000e-4;%[Kgm^2]

par_teoricos=[Iy2+Iy3+Iyp+l_2*l_2*(m_3+m_4+m_p)+...
    +l_3*l_3*m_4+l_G3*l_G3*m_3+(l_3+l_4)*(l_3+l_4)*m_p];

Kp=[4,4,4,4];

I2= 2*Kp*l_2./(K.*wn.^2)
fs2=1./(2.*xi.*wn.*I2)
I2optional=(2*Kp*l_2)./wn.^2

par_finais=[I2; fs2];
par_exp=[I2;I2optional]
par_teoricos=par_teoricos.*ones(2,1)
for i=1:4
    erro_texp(:,i)=(par_exp(:,i)-par_teoricos)./par_exp(:,i); %em porcentagem
end

erro_texp