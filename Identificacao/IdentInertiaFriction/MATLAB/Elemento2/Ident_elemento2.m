clc
clear all
close all
format short



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



% Formato de informacoes nos ensaios
%[theta1,theta2,theta4,dottheta1,dottheta2,dottheta4,forca1,forca2]
filename=['ensaio07_5.txt';'ensaio08_5.txt';'ensaio05_5.txt';'ensaio06_5.txt'];

for i=1:4
    data=importdata(filename(i,:));
    %recuperando apenas theta2
    ensaio(:,i)= data(:,2);
end

Ts=0.02; % 20 milisegundos
ensaio_size=250;
inicio=[1;1;1;1];
fim=inicio+ensaio_size*ones(4,1);

figure
for i= 1:4
    subplot(4,1,i);
    text=strcat('$\theta_',int2str(i),'[rad]$');
    plot([inicio(i):fim(i)]*Ts,ensaio(inicio(i):fim(i),i),'Color',[0.8500 0.3250 0.0980])
    ylabel(text,'fontsize',14,'interpreter','latex')
    xlabel('$Tempo [s]$','fontsize',14,'interpreter','latex')
    grid on
    hold on
end

%analise dos dados
%sobresinal
%max_range=[31:37;47:52;54:58;51:55];
in_max=[31;47;54;51];
fim_max=[37;52;58;55];
for i=1:4
    max_value(i)=mean(ensaio(in_max(i):fim_max(i),i));
end
in_inf=[450;450;450;450];
fim_inf=[500;500;500;500];

for i=1:4
    theta_inf(i)=mean(ensaio(in_inf:fim_inf,i));
end

sobresinal= (max_value-theta_inf)./theta_inf;

xi = sqrt(log(sobresinal).^2)./sqrt(pi^2+(log(sobresinal)).^2);

%tempo de pico
tp=Ts*[34 49.5 59 53];

wn = pi./(tp.* sqrt(1- (xi.^2)));

% tamanho do erro inicial =  valor de referencia - valor inicial do ensaio 
ref=5*pi/180; % 5 graus em rad
in_init=[1,1,1,1];
fim_init=[2,2,2,2];
for i=1:4
    valor_inicial(i)=mean(ensaio(in_init:fim_init,i));
end

theta_inf=theta_inf-valor_inicial;
erro=ref*ones(1,4)-valor_inicial;

A=erro;

K = theta_inf./A;

T=ensaio_size*Ts;

for i=1:4
    subplot(4,1,i);
    H = tf(K(i)*(wn(i)^2),[1, 2*xi(i)*wn(i), wn(i)^2]);
    [y,t]=step(H,T);
    y=y.*A(i)+valor_inicial(i);
    plot(t,y,'b');
    title('')
    legend('Res. Exp','Res. Ident.')
end


%K deveria ser 1 mas tem nao linearidades
%%Calculo dos parametros
% 1/J1 b 1/J2  
%A=[2*Kp*l1 0 0; 0 1 0; 0 0 1];
%B=[wn.^2;2.*qsi.*wn;K.*wn.^2];


%valor do ganho no ensaio
Kp=4;
%Kp=[17.8,8,10.5,6.8];

den3= 2*Kp*l_2./(K.*wn.^2)
fs2=1./(2.*xi.*wn.*den3)
den3optional=(2*Kp*l_2)./wn.^2
Out=[K' xi' wn']
out=mean(Out)
par_finais=[den3; fs2];
par_exp=[den3;den3optional]
par_teoricos=par_teoricos.*ones(2,1)
for i=1:4
    erro_texp(:,i)=(par_exp(:,i)-par_teoricos)./par_exp(:,i); %em porcentagem
end

erro_texp
