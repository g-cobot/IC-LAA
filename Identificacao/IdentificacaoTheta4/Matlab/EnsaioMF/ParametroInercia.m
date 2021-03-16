%   Universidade Federal de Uberlândia
%   Faculdade de Engenharia Mecânica

%   Identificação da Inercia e atrito den_1 e fs4  
%   Aluno: Gabriel Costa e Silva
% =================================

clear all;
close all;
clc;

global roll_0 roll_dot_0;
global ensaio_size;

rad2deg=180/pi;
deg2rad=pi/180;

ensaio1=importdata('ensaio01_m10.txt'); %[theta1,theta2,theta4,dottheta1,dottheta2,dottheta4,forca1,forca2]

ensaio_size=150;
inicio=208;
fim=inicio+ensaio_size;

roll_0 = ensaio1(inicio:fim,3)*-1;
roll_dot_0 =ensaio1(inicio:fim,6)*-1;

A=0.1157;
vi=0.068118;
Ts=0.02;
Tempoensaio=0:Ts:ensaio_size*Ts;

out = ga(@fitpos,3,[],[],[],[],[0.1 0.1 0.1],[5.5 2.5 5])

%Os valores que eu queria que fosse
%K= 0.3700;
%xi=0.1718;
%wn=3.2705;

%Os valores que são
%fitfun
    %K= 1.3067;
    %xi=0.5341;
    %wn=2.9332;
%fitpos
    %K= 1.1995;
    %xi=0.6067;
    %wn=3.6172;
%fitvel
    %K= 1.6367;
    %xi=0.6361;
    %wn=2.7992;

H = tf(out(1)*(out(3)^2),[1, 2*out(2)*out(3), out(3)^2]);
[y0,t]=step(H,Tempoensaio);
y0=y0*A+vi;
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

Ix4=1.723e-5;%[Kgm^2]
Ixp=0.0141;%[Kgm^2]

Iy2=0.288;%[Kgm^2]
Iy3=1.835e-5;%[Kgm^2]
Iy4=7.608e-5;%[Kgm^2]
Iyp=5.000e-4;%[Kgm^2]
b=0.2132;   %braco bicoptero

par_teoricos=[Ix4+Ixp+l_4*l_4*m_p; g*l_4*m_p];

Kp=0.5;

K=out(1);
xi=out(2);
wn=out(3);
Out= [K xi wn]

Kteorico=(2*Kp(1)*b)/(0.0141*(wn(1)^2));
den1teorico=(2*Kp(1)*b)/(Kteorico*(wn(1)^2));
Kpteorico=(0.0141.*(wn(1).^2)-(g*l_3*m_4))/(2*b);
Kteorico=(2*Kpteorico(1)*b)/(0.0141*(wn(1)^2));
den1teorico=(2*Kpteorico(1)*b)/(Kteorico*(wn(1)^2));


Kp=0.5;

den1=(2*Kp*b)./(K.*(wn.^2));
fs4=den1.*2.*xi.*wn;
gl4mp=den1.*(wn.^2)-2*Kp*b;

par_finais=[den1; fs4; gl4mp];
par_exp=[den1; gl4mp]
par_teoricos

erro_texp=(par_exp-par_teoricos)./par_exp %em porcentagem