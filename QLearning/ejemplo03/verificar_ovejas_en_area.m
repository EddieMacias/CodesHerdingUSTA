% Función para verificar si todas las ovejas están en el área objetivo
function todas_en_area = verificar_ovejas_en_area(estados_ovejas, area_objetivo, num_filas, num_columnas)
    todas_en_area = true;
    for i = 1:length(estados_ovejas)
        [fila, columna] = ind2sub([num_filas, num_columnas], estados_ovejas(i));
        if ~ismember(fila, area_objetivo(:, 1)) || ~ismember(columna, area_objetivo(:, 2))
            todas_en_area = false;
            break;
        end
    end
end