clc;
clear all;
close all;

% Forca1apro = [1.3111,1.7547,2.1983,2.6418,3.0854];
% Forca2apro = [1.2193,1.6302,2.0411,2.4519,2.8628];
Forca1 = [1.355, 1.729, 2.151, 2.638, 3.119];
Forca2 = [1.254, 1.597, 2.010, 2.473, 2.871];
Forca1apro = [1.3513,1.7353,2.1590,2.6226,3.1261];
Forca2apro = [1.2430,1.6196,2.0192,2.4418,2.8873];
PPM12 = [40,45,50,55,60];
Polo1 = 9.072;
Polo2 = 8.016;

K1 = Polo1 * Forca1apro ./ PPM12;
K2 = Polo2 * Forca2apro ./ PPM12;

coef1 = polyfit(PPM12,K1,2);
coef2 = polyfit(PPM12,K2,2);

plot(PPM12,polyval(coef1,PPM12),PPM12,K1,'x');
hold on
plot(PPM12,polyval(coef2,PPM12),PPM12,K2,'x');