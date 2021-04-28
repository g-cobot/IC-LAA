function prt_map(theta_servo,theta_tilt)
subplot(2,1,2)
clear plot;
plot(rad2deg(theta_servo),rad2deg(theta_tilt),'b');   
hold on
plot(rad2deg(theta_servo(end)),rad2deg(theta_tilt(end)),'r*'); 
xlabel('\theta_{servo} [\circ]')
ylabel('\theta_{tilt} [\circ]')
end