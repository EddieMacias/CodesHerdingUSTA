% Definir los parámetros del entorno
num_estados = 25;
num_acciones = 4;
gamma = 0.9;
alpha = 0.8;
num_episodios = 1000;

% Definir la matriz de recompensas
R = 0 * ones(num_estados, num_acciones);  % Costo de movimiento de -1 para cada acción
R(25, :) = 100;  % Recompensa positiva en el estado objetivo

% Definir las rutas con pérdidas
rutas_perdidas = [7,6, 10, 8, 13, 18, 19];  % Ejemplos de estados con pérdidas
R(rutas_perdidas, :) = -10;                 % Asignar una pérdida de -10 a las rutas especificadas

% Inicializar la tabla Q con valores aleatorios
Q = rand(num_estados, num_acciones);

% Entrenamiento del agente utilizando Q-Learning
for episodio = 1:num_episodios
    estado = randi(num_estados);
    
    while estado ~= 25
        accion = seleccionar_accion(estado, 0.1, num_acciones);
        siguiente_estado = obtener_siguiente_estado(estado, accion);
        recompensa = R(estado, accion);
        
        actualizar_Q(estado, accion, siguiente_estado, recompensa, alpha, gamma);
        
        estado = siguiente_estado;
        
        %dibujar_gridworld(estado,rutas_perdidas);
        %pause(0.05);
    end
end

% Prueba del agente entrenado
estado = 1;

while estado ~= 25
    accion = seleccionar_accion(estado, 0, num_acciones);
    siguiente_estado = obtener_siguiente_estado(estado, accion);
    
    fprintf('Estado: %d, Acción: %d, Siguiente Estado: %d\n', estado, accion, siguiente_estado);
    
    estado = siguiente_estado;
    dibujar_gridworld(estado,rutas_perdidas);
    pause(0.5);
end