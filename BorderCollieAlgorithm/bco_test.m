% Posiciones iniciales de las ovejas
ovejas = [-0.5 0.5; -0.5 0.5; 0.5 0.5; 0.5 -0.5; 0 0];

% Parámetros del algoritmo
radio_objetivo = 1;
distancia_minima_pastor = 0.4;
velocidad_ovejas = 0.07;
num_iteraciones = 100;
factor_aleatorio = 0.2;

% Posiciones fijas de los pastores (perros)
pastor_izquierdo = [-2 -1.6];
pastor_derecho = [-1.5 -1.6];
pastor_inferior = [-1 -1.6];


% Algoritmo de optimización Border Collie
for iter = 1:num_iteraciones
    % Calcular las distancias entre las ovejas y los pastores
    distancias_izquierdo = vecnorm(ovejas - pastor_izquierdo, 2, 2);
    distancias_derecho = vecnorm(ovejas - pastor_derecho, 2, 2);
    distancias_inferior = vecnorm(ovejas - pastor_inferior, 2, 2);
    
    % Calcular el centro de masa de las ovejas
    centro_masa = mean(ovejas);
    
    % Actualizar las posiciones de las ovejas
    for i = 1:size(ovejas, 1)
        % Calcular las fuerzas de repulsión de los pastores
        fuerza_izquierdo = (ovejas(i,:) - pastor_izquierdo) / distancias_izquierdo(i);
        fuerza_derecho = (ovejas(i,:) - pastor_derecho) / distancias_derecho(i);
        fuerza_inferior = (ovejas(i,:) - pastor_inferior) / distancias_inferior(i);
        
        % Calcular la fuerza total de repulsión
        fuerza_total = fuerza_izquierdo + fuerza_derecho + fuerza_inferior;
        
        % Calcular la fuerza de atracción hacia el centro de masa
        fuerza_atraccion = (centro_masa - ovejas(i,:)) / norm(centro_masa - ovejas(i,:));
        
        % Calcular la dirección aleatoria
        direccion_aleatoria = rand(1, 2) - 0.5;
        direccion_aleatoria = direccion_aleatoria / norm(direccion_aleatoria);
        
        % Actualizar la posición de la oveja
        ovejas(i,:) = ovejas(i,:) + velocidad_ovejas * (fuerza_total / norm(fuerza_total) + ...
            factor_aleatorio * direccion_aleatoria + fuerza_atraccion);
        
        % Limitar la posición de la oveja dentro del radio objetivo
        if norm(ovejas(i,:)) > radio_objetivo
            ovejas(i,:) = ovejas(i,:) / norm(ovejas(i,:)) * radio_objetivo;
        end
    end
    
    % Evaluar la función objetivo
    distancia_total = funcion_objetivo(ovejas, pastor_izquierdo, pastor_derecho, pastor_inferior);
    
    % Mostrar las posiciones de las ovejas y los pastores en cada iteración
    clf;
    hold on;
    plot(ovejas(:,1), ovejas(:,2), 'bo', 'MarkerSize', 10);
    plot(pastor_izquierdo(1), pastor_izquierdo(2), 'r*', 'MarkerSize', 12);
    plot(pastor_derecho(1), pastor_derecho(2), 'g*', 'MarkerSize', 12);
    plot(pastor_inferior(1), pastor_inferior(2), 'm*', 'MarkerSize', 12);
    xlim([-radio_objetivo radio_objetivo]);
    ylim([-radio_objetivo radio_objetivo]);
    xlabel('Eje X');
    ylabel('Eje Y');
    title(sprintf('Iteración %d', iter));
    legend('Ovejas', 'Pastor Izquierdo', 'Pastor Derecho', 'Pastor Inferior');
    drawnow;
end

% Mostrar las posiciones finales de las ovejas y los pastores
disp('Posiciones finales:');
disp('Ovejas:');
disp(ovejas);
disp('Pastor Izquierdo:');
disp(pastor_izquierdo);
disp('Pastor Derecho:');
disp(pastor_derecho);
disp('Pastor Inferior:');
disp(pastor_inferior);