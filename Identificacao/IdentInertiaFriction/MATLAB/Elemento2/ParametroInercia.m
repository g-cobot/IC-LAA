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

rad2deg=180/pi;
deg2rad=pi/180;

filename=['ensaio07_5.txt';'ensaio08_5.txt';'ensaio05_5.txt';'ensaio06_5.txt'];
Ts=0.02;

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
n_ensaio=1;
par_teoricos=[Iy2+Iy3+Iyp+l_2*l_2*(m_3+m_4+m_p)+...
    +l_3*l_3*m_4+l_G3*l_G3*m_3+(l_3+l_4)*(l_3+l_4)*m_p];


ensaio_size=499;
inicio=1;
fim=inicio+ensaio_size-1;
Tempoensaio=0:Ts:ensaio_size*Ts;
ref=5*deg2rad;
n_ensaio=4

par_teoricos=par_teoricos.*ones(1,n_ensaio+1);
vi=[0.0456 0.0220 0.0314 0.017262];
% i=4
% data=importdata(filename(i,:));
% roll_0 = data(inicio:fim,2)-vi(i);
% roll_dot_0 =data(inicio:fim,5);
% plot(roll_0)

%[theta1,theta2,theta4,dottheta1,dottheta2,dottheta4,forca1,forca2]
figure
for i=1:n_ensaio
    data=importdata(filename(i,:));
    roll_0 = data(inicio:fim,2)-vi(i);
    roll_dot_0 =data(inicio:fim,5);
    out = ga(@Hs,3,[],[],[],[],[0.5 0.1 0],[1 0.5 5])
    Out(i,:)=[out(1) out(2) out(3)];
    H = tf(Out(i,1)*(Out(i,3)^2),[1, 2*Out(i,2)*Out(i,3), Out(i,3)^2]);
    [y0,t]=step(H,Tempoensaio);
    y0=y0*ref;
    ydot=diff(y0)/Ts;
    yfit=[y0(1:end-1),ydot];
    text=strcat('$Ensaio ',int2str(i),'$');
    subplot(2,n_ensaio,i)
    plot(0.02*[0:size(roll_0,1)-1],roll_0,'b',0.02*[0:size(yfit(:,1))-1],yfit(:,1),'r--')
    xlabel('Time [s]')
    ylabel('Rad')
    legend('Exp.Data','Mod.Indent')
    title(text,'fontsize',14,'interpreter','latex')
    
    subplot(2,n_ensaio,i+n_ensaio)
    plot(0.02*[0:size(roll_dot_0,1)-1],roll_dot_0,'k',0.02*[0:size(yfit(:,2))-1],yfit(:,2),'r--')
    xlabel('Time [s]')
    ylabel('Rad/s')
    legend('Exp.Data','Mod.Indent')
end

%out =[1.1645 0.3557 3.6111]
Kp=4;
Out(n_ensaio+1,:)=[mean(Out(2:end,1)) mean(Out(2:end,2)) mean(Out(2:end,3))]
for i=1:(n_ensaio+1)
    K=Out(i,1);
    xi=Out(i,2);
    wn=Out(i,3);
    
    I2= 2*Kp*l_2./(K.*wn.^2);
    fs2=1./(2.*xi.*wn.*I2);
    
    I2opt=(2*Kp*l_2)./wn.^2;
    fs2opt=1./(2.*xi.*wn.*I2);
    
    par_finais(i,:)=[I2 fs2 I2opt fs2opt];
    par_exp=[I2; I2opt];
    erro_texp(:,i)=(par_exp-par_teoricos(:,i))./par_exp; %em porcentagem
end

data=importdata(filename(3,:));
roll_0 = data(inicio:fim,2)-vi(3);
H = tf(Out(3,1)*(Out(3,3)^2),[1, 2*Out(3,2)*Out(3,3), Out(3,3)^2]);
[y0,t]=step(H,Tempoensaio);
y0=y0*ref;
ydot=diff(y0)/Ts;
yfit=[y0(1:end-1),ydot];
fs=30
figure
plot(0.02*[0:ensaio_size-3],roll_0(1:ensaio_size-2))
hold on
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',fs*0.6)
ax.TickLabelInterpreter='latex';
plot(0.02*[0:size(yfit(:,1))-1],yfit(:,1),'r--')
ylim([0 max(yfit(:,1))*1.1])
grid on
xlabel('$Tempo\hspace{0.5em}[s]$','fontsize',fs,'interpreter','latex')
ylabel('$\theta_2\hspace{0.5em}[rad]$','fontsize',fs,'interpreter','latex')
legend('$Resultado\hspace{0.5em}Experimental$','$Modelo\hspace{0.5em}Identificado$','fontsize',fs*0.6,'interpreter','latex')
%title('$Ensaio\hspace{0.5em}A$','fontsize',20,'interpreter','latex')


erro_texp
