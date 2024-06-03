clc
% Definir los parámetros del entorno
num_filas = 10;
num_columnas = 10;
num_estados = num_filas * num_columnas;
num_acciones = 4;
gamma = 0.9;
alpha = 0.8;
epsilon = 0.1;
num_episodios = 1000;
num_ovejas = 5;

% Parámetros del algoritmo de Boids
separacion = 1.5;
alineacion = 1.0;
cohesion = 1.0;
distancia_separacion = 2;
distancia_cohesion = 4;

% Definir el área objetivo
area_objetivo = [3 3 8 8]; % [fila_min columna_min fila_max columna_max]

% Inicializar las tablas Q para cada pastor
Q_pastor1 = zeros(num_estados, num_acciones);
Q_pastor2 = zeros(num_estados, num_acciones);


% Entrenamiento de los pastores utilizando IRL con el algoritmo de Boids
recompensas_episodios = zeros(1, num_episodios);
recompensas_promedio = zeros(1, num_episodios);

for episodio = 1:num_episodios
    estados_pastores = [randi(num_estados), randi(num_estados)];
    estados_ovejas = randi(num_estados, 1, num_ovejas);
    
    recompensas_episodio = 0;
    episodio
    
    while ~verificar_ovejas_en_area(estados_ovejas, area_objetivo, num_filas, num_columnas)
        % Pastor 1: Izquierda y Superior
        estado_actual1 = calcular_estado(estados_pastores(1), estados_ovejas);
        accion_pastor1 = seleccionar_accion(estado_actual1, Q_pastor1, epsilon,num_acciones);
        [siguiente_estado1, recompensa1] = ejecutar_accion(estado_actual1, accion_pastor1, estados_pastores(1), estados_ovejas, area_objetivo, 'izquierda_superior',num_filas,num_columnas);
        
        Q_pastor1(estado_actual1, accion_pastor1) = Q_pastor1(estado_actual1, accion_pastor1) + ...
            alpha * (recompensa1 + gamma * max(Q_pastor1(siguiente_estado1, :)) - Q_pastor1(estado_actual1, accion_pastor1));
        
        estados_pastores(1) = siguiente_estado1;
        
        % Pastor 2: Derecha e Inferior
        estado_actual2 = calcular_estado(estados_pastores(2), estados_ovejas);
        accion_pastor2 = seleccionar_accion(estado_actual2, Q_pastor2, epsilon,num_acciones);
        [siguiente_estado2, recompensa2] = ejecutar_accion(estado_actual2, accion_pastor2, estados_pastores(2), estados_ovejas, area_objetivo, 'derecha_inferior',num_filas,num_columnas);
        
        Q_pastor2(estado_actual2, accion_pastor2) = Q_pastor2(estado_actual2, accion_pastor2) + ...
            alpha * (recompensa2 + gamma * max(Q_pastor2(siguiente_estado2, :)) - Q_pastor2(estado_actual2, accion_pastor2));
        
        estados_pastores(2) = siguiente_estado2;
        
        recompensas_episodio = recompensas_episodio + recompensa1 + recompensa2;
        
        estados_ovejas = actualizar_posiciones_ovejas(estados_ovejas, estados_pastores, num_filas, num_columnas,num_ovejas,distancia_separacion,distancia_cohesion,separacion,alineacion,cohesion);
        
        recompensas_episodios2(episodio) = recompensas_episodio;
        recompensas_promedio2(episodio) = mean(recompensas_episodios(1:episodio));
        graficar_resultados(recompensas_episodios2, recompensas_promedio2);
    
    
    end
    
    recompensas_episodios(episodio) = recompensas_episodio;
    recompensas_promedio(episodio) = mean(recompensas_episodios(1:episodio));

    graficar_resultados(recompensas_episodios, recompensas_promedio);
    
    if mod(episodio, 100) == 0
        fprintf('Episodio %d - Recompensa Total: %.2f - Recompensa Promedio: %.2f\n', episodio, recompensas_episodio, recompensas_promedio(episodio));
    end
end

% Graficar los resultados del entrenamiento
graficar_resultados(recompensas_episodios, recompensas_promedio);