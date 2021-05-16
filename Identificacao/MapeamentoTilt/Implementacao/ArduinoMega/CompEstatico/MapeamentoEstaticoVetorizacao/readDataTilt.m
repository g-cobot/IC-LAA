function dado = readDataTilt(filename)
global Ts;
global numValues;

txtfile = dlmread(filename);
data = iddata([txtfile(:,3) txtfile(:,6)],[txtfile(:,1) txtfile(:,5) txtfile(:,4)],Ts,'ExperimentName','Identificacao do tilt');
data.OutputName = {'ADC','Alfa'};
data.OutputUnit = {'0-1023','degrees'};
data.InputName = {'Time','ThetaServo','PPM'};
data.InputUnit = {'seconds','degrees','milliseconds'};


col1=[];
col2=[];
col3=[];
col4=[];
col5=[];
col6=[];
col7=[];
col8=[];
col9=[];
col10=[];
col11=[];
col12=[];
col13=[];
col14=[];
col15=[];
col16=[];
col17=[];
col18=[];
col19=[];
col20=[];
col21=[];
col22=[];
col23=[];
col24=[];
col25=[];

for i = 1:length(data.u)
    if(data.u(i,2)==60)
        col1=[col1;data.y(i,2)];
        
    elseif(data.u(i,2)==65)
        col2=[col2;data.y(i,2)];
        
    elseif(data.u(i,2)==70)
        col3=[col3;data.y(i,2)]; 
        
    elseif(data.u(i,2)==75)
        col4=[col4;data.y(i,2)];
        
    elseif(data.u(i,2)==80)
        col5=[col5;data.y(i,2)];
        
    elseif(data.u(i,2)==85)
        col6=[col6;data.y(i,2)];
        
    elseif(data.u(i,2)==90)
        col7=[col7;data.y(i,2)];
        
    elseif(data.u(i,2)==95)
        col8=[col8;data.y(i,2)];
        
    elseif(data.u(i,2)==100)
        col9=[col9;data.y(i,2)];
        
    elseif(data.u(i,2)==105)
        col10=[col10;data.y(i,2)];
        
    elseif(data.u(i,2)==110)
        col11=[col11;data.y(i,2)];
        
    elseif(data.u(i,2)==115)
        col12=[col12;data.y(i,2)];
        
    elseif(data.u(i,2)==120)
        col13=[col13;data.y(i,2)];
        
    elseif(data.u(i,2)==125)
        col14=[col14;data.y(i,2)];
    elseif(data.u(i,2)==130)
        col15=[col15;data.y(i,2)];
    elseif(data.u(i,2)==135)
        col16=[col16;data.y(i,2)];
    elseif(data.u(i,2)==140)
        col17=[col17;data.y(i,2)];
    elseif(data.u(i,2)==145)
        col18=[col18;data.y(i,2)];
    elseif(data.u(i,2)==150)
        col19=[col19;data.y(i,2)];
    elseif(data.u(i,2)==155)
        col20=[col20;data.y(i,2)];
    elseif(data.u(i,2)==160)
        col21=[col21;data.y(i,2)];
    elseif(data.u(i,2)==165)
        col22=[col22;data.y(i,2)];
    elseif(data.u(i,2)==170)
        col23=[col23;data.y(i,2)];
    elseif(data.u(i,2)==175)
        col24=[col24;data.y(i,2)];
    elseif(data.u(i,2)==180)
        col25=[col25;data.y(i,2)];
    end
end


dado = [ col1(1:numValues) col2(1:numValues) col3(1:numValues) col4(1:numValues) ...
         col5(1:numValues) col6(1:numValues) col7(1:numValues) col8(1:numValues) ...
         col9(1:numValues) col10(1:numValues) col11(1:numValues) col12(1:numValues) ... 
         col13(1:numValues) col14(1:numValues) col15(1:numValues) col16(1:numValues) ...];
         col17(1:numValues) col18(1:numValues) col19(1:numValues) col20(1:numValues) ...
         col21(1:numValues) col22(1:numValues) col23(1:numValues) col24(1:numValues) ... 
         col25(1:numValues) ];

end