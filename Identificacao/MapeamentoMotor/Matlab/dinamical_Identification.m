% Universidade Federal de Uberl�ndia
%   Faculdade de Engenharia Mec�nica
%    Curso de Engenharia Mecatr�nica 
%   
%   Realizado a identifica��o din�mica dos motores
%   
%   Aluno: Gabriel Costa e Silva
% =================================

% Carregando dados salvos
M1_E1 = importdata('M1_E1.data'); 
M1_E2 = importdata('M1_E2.data'); 
M1_E3 = importdata('M1_E3.data'); 

M2_E1 = importdata('M2_E1.data'); 
M2_E2 = importdata('M2_E2.data'); 
M2_E3 = importdata('M2_E3.data');

%pidTuner
%systemIdentification