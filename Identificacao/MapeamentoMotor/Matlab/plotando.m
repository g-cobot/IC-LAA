Ts=0.012
%Ts=1
offset=29

figure
plot((0:(size(M2_Finald.InputData(1:1080-offset),1)-1))*Ts,M2_Finald.InputData(1:1080-offset)-2.4931*ones(size(M2_Finald.InputData(1:1080-offset),1)))
figure
plot((0:(size(M1_Finald.OutputData(1+offset:1080),1)-1))*Ts,M1_Finald.OutputData(1+offset:1080)-0.027627*ones(size(M1_Finald.OutputData(1+offset:1080),1)))

M1_Final=iddata(M1_Finald.OutputData(1+offset:1080),M2_Finald.InputData(1:1080-offset),Ts,'ExperimentName','Motor 1 Força por PPM');
M1_Final.OutputName = {'Force'};
M1_Final.OutputUnit = {'Newtons'};
M1_Final.InputName = {'PPM bar'};
M1_Final.InputUnit = {'milliseconds'};

figure
plot((0:(size(M2_Finald.OutputData(1:1080-offset),1)-1))*Ts,M2_Finald.OutputData(1:1080-offset)-0.04366*ones(size(M2_Finald.OutputData(1:1080-offset),1)))

M2_Final=iddata(M2_Finald.OutputData(1:1080-offset),M2_Finald.InputData(1:1080-offset),Ts,'ExperimentName','Motor 2 Força por PPM');
M2_Final.OutputName = {'Force'};
M2_Final.OutputUnit = {'Newtons'};
M2_Final.InputName = {'PPM bar'};
M2_Final.InputUnit = {'milliseconds'};
