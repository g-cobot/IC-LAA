% Universidade Federal de Uberlândia
% Faculdade de Engenharia Mecânica
% Curso de Engenharia Mecatrônica 
%   
% Realizado a identificação dinâmica dos motores
%   
%   Aluno: Gabriel Costa e Silva
% =================================

% Carregando dados salvos
% M1_E1 = importdata('M1_E1.data'); 
% M1_E2 = importdata('M1_E2.data'); 
% M1_E3 = importdata('M1_E3.data'); 
% 
% M2_E1 = importdata('M2_E1.data'); 
% M2_E2 = importdata('M2_E2.data'); 
% M2_E3 = importdata('M2_E3.data');

M1= importdata('M1_means.mat');
M2 = importdata('M2_means.mat');
Ts=0.012;
inicio=14;
fim=1096;

OutputM1_new=M1.OutputData(inicio:fim)+2.1582;
InputM1_new=M1.InputData(inicio:fim)+1500-6.8811;
M1_Final=iddata(OutputM1_new,InputM1_new,Ts,'ExperimentName','Força por PPM');
M1_Final.OutputName = {'Force'};
M1_Final.OutputUnit = {'Newtons'};
M1_Final.InputName = {'PPM'};
M1_Final.InputUnit = {'milliseconds'};
save('M1_Final.mat','M1_Final');

OutputM2_new=M2.OutputData(inicio:fim)+2.042;
InputM2_new=M2.InputData(inicio:fim)+(1500-3.6496);
M2_Final=iddata(OutputM2_new,InputM2_new,Ts,'ExperimentName','Força por PPM');
M2_Final.OutputName = {'Force'};
M2_Final.OutputUnit = {'Newtons'};
M2_Final.InputName = {'PPM'};
M2_Final.InputUnit = {'milliseconds'};
save('M2_Final.mat','M2_Final');
%pidTuner
%systemIdentification