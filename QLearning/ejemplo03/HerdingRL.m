clc
% Definir los parámetros del entorno
num_filas = 10;
num_columnas = 10;
num_estados = num_filas * num_columnas;
num_acciones = 4;
gamma = 0.9;
alpha = 0.8;
num_episodios = 1000;
num_pastores = 3;
num_ovejas = 5;

% Definir el área objetivo
area_objetivo = [4 5 6 7; 6 7 8 8];

% Definir la matriz de recompensas
R = zeros(num_estados, num_acciones);

% Inicializar las tablas Q para los pastores
global Q_pastores;
Q_pastores = cell(1, num_pastores);
for i = 1:num_pastores
    Q_pastores{i} = rand(num_estados, num_acciones);
end

% Entrenamiento de los pastores utilizando Q-Learning
for episodio = 1:num_episodios
    estados_pastores = randi(num_estados, 1, num_pastores);
    estados_ovejas = randi(num_estados, 1, num_ovejas);
    episodio
    
    while ~verificar_ovejas_en_area(estados_ovejas, area_objetivo, num_filas, num_columnas)
        estados_pastores = ajustar_posiciones_pastores(estados_pastores, estados_ovejas, num_filas, num_columnas, area_objetivo,num_pastores,num_estados);
        for i = 1:num_pastores
            accion_pastor = calcular_accion_pastor(estados_pastores(i), estados_ovejas, num_filas, num_columnas, area_objetivo,num_acciones);
            siguiente_estado = obtener_siguiente_estado(estados_pastores(i), accion_pastor, num_filas, num_columnas);
            
            recompensa = 0;
            if verificar_ovejas_en_area(estados_ovejas, area_objetivo, num_filas, num_columnas)
                recompensa = 100;
            end
            
            actualizar_Q(estados_pastores(i), accion_pastor, siguiente_estado, recompensa, alpha, gamma, i);
            
            estados_pastores(i) = siguiente_estado;
        end
        
        % Mover las ovejas aleatoriamente
        for j = 1:num_ovejas
            accion_oveja = randi(num_acciones);
            estados_ovejas(j) = obtener_siguiente_estado(estados_ovejas(j), accion_oveja, num_filas, num_columnas);
        end

        graficar_posiciones(estados_pastores, estados_ovejas, num_filas, num_columnas, area_objetivo);
        pause(0.1);

    end
end

% Prueba de los pastores entrenados
estados_pastores = randi(num_estados, 1, num_pastores);
estados_ovejas = randi(num_estados, 1, num_ovejas);

while ~verificar_ovejas_en_area(estados_ovejas, area_objetivo, num_filas, num_columnas)
    estados_pastores = ajustar_posiciones_pastores(estados_pastores, estados_ovejas, num_filas, num_columnas, area_objetivo,num_pastores,num_estados);
    
    for i = 1:num_pastores
        accion_pastor = calcular_accion_pastor(estados_pastores(i), estados_ovejas, num_filas, num_columnas, area_objetivo,num_acciones);
        siguiente_estado = obtener_siguiente_estado(estados_pastores(i), accion_pastor, num_filas, num_columnas);
        
        estados_pastores(i) = siguiente_estado;
    end
    
    % Mover las ovejas aleatoriamente
    for j = 1:num_ovejas
        accion_oveja = randi(num_acciones);
        estados_ovejas(j) = obtener_siguiente_estado(estados_ovejas(j), accion_oveja, num_filas, num_columnas);
    end
    
    pause(0.5);
end

disp('¡Todas las ovejas están en el área objetivo!');