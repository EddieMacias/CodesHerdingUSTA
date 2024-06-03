% Función para obtener el siguiente estado basado en la acción
function siguiente_estado = obtener_siguiente_estado(estado, accion, num_filas, num_columnas)
    [fila, columna] = ind2sub([num_filas, num_columnas], estado);
    
    switch accion
        case 1  % Arriba
            fila = max(fila - 1, 1);
        case 2  % Abajo
            fila = min(fila + 1, num_filas);
        case 3  % Izquierda
            columna = max(columna - 1, 1);
        case 4  % Derecha
            columna = min(columna + 1, num_columnas);
    end
    
    siguiente_estado = sub2ind([num_filas, num_columnas], fila, columna);
end