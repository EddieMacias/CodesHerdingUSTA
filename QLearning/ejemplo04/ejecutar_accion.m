% Función para ejecutar la acción del pastor y obtener el siguiente estado y recompensa
function [siguiente_estado, recompensa] = ejecutar_accion(estado_actual, accion, estado_pastor, estados_ovejas, area_objetivo, area_vigilancia,num_filas,num_columnas)

    [fila, columna] = ind2sub([num_filas, num_columnas], estado_pastor);
    
    switch accion
        case 1 % Arriba
            fila = max(fila - 1, 1);
        case 2 % Abajo
            fila = min(fila + 1, num_filas);
        case 3 % Izquierda
            columna = max(columna - 1, 1);
        case 4 % Derecha
            columna = min(columna + 1, num_columnas);
    end
    
    siguiente_estado = sub2ind([num_filas, num_columnas], fila, columna);
    
    if strcmp(area_vigilancia, 'izquierda_superior')
        ovejas_en_area = estados_ovejas(estados_ovejas <= sub2ind([num_filas, num_columnas], area_objetivo(3), floor(num_columnas/2)));
    else
        ovejas_en_area = estados_ovejas(estados_ovejas > sub2ind([num_filas, num_columnas], area_objetivo(3), floor(num_columnas/2)));
    end
    
    if all(ismember(ovejas_en_area, area_objetivo(1):area_objetivo(3)))
        recompensa = 10;
    else
        recompensa = -1;
    end
end
