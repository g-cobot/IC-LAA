function J = Js(X)

global roll_0;
global ensaio_size;

a=X(1);
b=X(2);
c=X(3);
d=X(4);

deg2rad=pi/180;
ref=10*deg2rad;
Ts=0.02;

Tempoensaio=0:Ts:ensaio_size*Ts;

H = tf([a b],[1, c, d]);
[y0,t]=step(H,Tempoensaio);
y0=y0*ref;
ydot=diff(y0)/Ts;
y0=[y0(1:end-1),ydot];

J = sum((y0(:,1)-roll_0(1:end-1)).^2 )

end