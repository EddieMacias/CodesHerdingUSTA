% Función para actualizar las posiciones de las ovejas según el algoritmo de Boids
function estados_ovejas_actualizados = actualizar_posiciones_ovejas(estados_ovejas, estados_pastores, num_filas, ...
                                                                    num_columnas,num_ovejas,distancia_separacion,...
                                                                    distancia_cohesion,separacion,alineacion,cohesion)

    [filas_ovejas, columnas_ovejas] = ind2sub([num_filas, num_columnas], estados_ovejas);
    [filas_pastores, columnas_pastores] = ind2sub([num_filas, num_columnas], estados_pastores);
    
    velocidades = zeros(num_ovejas, 2);
    
    for i = 1:num_ovejas
        % Calcular la separación
        separacion_fila = 0;
        separacion_columna = 0;
        for j = 1:num_ovejas
            if i ~= j
                distancia = sqrt((filas_ovejas(i) - filas_ovejas(j))^2 + (columnas_ovejas(i) - columnas_ovejas(j))^2);
                if distancia < distancia_separacion
                    separacion_fila = separacion_fila + (filas_ovejas(i) - filas_ovejas(j));
                    separacion_columna = separacion_columna + (columnas_ovejas(i) - columnas_ovejas(j));
                end
            end
        end
        
        % Calcular la separación de los pastores (obstáculos)
        separacion_pastores_fila = 0;
        separacion_pastores_columna = 0;
        for j = 1:length(estados_pastores)
            distancia = sqrt((filas_ovejas(i) - filas_pastores(j))^2 + (columnas_ovejas(i) - columnas_pastores(j))^2);
            if distancia < distancia_separacion
                separacion_pastores_fila = separacion_pastores_fila + (filas_ovejas(i) - filas_pastores(j));
                separacion_pastores_columna = separacion_pastores_columna + (columnas_ovejas(i) - columnas_pastores(j));
            end
        end
        
        % Calcular la alineación
        alineacion_fila = mean(filas_ovejas) - filas_ovejas(i);
        alineacion_columna = mean(columnas_ovejas) - columnas_ovejas(i);
        
        % Calcular la cohesión
        cohesion_fila = 0;
        cohesion_columna = 0;
        num_vecinos = 0;
        for j = 1:num_ovejas
            if i ~= j
                distancia = sqrt((filas_ovejas(i) - filas_ovejas(j))^2 + (columnas_ovejas(i) - columnas_ovejas(j))^2);
                if distancia < distancia_cohesion
                    cohesion_fila = cohesion_fila + filas_ovejas(j);
                    cohesion_columna = cohesion_columna + columnas_ovejas(j);
                    num_vecinos = num_vecinos + 1;
                end
            end
        end
        if num_vecinos > 0
            cohesion_fila = cohesion_fila / num_vecinos - filas_ovejas(i);
            cohesion_columna = cohesion_columna / num_vecinos - columnas_ovejas(i);
        end
        
        % Actualizar la velocidad
velocidades(i, 1) = separacion * sum(separacion_fila) + alineacion * sum(alineacion_fila) + cohesion * sum(cohesion_fila) + separacion * sum(separacion_pastores_fila);
velocidades(i, 2) = separacion * sum(separacion_columna) + alineacion * sum(alineacion_columna) + cohesion * sum(cohesion_columna) + separacion * sum(separacion_pastores_columna);
    end
    
    % Actualizar las posiciones de las ovejas
    filas_ovejas = filas_ovejas + velocidades(:, 1);
    columnas_ovejas = columnas_ovejas + velocidades(:, 2);
    
    % Mantener las ovejas dentro de los límites del entorno
    filas_ovejas = max(min(filas_ovejas, num_filas), 1);
    columnas_ovejas = max(min(columnas_ovejas, num_columnas), 1);
    
    estados_ovejas_actualizados = sub2ind([num_filas, num_columnas], round(filas_ovejas), round(columnas_ovejas));
end