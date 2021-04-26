%sem mecanismo de vetorização
clear all 
close all
clc

Ts=0.02;
deg2rad=pi/180;


%ref=[0.98*-21*deg2rad;...
%    -0.0065 ;...
%   0];

ref1=[zeros(699,1);deg2rad*-20*ones(801,1)];
ref2=[zeros(1500,1)]
ref4=[zeros(1500,1)]


%Tamanho da fonte
fs=27.25;

txtfile = dlmread('ensaio3.txt');
data = iddata(txtfile(:,1:6),txtfile(:,7:8),Ts,'ExperimentName','Ensaio Controle LQRi 124 sem tilt');
data.OutputName = {'Theta1','Theta2','Theta4','Theta1_dot','Theta2_dot','Theta4_dot'};
data.OutputUnit = {'rad','rad','rad','rad/s','rad/s','rad/s',};
data.InputName = {'F1','F2'};
data.InputUnit = {'N','N'};

figure
subplot(3,2,1);

plot([1:size(data.y,1)]*Ts,data.y(:,1),'b');
xticks([0:100:1500]*Ts)
xlabel('k');
ylabel('$\theta_1 [rad]$ ','Interpreter','latex','fontSize',fs);
grid on
hold on
plot([1:size(data.y,1)]*Ts,ref1,'r--');

subplot(3,2,3);

plot([1:size(data.y,1)]*Ts,data.y(:,2)-deg2rad*18.7,'k');
xticks([0:100:1500]*Ts)
ylabel('$\theta_2 [graus]$ ','Interpreter','latex');
grid on
hold on
plot([1:size(data.y,1)]*Ts,ref2,'r--');

subplot(3,2,5);
plot([1:size(data.y,1)]*Ts,data.y(:,3),'r');
xticks([0:100:1500]*Ts)
xlabel('Tempo [s]');
ylabel('$\theta_4 [graus]$ ','Interpreter','latex');
grid on
hold on
plot([1:size(data.y,1)]*Ts,ref4,'r--');

subplot(3,2,2);

plot([1:size(data.y,1)]*Ts,data.y(:,4),'b');
xticks([0:250:1500]*Ts)
ylabel('$\dot{\theta}_1 [graus]$ ','Interpreter','latex');
grid on

subplot(3,2,4);

plot([1:size(data.y,1)]*Ts,data.y(:,5),'k');
xticks([0:100:1500]*Ts)
ylabel('$\dot{\theta}_2 [graus]$ ','Interpreter','latex');
grid on

subplot(3,2,6);

plot([1:size(data.y,1)]*Ts,data.y(:,6),'r');
xticks([0:100:1500]*Ts)
xlabel('Tempo [s]');
ylabel('$\dot{\theta}_4 [graus]$ ','Interpreter','latex');
grid on


figure

subplot(2,2,1);

plot([1:size(data.u,1)]*Ts,data.u(:,1),'k');
xticks([0:250:1500]*Ts)
xlabel('Tempo [s]');
ylabel('$F_1 [N]$ ','Interpreter','latex');
grid on

subplot(2,2,2);

plot([1:size(data.u,1)]*Ts,data.u(:,2),'k');
xticks([0:250:1500]*Ts)
xlabel('Tempo [s]');
ylabel('$F_2 [N]$ ','Interpreter','latex');
grid on

err1=data.y(:,1)-ref1;
err2=data.y(:,2)-deg2rad*18.7-ref2;
err4=data.y(:,4)-ref4;


X=[mean(err1.*err1) 2*std(err1.*err1); ...
  mean(err2.*err2) 2*std(err2.*err2); ...
  mean(err4.*err4) 2*std(err4.*err4); ...
  mean(data.y(:,4)) 2*std(data.y(:,4)); ...
  mean(data.y(:,5)) 2*std(data.y(:,5)); ...
  mean(data.y(:,6)) 2*std(data.y(:,6))]
    


U=[mean(data.u(:,1)) 2*std(data.u(:,1));...
mean(data.u(:,2)) 2*std(data.u(:,2))]

Mp=[( min(data.y(:,1))-(-20*deg2rad) )/(-20*deg2rad)*100;...
    (max(data.y(:,2))-deg2rad*18.7)/(deg2rad*18.7);...
    max(data.y(:,3))]