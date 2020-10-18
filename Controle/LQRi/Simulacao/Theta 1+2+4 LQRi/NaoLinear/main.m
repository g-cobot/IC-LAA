%LQRi - Controle de atitude e altura(theta24)

clear;
close all;
clc;

deg2rad = pi/180;
rad2deg = 180/pi;

% x = [theta1 theta2 theta4 F1 F2 thetadot1 thetadot2 thetadot4 Fdot1 Fdot2];



% Script para carregar os dados da planta
[A,B,C,D,Ts] = paramplanta();

% Auxiliares
p = size(B,2);
q = size(C,1);
n = size(A,1)+2;

% Condicao inicial e referencia
kmax = 1500;
thetainitial    = [0 -18.7 -5]*deg2rad;
theta_dotinitial= [0 0 0]     *deg2rad;

xref0    = [thetainitial(1:2) 0]; % já esta em rad regule theta4
xref100  = deg2rad*[0 0 0];       % regule theta2                                                              
xref500  = deg2rad*[-3 0 0];      % ref theta1
xref1000 = deg2rad*[0 0 0];       % voltar para origem


forcasiniciais=[1.7 1.7];

xini = [thetainitial forcasiniciais theta_dotinitial];
up0 = forcasiniciais';

% Parametros de projeto
PesoInt=[0.25 0.2 0.5];             %err_theta1     err_theta2     err_theta4
PesoTheta=[0.01 1 0.05];            %theta1         theta2         theta4
PesoTheta_dot=[1.001 0.5 0.4901];   %theta1_dot     theta2_dot     theta4_dot

Qr = diag([PesoInt PesoTheta PesoTheta_dot]);   % size(Qr) = q+n
Rr = 1*diag([1, 1]);                            % size(Rr) = p
Td = 0.01;                                      % (s) atraso de transporte;

wLim = [60, 40];   % limitantes em PPM

% Auxiliares dinamica motor
Fcoef1 = [0.000458547428571   0.036316433142860  -0.944062080000104];
Fcoef2 = [0.000796758857143   0.009037906285718  -0.285379440000110];

% Script para carregar os dados do controlador
[Ki,K,Nx] = controlador(A,B,C,D,Qr,Rr,Ts);

% Definindo variaveis de estado e controle
% Estado x
x = zeros(n,kmax+1);
% Entrada
u = zeros(p,kmax);
w = zeros(p,kmax);
% Saida real
y = zeros(q,kmax);
% Saida medida
ym = zeros(q,kmax);

xreferencias=zeros( size(thetainitial,2),kmax);

% Condicoes Iniciais
x(:,1) = xini';
xi = zeros(q,1);
xikM1 = zeros(q,1);
wkm1 = zeros(p,1);

% Ruido posicao angular - Range de +/-0.025 rad
%rng(0,'twister');
a = -0.025;
b = 0.025;
ruidoPa1 = 0*((b-a).*rand(kmax,1) + a);
ruidoPa2 = 0*((b-a).*rand(kmax,1) + a);
ruidoPa = [ruidoPa1';ruidoPa1';ruidoPa2'];
% Ruido velocidade angular - Range de +/-0.14 rad/s
a = -0.14;
b = 0.14;
ruidoVa1 = 0*((b-a).*rand(kmax,1) + a);
ruidoVa2 = 0*((b-a).*rand(kmax,1) + a);
ruidoVa = [ruidoVa1';ruidoVa1';ruidoVa2'];

% Configura�ao ode45
opt = odeset('Reltol',1e-6,'AbsTol',1e-6);
% Evolucao da dinamica da planta
for k = 1:kmax
   
    xreferencias(:,k)=xref0';
    if(k>=1000)
        xreferencias(:,k)=xref1000';
    elseif(k>=500)
        xreferencias(:,k)=xref500';
    elseif(k>=100)
        xreferencias(:,k)=xref100';
    end
    xaux = x([1:q,q+3:end],k);
    % Saida real
    y(:,k) = C * xaux;
    % Saida medida
    ym(:,k) = C * xaux + ruidoPa(k);
    
    % Calculando integral do erro xi
    erro = ym(:,k) - xreferencias(:,k);
    xikM1 = xi + Ts * erro;
    
    % Calculando forca f
    u(:,k) = (-[Ki, K] * [xi; (xaux+[ruidoPa(:,k);ruidoVa(:,k)])] + K*Nx*xreferencias(:,k));
    up = u(:,k) + up0;
    
    % Convertendo de u (forca) para w (PPM)
    w(:,k) = [max(roots([Fcoef1([1,2]),Fcoef1(3) - up(1)])); max(roots([Fcoef2([1,2]),Fcoef2(3) - up(2)]))];
    
    % saturacao da entrada
    w(:,k) = min(wLim(1),w(:,k)); % Limite superior
    w(:,k) = max(wLim(2),w(:,k)); % Limite inferior
    
    %Aplicando controle
    xini = x(:,k);
    [t,dummy] = ode45(@(t,x) odemaple(t, x, wkm1),[0 Td], xini,opt); % Atraso de Td segundos
    xini = dummy(end,:)';
    [t,dummy] = ode45(@(t,x) odemaple(t, x, w(:,k)),[0 Ts-Td], xini,opt);
    x(:,k+1) = dummy(end,:)';
    
    xi = xikM1;
    wkm1 = w(:,k);
end
%data = [y',ym',w',u',x(:,1:end-1)'];
%dlmwrite('.txt',data,'delimiter','\t');

y = y*rad2deg;%rad -> graus
ym = ym*rad2deg;%rad -> graus
u = u + up0;
plotdata(w,y,u,x,xreferencias*rad2deg,kmax);

