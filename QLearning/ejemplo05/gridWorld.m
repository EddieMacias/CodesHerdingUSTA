% Definir los parámetros del entorno
clc

board_size = 20;
num_filas = board_size+1;
num_columnas = board_size+1;
num_estados = num_filas * num_columnas;
num_acciones = 4;
gamma = 0.9;
alpha = 0.8;
epsilon = 0.1;
num_episodios = num_estados*board_size;
training_time = zeros(num_episodios,1);
num_recompensas = 9;





% posiciones_castigos = randperm(num_estados - 1, num_recompensas);
% max_recompensa = randi(num_estados);
posiciones_castigos = [152 178 184 259 285 402 438];
max_recompensa = 89;

R = GenerarMatrizR(posiciones_castigos,max_recompensa,num_filas,num_estados,num_acciones);

% Inicializar la tabla Q con valores aleatorios
Q = rand(num_estados, num_acciones);
[Q, training_time] = TrainAgent(num_episodios, num_estados, max_recompensa, Q, epsilon, num_acciones, num_filas, num_columnas, R, alpha, gamma, training_time);

% Prueba del agente entrenado
estado = randi(num_estados);
TestAgent(estado, max_recompensa, Q, num_acciones, num_filas, num_columnas, R,posiciones_castigos(1));

figure
plot(training_time);
grid on
grid minor
Total_TT = sum(training_time);
disp(' ')
fprintf('Tiempo de entrenamiento para %d iteraciones : %f segundos\n', num_episodios, Total_TT);
title('Tiempo de entrenamiento')
xlabel('Iteraciones')
ylabel('T(s)')