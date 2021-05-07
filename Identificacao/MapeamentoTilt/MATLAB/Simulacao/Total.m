clear all
close all
clc


%%Simula��o do Modelo Dinamico de 4 Barras
%Inicializa��o das variaveis
theta_servo=[];
theta_tilt=[];
 
%Defini��o das dimensoes de cada barra do mecanismo
%Tilt motor 1 M1 valores em metros 
s1 = 1.6e-2;
w1 = 3.8e-2;
u1 = 1.8e-2;
v1 = 1.25e-2;
t1 = sqrt(u1^2+v1^2);
y1 = 1.95e-2;
x1 = 4.535e-2;

s2 = 1.6e-2;
w2 = 3.75e-2;
u2 = 1.8e-2;
v2 = 1.25e-2;
t2 = sqrt(u2^2+v2^2);
y2 = 1.95e-2;
x2 = 4.535e-2;
param2=[s2 w2 u2 v2 t2 y2 x2]*1000;

% s1 = 2.0e-2;%1.6e-2;
% w1 = 3.8e-2;
% u1 = 1.8e-2;
% v1 = 1.25e-2;
% t1 = sqrt(u1^2+v1^2);
% y1 = 1.773e-2;%1.95e-2;
% st1 = sqrt(w1^2+t1^2);
% x1 = sqrt(st1^2-s1^2);
param1=[s1 w1 u1 v1 t1 y1 x1]*1000;
% Defini��o dos Angulos Limites do Servo Motor [theta_min,theta_max] (Atuador do mecanismo Tilt)
theta_max= pi; % em radianos pi[rad] = 180 [degrees]
theta_min= 0;  % em radianos
 
 for theta = theta_min:0.005: theta_max;
      th_tilt = sim4bar1(param1,theta);
      theta_servo = [theta_servo theta];
      theta_tilt=[theta_tilt th_tilt];
 end

%%Figura da rela��o entre o Angulo ThetaServo e o Angulo Tilt
%Resultado Theta_tilt = -0.8649*Theta_servo-131.7590;
 
pro=[34.08 30.6 26.23 23.17 19.86 16.83 9.764 7.3332 4.623 2.37 -0.1985 -1.53]
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

%tservo2=[92.3454 97.2155 102.9451 107.2423 111.5394 115.8366 125.6571 129.1178 133.0741 136.4115 140.3191 142.3904 145.1807 146.636];
tservo2=[109.7214 114.3051 120.0347 124.6183 129.202 134.0721 145.8178 150.4014 156.131 161.5741 169.882 178.1899];
ppm=[1650:50:1900,2000:50:2250];

coefs=polyfit(tservo2,ppm,2);

abc1=polyfit(ppm,tservo2,1);
abc2=polyfit(ppm,tservo2,2);

%servo=[0,92,98,116,125,148];
%ppmin=[650,1520,1650,1700,1900,2000];
%servo=[0,5,10.5,15.5,20.7,...
%    26,31,36.5,42,46.5,...
%    51,58,63.5,69,74.5,...
%    80,85.5,91,97,102.5,...
%    108,113.5,119.5,125,131,...
%    136.5,142.5,148,154,160,...
%    166,170,175];
servo=[0,5,11,16,21,...
    26,31,37,43,47,...
    51,58,63.5,69,75,...
    80,85,91,97,102.5,...
    110,113.5,120,124,130,...
    135.5,140,144.5,150,156,...
    162,170,177];
ppmin=[650:50:2250];
%,1520,1650,1700,1900,2000,2250];
coefs2=polyfit(servo,ppmin,2);
abc3=polyfit(ppmin,servo,2);

 for i=1:size(theta_servo,2)
    y(i)=polyval(coefs2,rad2deg(theta_servo(i)));
 end

figure
plot(ppm,tservo2,'r*');
hold on
plot(ppmin, servo,'b*');
%plot(ppm,polyval(abc1,ppm));
%plot(ppm,polyval(abc2,ppm));
plot(ppmin,polyval(abc3,ppmin));
legend={'Simulado','Experimental'}
 
i=1
Xini=[1600]*1000;
Xfim=[2350]*1000;
ndivx=[7]
figure
figura=gcf
plot(y*1000,rad2deg(theta_tilt));
xlabel('PPM [ms]')
axis([Xini(i) Xfim(i) -10 60])
figura.Children.XTick= linspace(Xini(i), Xfim(i),ndivx(i))
ylabel('\theta_{tilt} [\circ]')
grid on

figure
plot(y*1000,rad2deg(theta_tilt));
hold on
%====================
offset=  85.5; % Para qual valor de angulo de thetapot temos o angulo
%zero do tilt 2

load('dado_1_tilt2.mat');
load('dado_2_tilt2.mat');
load('dado_3_tilt2.mat');

dado_final=[dado1(:,1:13); dado2(:,1:13); dado3(:,1:13)];
dado_final=dado_final-offset*ones(size(dado_final));
f=[dado_final(:,1);dado_final(:,2);dado_final(:,3);dado_final(:,4);dado_final(:,5);dado_final(:,6);dado_final(:,7);dado_final(:,8);dado_final(:,9);dado_final(:,10);dado_final(:,11);dado_final(:,12);dado_final(:,13)];
pwm = [1650*ones(size(dado_final,1),1);1700*ones( size(dado_final,1),1);1750*ones( size(dado_final,1),1);1800*ones( size(dado_final,1),1);1850*ones( size(dado_final,1),1);1900*ones( size(dado_final,1),1);1950*ones( size(dado_final,1),1);2000*ones( size(dado_final,1),1);2050*ones( size(dado_final,1),1);2100*ones( size(dado_final,1),1);2150*ones( size(dado_final,1),1);2200*ones( size(dado_final,1),1);2250*ones( size(dado_final,1),1)];
plot([1650:50:2250]*1000,mean(dado_final),'*')
title("Mapeamento Estatico do Tilt 2");
xlabel("$PPM [ms]$",'Interpreter','latex');
ylabel("$\alpha [^\circ]$",'Interpreter','latex');


%%Regressao Linear sobre os dados
format long
[coefs S] = polyfit(pwm*1000,f,2);
rquadrado=(S.normr/norm(f - mean(f)))^2;
%coefs=round(coefs,6);
pwm1=linspace(1650,2250,1000)*1000;
plot(pwm1,polyval(coefs,pwm1));
grid on
%leg1=legend('Resultado experimental','Curva Ajustada')
%set(leg1,'Interpreter','latex')


% 
% filename="DadosAjustados2.fig";
% openfig(filename);
% figura=gcf;
%hold on
%plot(y*1000,rad2deg(theta_tilt));