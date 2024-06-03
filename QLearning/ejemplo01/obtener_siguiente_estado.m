% Función para obtener el siguiente estado basado en la acción
function siguiente_estado = obtener_siguiente_estado(estado, accion)
    [fila, columna] = ind2sub([5, 5], estado);
    
    switch accion
        case 1  % Arriba
            fila = max(fila - 1, 1);
        case 2  % Abajo
            fila = min(fila + 1, 5);
        case 3  % Izquierda
            columna = max(columna - 1, 1);
        case 4  % Derecha
            columna = min(columna + 1, 5);
    end
    
    siguiente_estado = sub2ind([5, 5], fila, columna);
end