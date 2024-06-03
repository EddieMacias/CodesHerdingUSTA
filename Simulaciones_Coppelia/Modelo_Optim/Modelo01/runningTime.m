
figure
plot(running_time)
grid on
grid minor
xlabel('Iteraciones')
ylabel('Segundos')
msg = sprintf('Tiempo de Entrenamiento Algoritmo Boids Vs Boids = %f s',sum(running_time));
title(msg)

