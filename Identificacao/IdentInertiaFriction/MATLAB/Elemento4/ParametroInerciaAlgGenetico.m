%   Universidade Federal de Uberl�ndia
%   Faculdade de Engenharia Mec�nica

%   Identifica��o da Inercia e atrito I_4 e fs4  
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

ensaio_size=300;
inicio=213;
fim=inicio+ensaio_size;
A=0.1157;
ref=10*deg2rad;
vi=0.066925;
Ts=0.02;
Tempoensaio=0:Ts:(ensaio_size-1)*Ts;

roll_0 = ensaio1(inicio:fim,3)*-1 - vi; % menos o valor inicial para ficar zerado
roll_dot_0 =ensaio1(inicio:fim,6)*-1;

out = ga(@Js,4,[],[],[],[],[0.2 5 3 15],[2 17 8 20])

Out=[out(1) out(2) out(3) out(4)];
%Parametros dado pelo Ident Matlab
e1=0.7091;e2=14.53;e3=5.314;e4=17.95;
Out(2,:)=[e1 e2 e3 e4];

J = tf([out(1) out(2)],[1, out(3), out(4)]);
[y0,t]=step(J,Tempoensaio);
y0=y0*ref;
ydot=diff(y0)/Ts;
yfit=[y0(1:end-1),ydot];

J2 = tf([e1 e2],[1, e3, e4]);
[y02,t]=step(J2,Tempoensaio);
y02=y02*ref;
ydot2=diff(y02)/Ts;
yfit2=[y02(1:end-1),ydot];

figure
subplot(2,1,1)
plot(0.02*[0:ensaio_size-1],roll_0(1:ensaio_size),'b',0.02*[0:size(yfit(:,1))-1],yfit(:,1),'r--')
hold on
plot(0.02*[0:size(yfit2(:,1))-1],yfit2(:,1),'g--')
xlabel('Time [s]')
ylabel('Rad')
legend('Exp.Data','Mod.GA','Mod.Ident')
title('Ensaio A')

subplot(2,1,2)
plot(0.02*[0:ensaio_size-1],roll_dot_0(1:ensaio_size),'k',0.02*[1:size(yfit(:,2))],yfit(:,2),'r--')
xlabel('Time [s]')
ylabel('Rad/s')
legend('Exp. Data','Mod.Indent')

%Valores te�ricos
g=9.81; %[m/s^2]
m_4=0.115; %[Kg]
m_p=0.565; %[Kg]
l_4=0.01571;%[m]
Ix4=1.893e-5;%[Kgm^2]
Ixp=0.0140;%[Kgm^2]
b=0.2132;   %braco bicoptero
par_teoricos=[Ix4+Ixp+l_4*l_4*m_p;g*l_4*m_p; Ix4+Ixp+l_4*l_4*m_p; g*l_4*m_p];
par_teoricos=par_teoricos.*ones(4,2);
Kp=0.8;
Kd=0.2;
for i=1:2
    e1=Out(i,1);
    e2=Out(i,2);
    e3=Out(i,3);
    e4=Out(i,4);
    
    I4=(2*b*Kd)/(e1);
    fs4=(e3*I4)-(2*b*Kd);
    gl4mp=(e4*I4)-(2*b*Kp);

    I4opt=(2*b*Kp)/(e2);
    fs4opt=(e3*I4opt)-(2*b*Kd);
    gl4mpopt=(e4*I4opt)-(2*b*Kp);
    par_finais(:,i)=[I4;fs4; gl4mp; I4opt;fs4opt; gl4mpopt];
    par_exp=[I4; gl4mp; I4opt; gl4mpopt];
    erro_texp(:,i)=(par_exp-par_teoricos(:,i))./par_exp; %em porcentagem
end
[erro_texp(2,:);erro_texp(4,:)]
par_finais

fs=30
figure
plot(0.02*[0:ensaio_size-3],roll_0(1:ensaio_size-2))
hold on
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',fs*0.6)
ax.TickLabelInterpreter='latex';
plot(0.02*[0:size(yfit2(:,1))-1],yfit2(:,1),'r--')
ylim([0 max(yfit2(:,1))*1.2])
grid on
xlabel('$Tempo\hspace{0.5em}[s]$','fontsize',fs,'interpreter','latex')
ylabel('$\theta_4\hspace{0.5em}[rad]$','fontsize',fs,'interpreter','latex')
legend('$Resultado\hspace{0.5em}Experimental$','$Modelo\hspace{0.5em}Identificado$','fontsize',fs*0.6,'interpreter','latex')
%title('$Ensaio\hspace{0.5em}A$','fontsize',20,'interpreter','latex')

