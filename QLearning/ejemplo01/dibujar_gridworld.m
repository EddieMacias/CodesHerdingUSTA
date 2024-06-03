% Función para dibujar el gridworld y el movimiento del agente
function dibujar_gridworld(estado,rutas_perdidas)
    clf;
    grid on;
    axis([0 5 0 5]);
    set(gca, 'XTick', 0:5, 'YTick', 0:5);
    hold on;
    
    % Dibujar los estados con colores según sus valores de recompensa
    for i = 1:5
        for j = 1:5
            estado_actual = sub2ind([5, 5], i, j);
            
            if ismember(estado_actual, rutas_perdidas)
                color = 'k';  % Negro para las rutas con pérdidas (-10)
            elseif estado_actual == 25
                color = 'g';  % Verde para el estado objetivo
            else
                color = 'y';  % Amarillo para los estados con costo de movimiento (-1)
            end
            
            rectangle('Position', [j-1 5-i 1 1], 'FaceColor', color);
        end
    end
    
    % Dibujar el agente en el estado actual
    [fila, columna] = ind2sub([5, 5], estado);
    plot(columna - 0.5, 5 - fila + 0.5, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    
    drawnow;
end