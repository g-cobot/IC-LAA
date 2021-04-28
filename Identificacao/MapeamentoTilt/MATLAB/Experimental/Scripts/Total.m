clear all
close all
clc
 
%%Simulação do Modelo Dinamico de 4 Barras
 %Inicialização das variaveis
 theta_servo=[];
 theta_tilt=[];
 %Definição das dimensoes de cada barra do mecanismo
 %Tilt motor 1 M1 valores em metros 
 
 s1 = 2.0e-2;%1.6e-2;
 w1 = 3.8e-2;
 u1 = 1.8e-2;
 v1 = 1.25e-2;
 t1 = sqrt(u1^2+v1^2);
 y1 = 1.773e-2;%1.95e-2;
 st1 = sqrt(w1^2+t1^2);
 x1 = sqrt(st1^2-s1^2);
 
%  s1 = 1.6e-2;
%  w1 = 3.8e-2;
%  u1 = 1.8e-2;
%  v1 = 1.25e-2;
%  t1 = sqrt(u1^2+v1^2);
%  y1 = 1.95e-2;
%  st1 = sqrt(w1^2+t1^2);
%  x1 = sqrt(st1^2-s1^2);
 param=[s1 w1 u1 v1 t1 y1 x1]*1000;
 %Tilt motor 2 M2
 s2 = 1.6e-2;
 w2 = 3.75e-2;
 u2 = 1.8e-2;
 v2 = 1.25e-2;
 t2 = sqrt(u2^2+v2^2);
 y2 = 1.95e-2;
 st2 = sqrt(w2^2+t2^2);
 x2 = sqrt(st2^2-s2^2);
 
 param2=[s2 w2 u2 v2 t2 y2 x2]*1000;
 
 % Definição dos Angulos Limites do Servo Motor [theta_min,theta_max] (Atuador do mecanismo Tilt)
 
 theta_max=pi;% pi/4; % em radianos pi[rad] = 180 [degrees]
 theta_min=1.221730476396031;%0;  % em radianos
 %theta_max= pi/2; % em radianos pi[rad] = 180 [degrees]
 %theta_min= 0.366519142918809;  % em radianos
 
 for theta = theta_min:0.00005: theta_max;
      th_tilt = sim4bar(param2,theta);
      theta_servo = [theta_servo theta];
      theta_tilt=[theta_tilt th_tilt];
 end
  
 %%Figura da relação entre o Angulo ThetaServo e o Angulo Tilt
 %Resultado Theta_tilt = -0.8649*Theta_servo-131.7590;
 
pro=[34.08 30.6 26.23 23.17 19.86 16.83 9.764 7.3332 4.623 2.37 -0.1985 -1.53 -3.2598 -4.133]
ppm=[1650:50:1900,2000:50:2350]
 figure
 hold on
 for i=1:size(pro,2)
    plot(0:180-1,ones(180)*(pro(i)),'r')
 end
 plot(rad2deg(theta_servo),rad2deg(theta_tilt));
 xlabel('\theta_{servo} [\circ]')
 ylabel('\theta_{tilt} [\circ]')
 grid on
%tservo2=[67.3225 73.3386 80.2141 84.7978 89.6679 93.9651 103.9918 107.4296 111.1538 114.0186 117.4563 119.4619 121.7535 122.8994]
tservo2=[92.3454 97.2155 102.9451 107.2423 111.5394 115.8366 125.6571 129.1178 133.0741 136.4115 140.3191 142.3904 145.1807 146.636]

PPM2deg=90/1500;
%deg2PPM=2350/123.18;
deg2PPM=2350/146.636;
% tservo=[67.8955 74.4845 99.9811 111.1538 123.18]
coefs=polyfit(tservo2,ppm,1)
 

 for i=1:size(theta_servo,2)
    y(i)=polyval(coefs,rad2deg(theta_servo(i)));
 end
 
 
