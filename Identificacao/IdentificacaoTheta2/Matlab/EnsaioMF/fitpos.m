function J = fitpos(X)

global roll_0 roll_dot_0;
global ensaio_size;
global n_ensaio;

K=X(1);
xi=X(2);
wn=X(3);
A=[0.0417    0.0653    0.0559    0.0700];
vi=[0.0456    0.0220    0.0314    0.0173];
Ts=0.02;

Tempoensaio=0:Ts:ensaio_size*Ts;

H = tf(K*(wn^2),[1, 2*xi*wn, wn^2]);
[y0,t]=step(H,Tempoensaio);
y0=y0*A(n_ensaio)+vi(n_ensaio);
ydot=diff(y0)/Ts;
y0=[y0(1:end-1),ydot];

%F = @(t, x) [x(2); -(X(2)/X(1))*x(2) - (X(3)/X(1))*x(1) + (2*b*0.13)/X(1)];
%T = 0:0.02:(length(roll_dot_0)-1)*0.02;
%S = [roll_0(1) roll_dot_0(1)];

%[t, y0] = ode45(F, T, S);

J = sum((y0(:,1)-roll_0(1:end-1)).^2 )

end