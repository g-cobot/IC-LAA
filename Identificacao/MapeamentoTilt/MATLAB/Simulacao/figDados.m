%% Mapeamento do tilt rotor
clear all
close all

global Ts; 
global numValues;
global numPWM;

Ts = 0.01;
numValues=250;
numPWM=15;

%filename1='ensaiotilt1_01.txt';
%filename2='ensaiotilt1_02.txt';
%filename3='ensaiotilt1_03.txt';
%offset=  62.51; % Para qual valor de angulo de thetapot temos o angulo zero do tilt 1

filename1='ensaiotilt2_01.txt';
filename2='ensaiotilt2_02.txt';
filename3='ensaiotilt2_03.txt';
%offset=  84.67; % Para qual valor de angulo de thetapot temos o angulo
%zero do tilt 2
%offset=  83.00; % Para qual valor de angulo de thetapot temos o angulo
%zero do tilt 2
offset=  81.44; % Para qual valor de angulo de thetapot temos o angulo
%zero do tilt 2
load('dado_1_tilt2.mat');
load('dado_2_tilt2.mat');
load('dado_3_tilt2.mat');

% dado1 = readDataTilt(filename1);
% dado2 = readDataTilt(filename2);
% dado3 = readDataTilt(filename3);

dado_final=[dado1(:,1:13); dado2(:,1:13); dado3(:,1:13)];


dado_final=dado_final-offset*ones(size(dado_final));
f=[dado_final(:,1);dado_final(:,2);dado_final(:,3);dado_final(:,4);dado_final(:,5);dado_final(:,6);dado_final(:,7);dado_final(:,8);dado_final(:,9);dado_final(:,10);dado_final(:,11);dado_final(:,12);dado_final(:,13)];
pwm = [1650*ones(size(dado_final,1),1);1700*ones( size(dado_final,1),1);1750*ones( size(dado_final,1),1);1800*ones( size(dado_final,1),1);1850*ones( size(dado_final,1),1);1900*ones( size(dado_final,1),1);1950*ones( size(dado_final,1),1);2000*ones( size(dado_final,1),1);2050*ones( size(dado_final,1),1);2100*ones( size(dado_final,1),1);2150*ones( size(dado_final,1),1);2200*ones( size(dado_final,1),1);2250*ones( size(dado_final,1),1)];

%%%%% Figura Dados

figure

plot([1650:50:2250]*1000,mean(dado_final),'*')
title("Mapeamento Estatico do Tilt2");
xlabel("$PPM [ms]$",'Interpreter','latex');
ylabel("$\alpha [^\circ]$",'Interpreter','latex');


figure

plot([1650:50:2250]*1000,mean(dado_final),'*')
title("Mapeamento Estatico do Tilt2");
xlabel("$PPM [ms]$",'Interpreter','latex');
ylabel("$\alpha [^\circ]$",'Interpreter','latex');
hold on

%%Regressao Linear sobre os dados
format long
[coefs S] = polyfit(pwm*1000,f,2);
rquadrado=(S.normr/norm(f - mean(f)))^2;
%coefs=round(coefs,6);
pwm1=linspace(1650,2250,1000)*1000;
plot(pwm1,polyval(coefs,pwm1));

leg1=legend('Resultado experimental','Curva Ajustada')
set(leg1,'Interpreter','latex')
grid on