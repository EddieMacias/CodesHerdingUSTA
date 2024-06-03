% Función para dibujar el gridworld y el movimiento del agente
function dibujar_gridworld(estado, num_filas, num_columnas, R,max_recompensa)
    clf;
    grid on;
    axis([0 num_columnas 0 num_filas]);
    set(gca, 'XTick', 0:num_columnas, 'YTick', 0:num_filas);
    hold on;

    num_estados = num_filas*num_columnas;
    
    % Dibujar los estados con colores según sus valores de recompensa
    for i = 1:num_filas
        for j = 1:num_columnas
            estado_actual = sub2ind([num_filas, num_columnas], i, j);
            
            if estado_actual == max_recompensa
                color = 'g';  % Verde para el estado objetivo
            elseif any(R(estado_actual, :) > 0)
                color = 'y';  % Amarillo para las posiciones de recompensa
            elseif any(R(estado_actual, :) < -1)
                 color = 'b';  % Azul para las posiciones de recompensa negativa
            else
                color = 'w';  % Blanco para los demás estados
            end
            
            rectangle('Position', [j-1 num_filas-i 1 1], 'FaceColor', color);
        end
    end
    
    % Dibujar el agente en el estado actual
    [fila, columna] = ind2sub([num_filas, num_columnas], estado);
    plot(columna - 0.5, num_filas - fila + 0.5, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    
    drawnow;
end