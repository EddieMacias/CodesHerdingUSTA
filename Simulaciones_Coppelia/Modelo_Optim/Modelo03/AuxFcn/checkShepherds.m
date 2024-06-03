
err_shep = zeros(300:4);
for i=1:300
    err_shep(i,1) = norm(trajectory06(i,1:2) - targets_trj1(i,:));
    err_shep(i,2) = norm(trajectory07(i,1:2) - targets_trj2(i,:));
    err_shep(i,3) = norm(trajectory09(i,1:2) - targets_trj3(i,:));
    err_shep(i,4) = norm(trajectory10(i,1:2) - targets_trj4(i,:));
end


xt = 1:num_iterations;

X_axes = [0 300];
Y_axes = [-2.5 2.5];

figure
subplot(3,1,1)

plot(xt, trajectory06(:,1))
hold on
plot(xt,targets_trj1(:,1))
axis([X_axes Y_axes])
grid on
grid minor
xlabel('Iteraciones');
ylabel('tayectoria_x');
title('Trayectoria Agente U eje X');
legend('Pastor_U(x)', 'Target_U(x)','Location','NorthEastOutside','Orientation','vertical')


subplot(3,1,2)
plot(xt,trajectory06(:,2))
hold on
plot(xt,targets_trj1(:,2))
grid on
grid minor
axis([X_axes Y_axes])
xlabel('Iteraciones');
ylabel('tayectoria_y');
title('Trayectoria Agente U eje Y');
legend('Pastor_U(y)', 'Target_U(y)','Location','NorthEastOutside','Orientation','vertical')

subplot(3,1,3)
plot(xt,err_shep(:,1))
grid on
grid minor
axis([X_axes Y_axes])
xlabel('Iteraciones');
ylabel('Error');
title('Error de trayectoria');



figure
subplot(3,1,1)
xt = 1:num_iterations;
plot(xt, trajectory07(:,1))
hold on
plot(xt,targets_trj2(:,1))
grid on
grid minor
axis([X_axes Y_axes])
xlabel('Iteraciones');
ylabel('tayectoria_x');
title('Trayectoria Agente L eje X');
legend('Pastor_L(x)', 'Target_L(x)','Location','NorthEastOutside','Orientation','vertical')

subplot(3,1,2)
plot(xt,trajectory07(:,2))
hold on
plot(xt,targets_trj2(:,2))
grid on
grid minor
axis([X_axes Y_axes])
xlabel('Iteraciones');
ylabel('tayectoria_y');
title('Trayectoria Agente L eje Y');
legend('Pastor_L(y)', 'Target_L(y)','Location','NorthEastOutside','Orientation','vertical')

subplot(3,1,3)
plot(xt,err_shep(:,2))
grid on
grid minor
axis([X_axes Y_axes])
xlabel('Iteraciones');
ylabel('Error');
title('Error de trayectoria');



figure
subplot(3,1,1)
xt = 1:num_iterations;
plot(xt, trajectory09(:,1))
hold on
plot(xt,targets_trj3(:,1))
grid on
grid minor
axis([X_axes Y_axes])
xlabel('Iteraciones');
ylabel('tayectoria_x');
title('Trayectoria Agente D eje X');
legend('Pastor_D(x)', 'Target_D(x)','Location','NorthEastOutside','Orientation','vertical')

subplot(3,1,2)
plot(xt,trajectory09(:,2))
hold on
plot(xt,targets_trj3(:,2))
grid on
grid minor
axis([X_axes Y_axes])
xlabel('Iteraciones');
ylabel('tayectoria_y');
title('Trayectoria Agente D eje Y');
legend('Pastor_D(y)', 'Target_D(y)','Location','NorthEastOutside','Orientation','vertical')

subplot(3,1,3)
plot(xt,err_shep(:,3))
grid on
grid minor
axis([X_axes Y_axes])
xlabel('Iteraciones');
ylabel('Error');
title('Error de trayectoria');


figure
subplot(3,1,1)
xt = 1:num_iterations;
plot(xt, trajectory10(:,1))
hold on
plot(xt,targets_trj4(:,1))
grid on
grid minor
axis([X_axes Y_axes])
xlabel('Iteraciones');
ylabel('tayectoria_x');
title('Trayectoria Agente R eje X');
legend('Pastor_R(x)','Target_R(x)','Location','NorthEastOutside','Orientation','vertical')

subplot(3,1,2)
plot(xt,trajectory10(:,2))
hold on
plot(xt,targets_trj4(:,2))
grid on
grid minor
axis([X_axes Y_axes])
xlabel('Iteraciones');
ylabel('tayectoria_y');
title('Trayectoria Agente R eje Y');
legend('Pastor_R(y)','Target_R(y)','Location','NorthEastOutside','Orientation','vertical')

subplot(3,1,3)
plot(xt,err_shep(:,1))
grid on
grid minor
axis([X_axes Y_axes])
xlabel('Iteraciones');
ylabel('Error');
title('Error de trayectoria');






