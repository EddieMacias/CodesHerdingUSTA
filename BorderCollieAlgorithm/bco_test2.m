% Parámetros del algoritmo
radio_objetivo = 1;
num_ovejas = 5;
num_pastores = 3;
num_iteraciones = 100;
velocidad_pastores = 0.1;

% Generar posiciones iniciales aleatorias para las ovejas
ovejas = -2.5 + 5 * rand(num_ovejas, 2);

% Generar posiciones iniciales aleatorias para los pastores
pastores = -2.5 + 5 * rand(num_pastores, 2);


% Inicializar la mejor solución y el mejor valor de aptitud
mejor_solucion = pastores;
mejor_aptitud = funcion_objetivo2(ovejas, pastores, radio_objetivo);

% Algoritmo de optimización Border Collie
for iter = 1:num_iteraciones
    % Calcular las distancias entre las ovejas y los pastores
    distancias_pastores = zeros(size(ovejas, 1), size(pastores, 1));
    for i = 1:size(ovejas, 1)
        for j = 1:size(pastores, 1)
            distancias_pastores(i,j) = norm(ovejas(i,:) - pastores(j,:));
        end
    end
    
    % Actualizar las posiciones de los pastores
    for i = 1:num_pastores
        % Encontrar la oveja más alejada del pastor actual
        [distancia_maxima, oveja_maxima] = max(distancias_pastores(:,i));
        
        % Calcular la dirección de movimiento del pastor hacia la oveja más alejada
        direccion = (ovejas(oveja_maxima,:) - pastores(i,:)) / distancia_maxima;
        
        % Actualizar la posición del pastor
        pastores(i,:) = pastores(i,:) + velocidad_pastores * direccion;
    end
    
    % Evaluar la función objetivo
    aptitud_actual = funcion_objetivo2(ovejas, pastores, radio_objetivo);
    
    % Actualizar la mejor solución si se encuentra una mejor
    if aptitud_actual < mejor_aptitud
        mejor_solucion = pastores;
        mejor_aptitud = aptitud_actual;
    end
    
    % Mostrar las posiciones de las ovejas y los pastores en cada iteración
    clf;
    hold on;
    plot(ovejas(:,1), ovejas(:,2), 'bo', 'MarkerSize', 10);
    plot(pastores(:,1), pastores(:,2), 'r*', 'MarkerSize', 12);
    viscircles([0 0], radio_objetivo, 'Color', 'g');
    xlim([-3 3]);
    ylim([-3 3]);
    xlabel('Eje X');
    ylabel('Eje Y');
    title(sprintf('Iteración %d', iter));
    legend('Ovejas', 'Pastores', 'Objetivo');
    drawnow;
end

% Mostrar las posiciones finales de las ovejas y los pastores
disp('Posiciones finales:');
disp('Ovejas:');
disp(ovejas);
disp('Pastores:');
disp(mejor_solucion);