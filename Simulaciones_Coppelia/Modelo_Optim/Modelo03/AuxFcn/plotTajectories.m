%% plotTajectory boids
ax = [-2.5 2.5];
ay = [-2.5 2.5];
az = [0 1];

figure
subplot(2,2,1:2)
plot(trajectory01(:,1), trajectory01(:,2), Color='blue');
hold on
plot(trajectory02(:,1), trajectory02(:,2), Color='blue');
plot(trajectory03(:,1), trajectory03(:,2), Color='blue'); 
plot(trajectory04(:,1), trajectory04(:,2), Color='blue'); 
plot(trajectory05(:,1), trajectory05(:,2), Color='blue'); 
rectangle('Position', [-1, -1, 2, 2], 'EdgeColor', 'red');
plot(trajectory06(:,1), trajectory06(:,2) );
plot(trajectory07(:,1), trajectory07(:,2) );
plot(trajectory09(:,1), trajectory09(:,2) );
plot(trajectory10(:,1), trajectory10(:,2) );
grid on
grid minor
axis([ax ay az]);
xlabel('X');
ylabel('Y');
zlabel('Z');
title("Trayectorias pastores y enjambre");


subplot(2,2,3)
plot(trajectory01(:,1), trajectory01(:,2), Color='blue');
hold on
plot(trajectory02(:,1), trajectory02(:,2), Color='blue');
plot(trajectory03(:,1), trajectory03(:,2), Color='blue'); 
plot(trajectory04(:,1), trajectory04(:,2), Color='blue'); 
plot(trajectory05(:,1), trajectory05(:,2), Color='blue'); 
rectangle('Position', [-1, -1, 2, 2], 'EdgeColor', 'red');
grid on
grid minor
axis([ax ay az]);
xlabel('X');
ylabel('Y');
zlabel('Z');
title("Trayectorias enjambre");

subplot(2,2,4)
plot(trajectory06(:,1), trajectory06(:,2) );
hold on
plot(trajectory07(:,1), trajectory07(:,2) );
plot(trajectory09(:,1), trajectory09(:,2) );
plot(trajectory10(:,1), trajectory10(:,2) );
rectangle('Position', [-1, -1, 2, 2], 'EdgeColor', 'red');
grid on
grid minor
axis([ax ay az]);
xlabel('X');
ylabel('Y');
zlabel('Z');
title("Trayectorias Pastores");
legend('Pastor_U','Pastor_L','Pastor_D','Pastor_R','Location','southoutside','Orientation','Horizontal');


figure

ax = [-1.5 1.5];
ay = [-1.5 1.5];
subplot(3,2,1:2)
scatter(trajectory05(:,1), trajectory05(:,2))
hold on
rectangle('Position', [-1, -1, 2, 2], 'EdgeColor', 'blue');
axis([ax ay])
grid on
grid minor
title("Trayectoria oveja 05")

subplot(3,2,3)
scatter(trajectory01(:,1), trajectory01(:,2))
hold on
rectangle('Position', [-1, -1, 2, 2], 'EdgeColor', 'blue');
axis([ax ay])
grid on
grid minor
title("Trayectoria oveja 01")

subplot(3,2,4)
scatter(trajectory02(:,1), trajectory02(:,2))
hold on
rectangle('Position', [-1, -1, 2, 2], 'EdgeColor', 'blue');
axis([ax ay])
grid on
grid minor
title("Trayectoria oveja 02")

subplot(3,2,5)
scatter(trajectory03(:,1), trajectory03(:,2))
hold on
rectangle('Position', [-1, -1, 2, 2], 'EdgeColor', 'blue');
axis([ax ay])
grid on
grid minor
title("Trayectoria oveja 03")

subplot(3,2,6)
scatter(trajectory04(:,1), trajectory04(:,2))
hold on
rectangle('Position', [-1, -1, 2, 2], 'EdgeColor', 'blue');
axis([ax ay])
grid on
grid minor
title("Trayectoria oveja 04")





