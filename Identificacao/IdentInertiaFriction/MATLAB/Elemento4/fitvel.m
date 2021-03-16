function J = fitvel(X)

global roll_dot_0;
global ensaio_size;
K=X(1);
xi=X(2);
wn=X(3);
A=0.1157;
vi=0.064571;
Ts=0.02;

Tempoensaio=0:Ts:ensaio_size*Ts;

H = tf(K*(wn^2),[1, 2*xi*wn, wn^2]);
[y0,t]=step(H,Tempoensaio);
y0=y0*A+vi;
ydot=diff(y0)/Ts;
y0=[y0(1:end-1),ydot];

J = sum((y0(:,2)-roll_dot_0(1:end-1)).^2)

end