%  i=1
%  Xini=[1600]
%  Xfim=[2350]
%  ndivx=[7]
%  figure
%  figura=gcf
%  plot(y,rad2deg(theta_tilt));
%  xlabel('PPM [ms]')
%  axis([Xini(i) Xfim(i) -10 40])
%  figura.Children.XTick= linspace(Xini(i), Xfim(i),ndivx(i))
%  ylabel('\theta_{tilt} [\circ]')
%  grid on

global Ts; 
global numValues;
global numPWM;

Ts = 0.01;
numValues=250;
numPWM=15;

filename1='ensaiotilt2_01.txt';
filename2='ensaiotilt2_02.txt';
filename3='ensaiotilt2_03.txt';

dado1 = readDataTilt(filename1);
dado2 = readDataTilt(filename2);
dado3 = readDataTilt(filename3);

dado_final=[dado1; dado2; dado3];

offset=  84.67; % Para qual valor de angulo de thetapot temos o angulo zero do tilt
dado_final=dado_final-offset*ones(size(dado_final));
f=[dado_final(:,1);dado_final(:,2);dado_final(:,3);dado_final(:,4);dado_final(:,5);dado_final(:,6);dado_final(:,7);dado_final(:,8);dado_final(:,9);dado_final(:,10);dado_final(:,11);dado_final(:,12);dado_final(:,13);dado_final(:,14);dado_final(:,15)];
pwm = [1650000*ones(size(dado_final,1),1);1700000*ones( size(dado_final,1),1);1750000*ones( size(dado_final,1),1);1800000*ones( size(dado_final,1),1);1850000*ones( size(dado_final,1),1);1900000*ones( size(dado_final,1),1);1950000*ones( size(dado_final,1),1);2000000*ones( size(dado_final,1),1);2050000*ones( size(dado_final,1),1);2100000*ones( size(dado_final,1),1);2150000*ones( size(dado_final,1),1);2200000*ones( size(dado_final,1),1);2250000*ones( size(dado_final,1),1);2300000*ones( size(dado_final,1),1);2350000*ones( size(dado_final,1),1)];


% %%%%% Figuras Importantes
% 
% figure
% 
% errorbar([1650000:50000:2350000],mean(dado_final),std(dado_final),'*')
% title("Mapeamento Estatico do Tilt2");
% xlabel("$PWM [nseconds]$",'Interpreter','latex');
% ylabel("$\alpha_2 [graus]$",'Interpreter','latex');
% hold on
% 
% %%Regressï¿½o Linear sobre os dados
% format long
% [coefs S] = polyfit(pwm,f,2);
% rquadrado=(S.normr/norm(f - mean(f)))^2;
% %coefs=round(coefs,6);
% pwm1=linspace(1650000,2350000,1000);
% plot(pwm1,polyval(coefs,pwm1));
% leg1=legend('Dados experimentais','Curva Ajustada - \alpha_2[PWM]=0.0000000000396*PWMÂ²-0.000214638*PWM+280.823582')
% set(leg1,'Interpreter','latex')
% grid on

i=1
Xini=[1600]
Xfim=[2350]
ndivx=[7]
figure
figura=gcf
errorbar([1650000:50000:2350000],mean(dado_final),std(dado_final),'*')
title("Mapeamento Estatico do Tilt2");
xlabel("$PWM [nseconds]$",'Interpreter','latex');
ylabel("$\alpha_2 [graus]$",'Interpreter','latex');
hold on

%%Regressï¿½o Linear sobre os dados
format long
[coefs S] = polyfit(pwm,f,2);
rquadrado=(S.normr/norm(f - mean(f)))^2;
%coefs=round(coefs,6);
pwm1=linspace(1650000,2350000,1000);
plot(pwm1,polyval(coefs,pwm1));
grid on
hold on
plot(y*1000,rad2deg(theta_tilt));

axis([Xini(i)*1000 Xfim(i)*1000 -10 40])
figura.Children.XTick= linspace(Xini(i)*1000, Xfim(i)*1000,ndivx(i))
legend('Experimetal','Aproximado','Simulado')