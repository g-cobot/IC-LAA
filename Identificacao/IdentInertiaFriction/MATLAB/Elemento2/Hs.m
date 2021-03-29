function J = Hs(X)

global roll_0 roll_dot_0;
global ensaio_size;

K=X(1);
xi=X(2);
wn=X(3);
deg2rad=pi/180;
ref=5*deg2rad;
Ts=0.02;

Tempoensaio=0:Ts:(ensaio_size-1)*Ts;

H = tf(K*(wn^2),[1, 2*xi*wn, wn^2]);
[y0,t]=step(H,Tempoensaio);
y0=y0*ref;

J = sum((y0-roll_0).^2 )

end