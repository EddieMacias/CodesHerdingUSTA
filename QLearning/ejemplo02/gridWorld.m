% Definir los parámetros del entorno
clc
global Q
num_filas = 21;
num_columnas = 21;
num_estados = num_filas * num_columnas;
num_acciones = 4;
gamma = 0.9;
alpha = 0.8;
num_episodios = num_estados*26;

training_time = zeros(num_episodios,1);

% Definir la matriz de recompensas aleatorias
R = -1 * ones(num_estados, num_acciones);  % Costo de movimiento de -1 para cada acción
% Generar posiciones aleatorias para las recompensas
num_recompensas = 9;
posiciones_recompensas = randperm(num_estados - 1, num_recompensas);
for i = 1:num_recompensas
    estado_recompensa = posiciones_recompensas(i);
    R(estado_recompensa, :) = -100;  % Asignar una recompensa de 10 a las posiciones seleccionadas
end

% Generar Recompensa en posicion Aleatoria

max_recompensa = randi(num_estados);
nc = 0;
while(1)
    for i=1:length(posiciones_recompensas)
        if max_recompensa == posiciones_recompensas
            max_recompensa = randi(num_estados);
        else
            nc=1;
        end
    end
    if nc == 1
        break
    end
end
R(max_recompensa, :) = 100;  % Recompensa positiva en el estado objetivo

% Inicializar la tabla Q con valores aleatorios
Q = rand(num_estados, num_acciones);

% Entrenamiento del agente utilizando Q-Learning
for episodio = 1:num_episodios
    tic;
    estado = randi(num_estados);
    while estado ~= max_recompensa
        accion = seleccionar_accion(estado, 0.1, num_acciones);
        siguiente_estado = obtener_siguiente_estado(estado, accion, num_filas, num_columnas);
        recompensa = R(estado, accion);
        actualizar_Q(estado, accion, siguiente_estado, recompensa, alpha, gamma);
        estado = siguiente_estado;
        
        %dibujar_gridworld(estado, num_filas, num_columnas, R, max_recompensa);
        %pause(0.001);
    end
    training_time(episodio) = toc;
end

% Prueba del agente entrenado
estado = 1;
cnt = 1;

while estado ~= max_recompensa
    
    accion = seleccionar_accion(estado, 0, num_acciones);
    siguiente_estado = obtener_siguiente_estado(estado, accion, num_filas, num_columnas);
    
    switch (accion)
        case (1) 
            act  = "Arriba";
        case (2)
            act  = "Abajo";
        case (3)
            act = "Izquierza";
        case (4)
            act = "Derecha";
        otherwise
            act = "nd";
    end

    fprintf('Paso %d, Estado: %d, Acción: %s, Siguiente Estado: %d\n', cnt, estado, act, siguiente_estado);
    estado = siguiente_estado;
    cnt = cnt+1;
    dibujar_gridworld(estado, num_filas, num_columnas, R, max_recompensa);
    %pause(0.01);
end

figure
plot(training_time);
grid on
grid minor
Total_TT = sum(training_time);
disp(' ')
fprintf('Tiempo de entrenamiento para %d iteraciones : %f segundos\n', num_episodios, Total_TT);