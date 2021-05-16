clear all
close all
clc
load('PPMAlfa.mat'); %Carrega dados
ppmAlfa=polyfit(dados(:,1),dados(:,2),1)

theta_servo=[];
alpha=[];

s = 21.5e-3;
w = 28.5e-3;
u = 20.0e-3;
v = 13.5e-3; %1.35e-2;%1.6e-2;
t = sqrt(u^2+v^2);
y = 17.90e-3;%1.790e-2;
x = 40.04e-3;%4.20e-2;%4.504e-2;

% s = 1.59e-2;%1.59e-2;
% w = 3.844e-2;%3.844e-2;
% u = 1.8e-2;
% v = 1.3e-2;
% t = sqrt(u^2+v^2);
% y = 1.9e-2;%1.790e-2;
% x = 4.504e-2;%4.504e-2;

param1=[s w u v t y x]*1000;

% Definição dos Angulos Limites do Servo Motor [theta_min,theta_max] (Atuador do mecanismo Tilt)
theta_max= pi; % em radianos pi[rad] = 180 [degrees]
theta_min= 0;  % em radianos
 
 for theta = theta_min:0.005: theta_max;
      alpha_sup = sim4bar1(param1,theta);
      theta_servo = [theta_servo theta];
 
     alpha=[alpha alpha_sup];
 end
 
 
figure
plot(rad2deg(theta_servo),rad2deg(alpha));
title("\theta_{servo}x\alpha");
xlabel("$\theta_{servo} [^\circ]$",'Interpreter','latex');
ylabel("$\alpha [^\circ]$",'Interpreter','latex');
axis([0 180 -5 100])
grid on
hold on

clear legend
legend('Simulação','Dados experimentais','Curva Ajustada','Interpreter','latex')



global Ts;
global numValues;
Ts=1.5;
numValues=1;

%txtfile= dlmread('primeiros.txt');
txtfile= dlmread('Dados2.txt');
data = iddata([txtfile(:,3) polyval(ppmAlfa,txtfile(:,3))],[txtfile(:,1) txtfile(:,5) txtfile(:,4)],Ts,'ExperimentName','Identificacao do tilt');
data.OutputName = {'ADC','Alfa'};
data.OutputUnit = {'0-1023','degrees'};
data.InputName = {'Time','ThetaServo','PPM'};
data.InputUnit = {'seconds','degrees','milliseconds'};

plot(data.u(:,2),data.y(:,2),'r*')