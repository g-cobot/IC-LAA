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
rpm_2_rads=((2*pi)/60);
Kg_2_N=(9.81);
Ts=0.025;
ref=[35 14]; % 35 e 14 graus 

ini=[800 800 201 740 805 805]-10;
tam=130;
fim=ini+tam;
offset=[2.17 86.30];
filename1=['dado2_35porcento.txt'; 'dado2_14porcento.txt'];
filename2=['ensaio_din_tilt2_01.txt';'ensaio_din_tilt2_02.txt';'ensaio_din_tilt2_03.txt'];

i=1;
txtfile = dlmread('dado2_35porcento.txt');
name=strcat('Ensaio dinamico ',int2str(i));
data = iddata(txtfile(ini(i):fim(i),4)-offset(1),txtfile(ini(i):fim(i),2),Ts,'ExperimentName',name);
data.y=movmean(data.y,5)
data.OutputName = {'Angle'};
data.OutputUnit = {'deg'};
data.InputName = {'PPM'};
data.InputUnit = {'ms'};
data1=data;

i=i+1;

txtfile = dlmread('dado2_14porcento.txt');
name=strcat('Ensaio dinamico ',int2str(i));
data = iddata(txtfile(ini(i):fim(i),4)-offset(1),txtfile(ini(i):fim(i),2),Ts,'ExperimentName',name);
data.y=movmean(data.y,5)
data.OutputName = {'Angle'};
data.OutputUnit = {'deg'};
data.InputName = {'PPM'};
data.InputUnit = {'ms'};
data2=data;

i=i+1;

txtfile = dlmread('dado2_14porcento.txt');
name=strcat('Ensaio dinamico ',int2str(i));
data = iddata(txtfile(ini(i):fim(i),4)-offset(1),txtfile(ini(i):fim(i),2),Ts,'ExperimentName',name);
data.y=movmean(data.y,5)
data.OutputName = {'Angle'};
data.OutputUnit = {'deg'};
data.InputName = {'PPM'};
data.InputUnit = {'ms'};
data3=data;

i=i+1;

txtfile = dlmread('ensaio_din_tilt2_01.txt');
name=strcat('Ensaio dinamico ',int2str(i));
data = iddata(txtfile(ini(i):fim(i),4)-offset(2),txtfile(ini(i):fim(i),2),Ts,'ExperimentName',name);
data.y=movmean(data.y,10)
data.OutputName = {'Angle'};
data.OutputUnit = {'deg'};
data.InputName = {'PPM'};
data.InputUnit = {'ms'};
data4=data;

i=i+1;

txtfile = dlmread('ensaio_din_tilt2_02.txt');
name=strcat('Ensaio dinamico ',int2str(i));
data = iddata(txtfile(ini(i):fim(i),4)-offset(2),txtfile(ini(i):fim(i),2),Ts,'ExperimentName',name);
data.y=movmean(data.y,10)
data.OutputName = {'Angle'};
data.OutputUnit = {'deg'};
data.InputName = {'PPM'};
data.InputUnit = {'ms'};
data5=data;

i=i+1;

txtfile = dlmread('ensaio_din_tilt2_03.txt');
name=strcat('Ensaio dinamico ',int2str(i));
data = iddata(txtfile(ini(i):fim(i),4)-offset(2),txtfile(ini(i):fim(i),2),Ts,'ExperimentName',name);
data.y=movmean(data.y,10)
data.OutputName = {'Angle'};
data.OutputUnit = {'deg'};
data.InputName = {'PPM'};
data.InputUnit = {'ms'};
data6=data;

save('AlfaDin1.mat','data1');
save('AlfaDin2.mat','data2');
save('AlfaDin3.mat','data3');
save('AlfaDin4.mat','data4');
save('AlfaDin5.mat','data5');
save('AlfaDin5.mat','data6');

figure
plot(data1.y)
hold on
plot(data2.y)
plot(data3.y)
plot(data4.y)
plot(data5.y)
plot(data6.y)
ylabel('$\alpha[deg]$','interpreter','latex');
xlabel('$N amostra$','interpreter','latex');

figure
plot(data1.u)
hold on
plot(data2.u)
plot(data3.u)
plot(data4.u)
plot(data5.u)
plot(data6.u)
ylabel('$PPM[ms]$','interpreter','latex');
xlabel('$N amostra$','interpreter','latex');

% 
% 
% for i=1:size(filename1,2)
%     txtfile = dlmread(filename1(i,:));
%     name=strcat('Ensaio dinamico ',int2str(i));
%     data = iddata(txtfile(ini:fim,4),txtfile(ini:fim,3),Ts,'ExperimentName',name);
%     data.OutputName = {'Angle'};
%     data.OutputUnit = {'deg'};
%     data.InputName = {'PPM'};
%     data.InputUnit = {'ms'};
%     iddataarray = [iddataarray; data];
% end
% for i=1:size(filename2,2)
%     txtfile = dlmread(filename2(i,:));
%     data = iddata(txtfile(ini:fim,4)-offset,txtfile(ini:fim,2),Ts,'ExperimentName','COMPORTAMENTO Do TILT');
%     data.OutputName = {'Angle'};
%     data.OutputUnit = {'degrees'};
%     data.InputName = {'PPM'};
%     data.InputUnit = {'ms'};
%     data(i+size(filename1,2)) = data;
% end
% 
% for i=1:size(filename3,2)
%     txtfile = dlmread(filename3(i,:));
%     data = iddata(txtfile(ini:fim,4),txtfile(ini:fim,3),Ts,'ExperimentName','COMPORTAMENTO Do TILT');
%     data.OutputName = {'Angle'};
%     data.OutputUnit = {'degrees'};
%     data.InputName = {'PPM'};
%     data.InputUnit = {'ms'};
%     data(i+(size(filename1,2)+size(filename2,2))) = data;
% end
% 
% figure
% hold on
% for i=1:(size(filename1,2)+size(filename2,2)+size(filename3,2))
%     plot(data(i).y)
% end


% save('alfaDin1.mat','data1_35')
% save('alfaDin2.mat','data2_35')
% save('alfaDin3.mat','data2_14')

% txtfile = dlmread('tilt114porcento.txt');
% data1_14 = iddata(txtfile(:,4),txtfile(:,1),Ts,'ExperimentName','COMPORTAMENTO Do TILT');
% data1_14.OutputName = {'Angle'};
% data1_14.OutputUnit = {'degrees'};
% data1_14.InputName = {'Time'};
% data1_14.InputUnit = {'seconds'};
% 
% save('data1_14.mat','data1_14')



% figure
% plot(data1.u,movmean(data1.y,20))
% hold on
% plot(data1_14.u,movmean(data1_14.y,15))

