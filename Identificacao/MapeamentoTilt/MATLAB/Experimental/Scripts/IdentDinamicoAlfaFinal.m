% Universidade Federal de Uberlândia
%   Faculdade de Engenharia Mecânica
%    Curso de Engenharia Mecatrônica 
%   
%   Criando IDdata a partir dos resultados experimentais
%   
%   Aluno: Gabriel Costa e Silva
% =================================

close all
clear all
clc
% Constantes
Kg_2_N=(9.81);
rad2deg=180/pi;
deg2rad=pi/180;
Ts=0.025;
% PPM para angulo referencia
%ppm=[1650  1800]
%ref=[33 14]; em graus

ppm2ref=polyfit([1650 2350],[33*deg2rad 0],1);

ini=[800 800 201 740 805 805]-10;
tam=130;
fim=ini+tam;
offset=[2.17 86.30];
filename1=['dado2_35porcento.txt'; 'dado2_14porcento.txt'];
filename2=['ensaio_din_tilt2_01.txt';'ensaio_din_tilt2_02.txt';'ensaio_din_tilt2_03.txt'];

i=1;
txtfile = dlmread('dado2_35porcento.txt');
name=strcat('Ensaio dinamico ',int2str(i));
data = iddata(deg2rad*(txtfile(ini(i):fim(i),4)-offset(1)),polyval(ppm2ref,txtfile(ini(i):fim(i),2)),Ts,'ExperimentName',name);
data.y=movmean(data.y,5)
data.OutputName = {'Angle'};
data.OutputUnit = {'deg'};
data.InputName = {'Alfaref'};
data.InputUnit = {'rad'};
data1=data;

i=i+1;

txtfile = dlmread('dado2_14porcento.txt');
name=strcat('Ensaio dinamico ',int2str(i));
data = iddata(deg2rad*(txtfile(ini(i):fim(i),4)-offset(1)),polyval(ppm2ref,txtfile(ini(i):fim(i),2)),Ts,'ExperimentName',name);
data.y=movmean(data.y,5)
data.OutputName = {'Angle'};
data.OutputUnit = {'rad'};
data.InputName = {'Alfaref'};
data.InputUnit = {'rad'};
data2=data;

i=i+1;

txtfile = dlmread('dado2_14porcento.txt');
name=strcat('Ensaio dinamico ',int2str(i));
data = iddata(deg2rad*(txtfile(ini(i):fim(i),4)-offset(1)),polyval(ppm2ref,txtfile(ini(i):fim(i),2)),Ts,'ExperimentName',name);
data.y=movmean(data.y,5)
data.OutputName = {'Angle'};
data.OutputUnit = {'rad'};
data.InputName = {'Alfaref'};
data.InputUnit = {'rad'};
data3=data;

i=i+1;

txtfile = dlmread('ensaio_din_tilt2_01.txt');
name=strcat('Ensaio dinamico ',int2str(i));
data = iddata(deg2rad*(txtfile(ini(i):fim(i),4)-offset(2)),polyval(ppm2ref,txtfile(ini(i):fim(i),2)),Ts,'ExperimentName',name);
data.y=movmean(data.y,10)
data.OutputName = {'Angle'};
data.OutputUnit = {'deg'};
data.InputName = {'Alfaref'};
data.InputUnit = {'rad'};
data4=data;

i=i+1;

txtfile = dlmread('ensaio_din_tilt2_02.txt');
name=strcat('Ensaio dinamico ',int2str(i));
data = iddata(deg2rad*(txtfile(ini(i):fim(i),4)-offset(2)),polyval(ppm2ref,txtfile(ini(i):fim(i),2)),Ts,'ExperimentName',name);
data.y=movmean(data.y,10)
data.OutputName = {'Angle'};
data.OutputUnit = {'rad'};
data.InputName = {'Alfaref'};
data.InputUnit = {'rad'};
data5=data;

i=i+1;

txtfile = dlmread('ensaio_din_tilt2_03.txt');
name=strcat('Ensaio dinamico ',int2str(i));
data = iddata(deg2rad*(txtfile(ini(i):fim(i),4)-offset(2)),polyval(ppm2ref,txtfile(ini(i):fim(i),2)),Ts,'ExperimentName',name);
data.y=movmean(data.y,10)
data.OutputName = {'Angle'};
data.OutputUnit = {'rad'};
data.InputName = {'Alfaref'};
data.InputUnit = {'rad'};
data6=data;

save('AlfaDin1.mat','data1');
save('AlfaDin2.mat','data2');
% save('AlfaDin3.mat','data3');
%save('AlfaDin4.mat','data4');
%save('AlfaDin5.mat','data5');
% save('AlfaDin5.mat','data6');

figure
plot(data1.y)
hold on
plot(data2.y)
%plot(data3.y)
%plot(data4.y)
%plot(data5.y)
%plot(data6.y)
ylabel('$\alpha[deg]$','interpreter','latex');
xlabel('$N amostra$','interpreter','latex');

figure
plot(data1.u)
hold on
plot(data2.u)
%plot(data3.u)
%plot(data4.u)
%plot(data5.u)
%plot(data6.u)
ylabel('$Alfaref[rad]$','interpreter','latex');
xlabel('$N amostra$','interpreter','latex');
