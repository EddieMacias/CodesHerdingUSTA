% Parámetros del algoritmo
radio_objetivo = 1;
num_ovejas = 5;
num_pastores = 3;
num_iteraciones = 1000;
velocidad_pastores = 0.1;
distancia_minima_pastores = 0.5;
factor_repulsion = 0.1;

% Generar posiciones iniciales aleatorias para las ovejas
ovejas = -2.5 + 5 * rand(num_ovejas, 2);

% Generar posiciones iniciales aleatorias para los pastores
pastores = -2.5 + 5 * rand(num_pastores, 2);



% Inicializar la mejor solución y el mejor valor de aptitud
mejor_solucion = pastores;
mejor_aptitud = funcion_objetivo4(ovejas, pastores, radio_objetivo, distancia_minima_pastores);

% Algoritmo de optimización Border Collie
for iter = 1:num_iteraciones
    % Calcular el centro de masa de las ovejas
    centro_masa_ovejas = mean(ovejas);
    
    % Calcular las distancias entre las ovejas y el centro de la circunferencia objetivo
    distancias_centro = vecnorm(ovejas, 2, 2);
    
    % Actualizar las posiciones de los pastores
    for i = 1:num_pastores
        % Encontrar la oveja más alejada del centro de la circunferencia objetivo
        [~, oveja_maxima] = max(distancias_centro);
        
        % Calcular la dirección de movimiento del pastor hacia la oveja más alejada
        direccion = (ovejas(oveja_maxima,:) - pastores(i,:)) / norm(ovejas(oveja_maxima,:) - pastores(i,:));
        
        % Actualizar la posición del pastor
        nueva_posicion = pastores(i,:) + velocidad_pastores * direccion;
        
        % Verificar la restricción de distancia mínima entre pastores
        distancias_otros_pastores = vecnorm(nueva_posicion - pastores([1:i-1, i+1:end],:), 2, 2);
        if all(distancias_otros_pastores >= distancia_minima_pastores)
            pastores(i,:) = nueva_posicion;
        end
    end
    
    % Actualizar las posiciones de las ovejas basándose en la fuerza de repulsión de los pastores
    for i = 1:num_ovejas
        fuerza_repulsion_total = zeros(1, 2);
        for j = 1:num_pastores
            distancia_pastor_oveja = norm(pastores(j,:) - ovejas(i,:));
            direccion_repulsion = (ovejas(i,:) - pastores(j,:)) / distancia_pastor_oveja;
            fuerza_repulsion = factor_repulsion * direccion_repulsion / (distancia_pastor_oveja^2);
            fuerza_repulsion_total = fuerza_repulsion_total + fuerza_repulsion;
        end
        ovejas(i,:) = ovejas(i,:) + fuerza_repulsion_total;
    end
    
    % Evaluar la función objetivo
    aptitud_actual = funcion_objetivo4(ovejas, pastores, radio_objetivo, distancia_minima_pastores);
    
    % Actualizar la mejor solución si se encuentra una mejor
    if aptitud_actual < mejor_aptitud
        mejor_solucion = pastores;
        mejor_aptitud = aptitud_actual;
    end
    
    % Mostrar las posiciones de las ovejas, los pastores y el centro de masa en cada iteración
    clf;
    hold on;
    plot(ovejas(:,1), ovejas(:,2), 'bo', 'MarkerSize', 10);
    plot(pastores(:,1), pastores(:,2), 'r*', 'MarkerSize', 12);
    plot(centro_masa_ovejas(1), centro_masa_ovejas(2), 'kx', 'MarkerSize', 12, 'LineWidth', 2);
    viscircles([0 0], radio_objetivo, 'Color', 'g');
    xlim([-3 3]);
    ylim([-3 3]);
    xlabel('Eje X');
    ylabel('Eje Y');
    title(sprintf('Iteración %d', iter));
    legend('Ovejas', 'Pastores', 'Centro de Masa', 'Objetivo');
    drawnow;
end

% Mostrar las posiciones finales de las ovejas, los pastores y el centro de masa
disp('Posiciones finales:');
disp('Ovejas:');
disp(ovejas);
disp('Pastores:');
disp(mejor_solucion);
disp('Centro de Masa de las Ovejas:');
disp(mean(ovejas));