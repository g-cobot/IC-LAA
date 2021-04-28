 clear all
 close all
 clc
 
%%Simulação do Modelo Dinamico de 4 Barras
%Inicialização das variaveis
theta_servo=[];
theta_tilt=[];
%Definição das dimensoes de cada barra do mecanismo
%Tilt motor 1 M1 valores em metros 
 
 s1 = 2.0e-2;%1.6e-2;
 w1 = 3.8e-2;
 u1 = 1.914e-2;%1.8e-2;
 v1 = 1.304e-2;%1.25e-2;
 t1 = sqrt(u1^2+v1^2);
 y1 = 1.773e-2;%1.95e-2;
 %st1 = sqrt(w1^2+t1^2);
 x1 = 4.535e-2;  %sqrt(st1^2-s1^2);
 param=[s1 w1 u1 v1 t1 y1 x1]*1000;
 
 % Definição dos Angulos Limites do Servo Motor [theta_min,theta_max] (Atuador do mecanismo Tilt)
 theta_max=2.0944;% pi/4; % em radianos pi[rad] = 180 [degrees]
 theta_min=1.221730476396031;%0;  % em radianos
 max_I=1;      %Numero de repetiçoes da simulação

 for I=0 : 1 : max_I;
     if (rem(I,2)==0)
         for theta = theta_min:0.005: theta_max;
              th_tilt = plot4bar1(param, theta,I,theta_max,max_I); %%Plota a
              % simulacao do mecanismo de quatro barras
              th_tilt = sim4bar1(param,theta);
              theta_servo = [theta_servo theta];
              theta_tilt=[theta_tilt th_tilt];
              prt_map(theta_servo,theta_tilt); %%Plot o ponto
              %correspondente da simulacao no grafico abaixo
         end
     end
 end

 
  
 %%Figura da relação entre o Angulo ThetaServo e o Angulo Tilt
figure
plot([0:size(theta_servo,2)-1],rad2deg(theta_servo));
xlabel('Tempo [s]')
ylabel('\theta_{servo} [\circ]')
grid on

figure
plot([0:size(theta_tilt,2)-1],rad2deg(theta_tilt));
xlabel('Tempo [s]')
ylabel('\theta_{tilt} [\circ]')
grid on

figure
plot(rad2deg(theta_servo),rad2deg(theta_tilt));
xlabel('\theta_{servo} [\circ]')
ylabel('\theta_{tilt} [\circ]')
grid on