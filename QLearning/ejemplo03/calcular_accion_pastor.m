% Función para calcular la acción del pastor basada en las posiciones de las ovejas
function accion_pastor = calcular_accion_pastor(estado_pastor, estados_ovejas, num_filas, num_columnas, area_objetivo,num_acciones)
    [fila_pastor, columna_pastor] = ind2sub([num_filas, num_columnas], estado_pastor);
    
    % Verificar si el pastor está en el área objetivo
    if ismember(fila_pastor, area_objetivo(:, 1)) && ismember(columna_pastor, area_objetivo(:, 2))
        % Si el pastor está en el área objetivo, se mueve hacia afuera
        direccion_fila = sign(mean(area_objetivo(:, 1)) - fila_pastor);
        direccion_columna = sign(mean(area_objetivo(:, 2)) - columna_pastor);
    else
        % Calcular el centro del área objetivo
        centro_fila = mean(area_objetivo(:, 1));
        centro_columna = mean(area_objetivo(:, 2));
        
        % Calcular el centro de las posiciones de las ovejas
        [filas_ovejas, columnas_ovejas] = ind2sub([num_filas, num_columnas], estados_ovejas);
        centro_fila_ovejas = mean(filas_ovejas);
        centro_columna_ovejas = mean(columnas_ovejas);
        
        % Calcular la dirección hacia el centro de las ovejas
        direccion_fila_ovejas = sign(centro_fila_ovejas - fila_pastor);
        direccion_columna_ovejas = sign(centro_columna_ovejas - columna_pastor);
        
        % Calcular la dirección hacia el centro del área objetivo
        direccion_fila_objetivo = sign(centro_fila - fila_pastor);
        direccion_columna_objetivo = sign(centro_columna - columna_pastor);
        
        % Combinar las direcciones hacia las ovejas y el área objetivo
        direccion_fila = sign(direccion_fila_ovejas + direccion_fila_objetivo);
        direccion_columna = sign(direccion_columna_ovejas + direccion_columna_objetivo);
    end
    
    % Determinar la acción del pastor basada en la dirección combinada
    if direccion_fila == -1
        accion_pastor = 1;  % Arriba
    elseif direccion_fila == 1
        accion_pastor = 2;  % Abajo
    elseif direccion_columna == -1
        accion_pastor = 3;  % Izquierda
    elseif direccion_columna == 1
        accion_pastor = 4;  % Derecha
    else
        accion_pastor = randi(num_acciones);  % Acción aleatoria si está en el centro
    end
end