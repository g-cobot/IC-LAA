%com mecanismo de vetorização
clear all 
close all
clc
%Tamanho da fonte
fs=27.25;

Ts=0.02;
deg2rad=pi/180;

ref=[0.98*-22*deg2rad;...
    -0.0065 ;...
    0];

txtfile = dlmread('ensaio1.txt');
data = iddata(txtfile(:,1:6),txtfile(:,7:10),Ts,'ExperimentName','Ensaio Controle LQRi 124 com tilt');
data.OutputName = {'Theta1','Theta2','Theta4','Theta1_dot','Theta2_dot','Theta4_dot'};
data.OutputUnit = {'rad','rad','rad','rad/s','rad/s','rad/s',};
data.InputName = {'F1','F2','alpha1','alpha2'};
data.InputUnit = {'N','N','rad','rad'};

ref1=[zeros(699,1);deg2rad*-20*ones(801,1)];
ref2=[zeros(1500,1)]
ref4=[zeros(1500,1)]

figure

subplot(3,2,1);

plot([1:size(data.y,1)]*Ts,data.y(:,1)-[zeros(806,1);(-0.0169/2)*ones(20,1);-0.0169*ones(674,1)],'b');
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
ylabel('$F_1 [N]$ ','Interpreter','latex');
grid on


hold on
%plot((0:size(data.u,1)-1),ones(size(data.u,1))*2.9,'k--');
%plot((0:size(data.u,1)-1),ones(size(data.u,1))*1.3,'k--');
%legend('F_1','sat. inf','sat. sup')


subplot(2,2,2);

plot([1:size(data.u,1)]*Ts,data.u(:,2),'k');
xticks([0:250:1500]*Ts)
ylabel('$F_2 [N]$ ','Interpreter','latex');
grid on

hold on
%plot((0:size(data.u,1)-1),ones(size(data.u,1))*2.9,'k--');
%plot((0:size(data.u,1)-1),ones(size(data.u,1))*1.3,'k--');
%legend('F_2','sat. inf','sat. sup')


subplot(2,2,3);
alfa1=zeros(size(data.u(:,3),1),1);
for i=1:size(data.u(:,3),1)
    if(data.u(i,3)<0)   
        alfa1(i)=0;
    else
        alfa1(i)=data.u(i,3);
    end
end
plot([0:size(data.u,1)-1]*Ts,alfa1,'k');
xticks([0:250:1500]*Ts)
xlabel('Tempo [s]');
ylabel('$\alpha_1 [rad]$ ','Interpreter','latex');
grid on

hold on
%plot((0:size(data.u,1)-1),ones(size(data.u,1))*35*deg2rad,'k--');
%plot((0:size(data.u,1)-1),ones(size(data.u,1))*0*deg2rad,'k--');
%legend('alpha_1','sat. inf','sat. sup')

subplot(2,2,4);
alfa2=zeros(size(data.u(:,4),1),1);
for i=1:size(data.u(:,4),1)
    if(data.u(i,4)<0)   
        alfa2(i)=0;
    else
        alfa2(i)=data.u(i,4);
    end
end

plot([0:size(data.u,1)-1]*Ts,alfa2,'k');
xticks([0:250:1500]*Ts)
xlabel('Tempo [s]');
ylabel('$\alpha_2 [rad]$ ','Interpreter','latex');
grid on

hold on
%plot((0:size(data.u,1)-1),ones(size(data.u,1))*35*deg2rad,'k--');
%plot((0:size(data.u,1)-1),ones(size(data.u,1))*0*deg2rad,'k--');
%legend('alpha_2','sat. inf','sat. sup')
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
mean(data.u(:,2)) 2*std(data.u(:,2));...
mean(alfa1) 2*std(alfa1);...
mean(alfa2) 2*std(alfa2)]

Mp=[( min(data.y(:,1))-(-20*deg2rad) )/(-20*deg2rad)*100;...
    (max(data.y(:,2))-deg2rad*18.7)/(deg2rad*18.7);...
    max(data.y(:,3))]
