% Función para graficar las posiciones de los pastores y las ovejas
function graficar_posiciones(estados_pastores, estados_ovejas, num_filas, num_columnas, area_objetivo)
    clf;
    hold on;
    
    % Graficar el área objetivo
    rectangle('Position', [area_objetivo(1,2)-0.5, area_objetivo(1,1)-0.5, diff(area_objetivo(:,2))+1, diff(area_objetivo(:,1))+1], 'EdgeColor', 'r', 'LineWidth', 2);
    
    % Graficar las posiciones de los pastores
    [filas_pastores, columnas_pastores] = ind2sub([num_filas, num_columnas], estados_pastores);
    plot(columnas_pastores, filas_pastores, 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b');
    
    % Graficar las posiciones de las ovejas
    [filas_ovejas, columnas_ovejas] = ind2sub([num_filas, num_columnas], estados_ovejas);
    plot(columnas_ovejas, filas_ovejas, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
    
    xlim([0.5, num_columnas+0.5]);
    ylim([0.5, num_filas+0.5]);
    set(gca, 'YDir', 'reverse');
    grid on;
    xlabel('Columna');
    ylabel('Fila');
    title('Posiciones de Pastores y Ovejas');
    
    drawnow;
end