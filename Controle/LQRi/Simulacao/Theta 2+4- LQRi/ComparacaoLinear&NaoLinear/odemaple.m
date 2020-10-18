function dxdt = odemaple(t, x, u)
   
    b1 = 0.215;
    b2 = 0.215;
    g=9.81;
    % Parametros de theta4
    mi_d4 = 0.0959;
    c4 = 0.6376;
    
    %Parametros de Theta2
    mi_d2  = 1.598815;

    % Parametros do contra-peso
    mcp = 1.709;
    lcp = 0.33;
    
    % Parametros do motor
    p = [8.016, 0;
         0, 9.072];
     
    coef1 = [-0.000063260930216   0.013139466306494  -0.175069018957576];
    coef2 = [-0.000021708654545   0.010473514036364  -0.077660122909090];
    
    
    q = [polyval(coef1,u(1)),                   0; 
                           0, polyval(coef2,u(2))];
 
 
 %Dinamica do motor
    Fm = [x(3);
          x(4)];
      
    Fmp = -p * Fm + q * u;
    
    %Dinamica da bancada
    %    1       2    3  4     5         6        7     8
    %x=[theta2 theta4 f1 f2 thetadot2 thetadot4 f1dot f2dot]
    q =     [0, x(1),     -x(1)-pi/2, x(2)];
    qdot =  [0, x(5),     -x(5), x(6)];
   
    % Definindo os termo Dq,Cq,Gq,nJp
    [Dq,Cq,Gq,nJp] = matrizesBancada(q(1),q(2),q(3),q(4),qdot(1),qdot(2),qdot(3),qdot(4));
    %Definindo termo Gamma e
    tilt = [-1, -1;
            0, 0;
            0, 0;
            0, 0;
            0, 0;
          b1, -b2];
    f = (Fm);
    gamma_b = nJp * tilt * f; 
    
     Extra = [0;
             lcp*mcp*g*cos(q(2))- mi_d2*qdot(2);
             0;
             -mi_d4*qdot(4) - c4*q(4)];
         
    qddot = Dq^-1*( - Cq + Extra - Gq + gamma_b);
    Extra-Gq+gamma_b
    
    % Explicit function
    dxdt = [x(5);
            x(6);
            Fmp;
           qddot([2,4])];
end