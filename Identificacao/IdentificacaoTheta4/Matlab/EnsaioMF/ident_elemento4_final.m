clear all
close all

rad2deg=180/pi;
deg2rad=pi/180;

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

Ts=0.02; % periodo de amostragem

ensaio1=importdata('ensaio01_m10.txt'); %[theta1,theta2,theta4,dottheta1,dottheta2,dottheta4,forca1,forca2]
ensaio01=importdata('ensaio01.txt'); %[theta1,theta2,theta4,dottheta1,dottheta2,dottheta4,forca1,forca2]
ensaio02=importdata('ensaio02.txt'); %[theta1,theta2,theta4,dottheta1,dottheta2,dottheta4,forca1,forca2]
ensaio03=importdata('ensaio03.txt'); %[theta1,theta2,theta4,dottheta1,dottheta2,dottheta4,forca1,forca2]

ensaio_size=499;

inicio=[100;1;1;1];
fim=inicio+ensaio_size*ones(4,1);
offset=[0 mean(ensaio01(inicio(2):inicio(2)+20,3))*-1 mean(ensaio02(inicio(3):inicio(3)+20,3))*-1 mean(ensaio03(inicio(4):inicio(4)+20,3))*-1 ]
theta4 = [ensaio1(inicio(1):fim(1),3)*-1,ensaio01(inicio(2):fim(2),3),ensaio02(inicio(3):fim(3),3),ensaio03(inicio(4):fim(4),3)];
theta4=theta4+offset
theta4(:,3)=mean(theta4(:,3),5)
theta4_dot =[ensaio1(inicio(1):fim(1),6)*-1,ensaio01(inicio(2):fim(2),6),ensaio02(inicio(3):fim(3),6),ensaio03(inicio(4):fim(4),6)];

figure
for i = 1:4
    subplot(2,4,i);
    plot([0:ensaio_size]*Ts,theta4(:,i),'Color','[0 0.4470 0.7410]')
    text=strcat('$\theta_',int2str(i),'[rad]$');
    dottext=strcat('$\dot{\theta_',int2str(i),'}[rad]$');
    ylabel(text,'fontsize',14,'interpreter','latex')
    xlabel('$Tempo [s]$','fontsize',14,'interpreter','latex')
    grid on
    hold on
    subplot(2,4,i+4);
    plot([0:ensaio_size]*Ts,theta4_dot(:,i),'Color','[0 0.4470 0.7410]')
    ylabel(dottext,'fontsize',14,'interpreter','latex')
    xlabel('$Tempo [s]$','fontsize',14,'interpreter','latex')
    grid on
    hold on
end

%sobresinal
%sobresinal = (valor maximo - thetainf) / thetainf
rangemax=[153:162,153:162,153:162,153:162];
rangeinf=[390:400,390:400,390:400,390:400];
%valormax1=mean(theta4(rangemax(1),1));
%thetainf1=mean(theta4(rangeinf(1),1));
%sobresinal=[sobresinal_ens(i)];
%xi = sqrt(log(sobresinal).^2)./sqrt(pi^2+(log(sobresinal_ens1)).^2);
for i=1:4
    valormax(i)=mean(theta4(rangemax(i),i));
    thetainf(i)=mean(theta4(rangeinf(i),i));
    sobresinal(i)=  (valormax(i) - thetainf(i))/thetainf(i);
end

xi = sqrt(log(sobresinal).^2)./sqrt(pi^2+(log(sobresinal)).^2);

%tempo de pico
rangetp=[53,35,35,35];
tp=Ts*rangetp;

wn= pi./(tp.* sqrt(1- (xi.^2)));

% tamanho do erro inicial =  valor de referencia - valor inicial do ensaio 
% valor inicial do ensaio sao a medidas dos 8 primeiros valores
ref=10*pi/180; % -10 graus em rad
rangeinit=[1:10,1:10,1:10,1:10]
init_init=[1 1 1 1];
fim_init=[10 20 20 20];
for i=1:4
    valorinicial(i)=mean(theta4(init_init(i):fim_init(i),i));
    erro(i)=  ref-valorinicial(i);
    thetainf(i)=thetainf(i)-valorinicial(i);
end
Amplitude=erro;

K = thetainf./Amplitude;
%K=0.610383295657359;
delay=[2.2 1.5 1 1]
for i=1:4
    subplot(2,4,i);
    H = tf(K(i)*(wn(i)^2),[1, 2*xi(i)*wn(i), wn(i)^2],'inputdelay',delay(i));
    [y,t]=step(H,9);
    y=y.*Amplitude(i)+valorinicial(i);
    plot(t,y,'b');
    title('')
    legend('Res. Exp','Res. Ident.')
    subplot(2,4,i+4);
    tdiff=t(1:end-1);
    ydot=diff(y)/Ts;
    plot(tdiff,ydot,'b');
    title('')
    legend('Res. Exp','Res. Ident.')
end


%Calculo dos parametros
%Kp=[0.305677833,0.305677833,0.305677833,0.305677833];
%Kp=[(0.0141.*(wn(1).^2)-(g*l_3*m_4))/(2*b)]*ones(1,4);
Kp=0.65*ones(1,4);

Kteorico=(2*Kp(1)*b)/(0.0141*(wn(1)^2));
den1teorico=(2*Kp(1)*b)/(Kteorico*(wn(1)^2));

den1=(2*Kp*b)./(K.*(wn.^2));
fs4=den1.*2.*xi.*wn;
gl4mp=den1.*(wn.^2)-2*Kp*b;

par_finais=[den1; fs4; gl4mp];
par_exp=[den1; gl4mp]
for i=1:4
    erro_texp(:,i)=(par_exp(:,i)-par_teoricos)./par_exp(:,i); %em porcentagem
end

erro_texp
%%sgtitle('Resultados Experimentais','fontsize',14,'interpreter','latex')

%print('ResultadosExpTheta4','-dpdf','-bestfit')

%[num,den] = ord2(wn,z) 
% transfar function & response of a 2nd order system
% qsi is tha damping factor
% wn is natural frequency
%num=[K*wn^2];
%den=[1 2*qsi*wn wn^2];
%G=tf(num,den)                  %% get transfar function
%subplot(2,2,1),step(G)      %% step response response of system

