%% plotTajectory boids
ax = [-2.5 2.5];
ay = [-2.5 2.5];
az = [0 1];

subplot(2,2,1:2)
plot3(trajectory01(:,1), trajectory01(:,2), trajectory01(:,3), Color='blue');
hold on
plot3(trajectory02(:,1), trajectory02(:,2), trajectory02(:,3), Color='blue');
plot3(trajectory03(:,1), trajectory03(:,2), trajectory03(:,3), Color='blue'); 
plot3(trajectory04(:,1), trajectory04(:,2), trajectory04(:,3), Color='blue'); 
plot3(trajectory05(:,1), trajectory05(:,2), trajectory05(:,3), Color='blue'); 
plot3(trajectory06(:,1), trajectory06(:,2), trajectory06(:,3) );
plot3(trajectory07(:,1), trajectory07(:,2), trajectory07(:,3) );
plot3(trajectory09(:,1), trajectory09(:,2), trajectory09(:,3) );
plot3(trajectory10(:,1), trajectory10(:,2), trajectory10(:,3) );
rectangle('Position', [-1, -1, 2, 2], 'EdgeColor', 'blue');
grid on
grid minor
axis([ax ay az])
xlabel('X')
ylabel('Y')
zlabel('Z')
title("Trayectorias pastores y enjambre")


subplot(2,2,3)
plot3(trajectory01(:,1), trajectory01(:,2), trajectory01(:,3), Color='blue');
hold on
plot3(trajectory02(:,1), trajectory02(:,2), trajectory02(:,3), Color='blue');
plot3(trajectory03(:,1), trajectory03(:,2), trajectory03(:,3), Color='blue'); 
plot3(trajectory04(:,1), trajectory04(:,2), trajectory04(:,3), Color='blue'); 
plot3(trajectory05(:,1), trajectory05(:,2), trajectory05(:,3), Color='blue'); 
rectangle('Position', [-1, -1, 2, 2], 'EdgeColor', 'blue');
grid on
grid minor
axis([ax ay az])
xlabel('X')
ylabel('Y')
zlabel('Z')
title("Trayectorias enjambre")

subplot(2,2,4)
plot3(trajectory06(:,1), trajectory06(:,2), trajectory06(:,3) );
hold on
plot3(trajectory07(:,1), trajectory07(:,2), trajectory07(:,3) );
plot3(trajectory09(:,1), trajectory09(:,2), trajectory09(:,3) );
plot3(trajectory10(:,1), trajectory10(:,2), trajectory10(:,3) );
rectangle('Position', [-1, -1, 2, 2], 'EdgeColor', 'blue');
grid on
grid minor
axis([ax ay az])
xlabel('X')
ylabel('Y')
zlabel('Z')
title("Trayectorias Pastores")
legend('Pastor_U','Pastor_L','Pastor_D','Pastor_R')


