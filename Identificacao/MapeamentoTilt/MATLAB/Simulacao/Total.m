clear all
close all
clc
 
%%Simulação do Modelo Dinamico de 4 Barras
 %Inicialização das variaveis
 theta_servo=[];
 theta_tilt=[];
 %Definição das dimensoes de cada barra do mecanismo
 %Tilt motor 1 M1 valores em metros 
 
 s1 = 1.6e-2;
 w1 = 3.8e-2;
 u1 = 1.8e-2;
 v1 = 1.25e-2;
 t1 = sqrt(u1^2+v1^2);
 y1 = 1.95e-2;
 st1 = sqrt(w1^2+t1^2);
 x1 = sqrt(st1^2-s1^2);
 param=[s1 w1 u1 v1 t1 y1 x1]*1000;
 %Tilt motor 2 M2
 s2 = 1.6e-2;
 w2 = 3.75e-2;
 u2 = 1.8e-2;
 v2 = 1.25e-2;
 t2 = sqrt(u2^2+v2^2);
 y2 = 1.95e-2;
 st2 = sqrt(w2^2+t2^2);
 x2 = sqrt(st2^2-s2^2);
 
 param2=[s2 w2 u2 v2 t2 y2 x2]*1000;
 
 % Definição dos Angulos Limites do Servo Motor [theta_min,theta_max] (Atuador do mecanismo Tilt)
 theta_max= pi; % em radianos pi[rad] = 180 [degrees]
 theta_min= 0;  % em radianos
 
 for theta = theta_min:0.005: theta_max;
      th_tilt = sim4bar(param,theta);
      theta_servo = [theta_servo theta];
      theta_tilt=[theta_tilt th_tilt];
 end
  
 %%Figura da relação entre o Angulo ThetaServo e o Angulo Tilt
 %Resultado Theta_tilt = -0.8649*Theta_servo-131.7590;
 
procura=[34.08 30.3623 12.91 4.836]
 
 figure
 hold on
 for i=1:size(procura,2)
    plot(0:180-1,ones(180)*(procura(i)),'r')
 end
 plot(rad2deg(theta_servo),rad2deg(theta_tilt));
 xlabel('\theta_{servo} [\circ]')
 ylabel('\theta_{tilt} [\circ]')
 grid on
 

PPM2deg=90/1500;
deg2PPM=2350/123.18;
tservo=[67.8955 74.4845 99.9811 111.1538 123.18]
ppm=[1650 1701 1950 2099 2350]
coefs=polyfit(tservo,ppm,1)
 

 for i=1:size(theta_servo,2)
    y(i)=polyval(coefs,rad2deg(theta_servo(i)));
 end
 
 
 i=1
 Xini=[1600]
 Xfim=[2350]
 ndivx=[7]
 figure
 figura=gcf
 plot(y,rad2deg(theta_tilt));
 xlabel('PPM [ms]')
 axis([Xini(i) Xfim(i) -10 40])
 figura.Children.XTick= linspace(Xini(i), Xfim(i),ndivx(i))
 ylabel('\theta_{tilt} [\circ]')
 grid on