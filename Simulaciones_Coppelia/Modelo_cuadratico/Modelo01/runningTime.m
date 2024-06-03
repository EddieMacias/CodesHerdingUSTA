
figure
plot(training_time)
grid on
grid minor
xlabel('Iteraciones')
ylabel('Segundos')
msg = sprintf('Tiempo de Entrenamiento Algoritmo Boids Vs Boids = %f s',sum(training_time));
title(msg)

