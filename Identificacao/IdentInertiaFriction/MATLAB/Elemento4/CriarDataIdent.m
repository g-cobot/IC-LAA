%   Universidade Federal de Uberlândia
%   Faculdade de Engenharia Mecânica
%   Identificação da Inercia e atrito I_4 e fs4  
%   Aluno: Gabriel Costa e Silva
% Criação de dados para o ident do matlab
% importe a variavel input como o input do Ident
% importe a variavel output como o output do Ident
% importe a variavel Ts como o tempo de amostragem do Ident
% o ensaio começa no tempo 0
% Ou só abra IdentTheta4 no Ident do matlab
% =================================

clear all;
close all;
clc;


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

rad2deg=180/pi;
deg2rad=pi/180;

ensaio1=importdata('ensaio01_m10.txt'); %[theta1,theta2,theta4,dottheta1,dottheta2,dottheta4,forca1,forca2]
n=10;%numero janela do filtro
ensaio_size=300;
inicio=213;
fimfiltro=inicio+ensaio_size + ceil(n/2) -1;
fim=inicio+ensaio_size-1;


A=0.1157;       % Amplitude
vi=0.066925;    % valor inicial
Ts=0.02;        % Período de amostragem   
       
Tempoensaio=0:Ts:ensaio_size*Ts;

ref=10*deg2rad; %graus

theta4filtro = ensaio1(inicio:fimfiltro,3)*-1- vi; % menos o valor inicial para ficar zerado
theta4=ensaio1(inicio:fim,3)*-1- vi; % menos o valor inicial para ficar zerado
theta4dot=ensaio1(inicio:fim,6)*-1;

input  = ref*ones(ensaio_size,1);
input2 = A*ones(ensaio_size,1);
output=zeros(ensaio_size,1);
output=theta4;
outputdot=theta4dot;

for i=65:ensaio_size
    vetorvalor=zeros(n,1);
    for j=1:n
        k=ceil(j-n/2);
        vetorvalor(j)=theta4filtro(i+k);
    end
    %output(i)=mean([theta4filtro(i-2) theta4filtro(i-1) theta4filtro(i) theta4filtro(i+1) theta4filtro(i+2)])
    output(i)=mean(vetorvalor)
end


F1 = ensaio1(inicio:fim,7);
F2 = ensaio1(inicio:fim,6);

figure
subplot(2,1,1)
plot(output,'k')
text=strcat('$\theta_4[rad]$');
ylabel(text,'fontsize',14,'interpreter','latex')
grid on
hold on
plot(theta4,'r--')
legend('com filtro','sem filtro')
subplot(2,1,2)
plot(outputdot)
dottext=strcat('$\dot{\theta_4}[rad]$');
ylabel(dottext,'fontsize',14,'interpreter','latex')
xlabel('$N amostra$','fontsize',14,'interpreter','latex')
grid on  