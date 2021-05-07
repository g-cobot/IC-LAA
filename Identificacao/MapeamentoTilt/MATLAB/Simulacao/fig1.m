clear all
close all
clc
 
theta_servo=[];
theta_tilt=[];

s1 = 2.0e-2;%1.6e-2;
w1 = 3.8e-2;
u1 = 1.766e-2;%1.8e-2;  
v1 = 1.498e-2;%1.25e-2; 
t1 = sqrt(u1^2+v1^2);
y1 = 1.773e-2;%1.95e-2;
x1 = 4.535e-2;
param=[s1 w1 u1 v1 t1 y1 x1]*1000;
theta_max=2.0944;% pi/4; % em radianos pi[rad] = 180 [degrees]
theta_min=1.221730476396031;%0;  % em radianos
max_I=1;      %Numero de repetiçoes da simulação

theta=pi/2+pi/8;

%th_tilt = sim4bar1(param,theta);
th_tilt = plot4bar1(param, theta,0,theta_max,max_I); 
theta_servo = [theta_servo theta];
theta_tilt=[theta_tilt th_tilt];


