% Parámetros de la simulación
num_drones = 5; % Número de drones
tiempo_simulacion = 10; % Tiempo total de simulación en segundos
dt = 0.1; % Paso de tiempo en segundos
densidad = 5e5; % Densidad de drones por metro cúbico

% Posiciones iniciales aleatorias de los drones
posiciones = rand(num_drones, 3); % Coordenadas x, y, z aleatorias entre 0 y 1

% Simulación del movimiento de los drones
for t = 0:dt:tiempo_simulacion
    % Calcula la velocidad media de los drones en función de la densidad
    velocidad_media = densidad * 0.1; % Ajusta el factor según sea necesario
    
    % Actualiza las posiciones de los drones en función de su velocidad media
    posiciones = posiciones + velocidad_media * dt * randn(num_drones, 3);
    
    % Limita las posiciones de los drones al espacio entre 0 y 1 (opcional)
    posiciones = min(max(posiciones, 0), 1);
    
    % Gráfica de los drones en cada paso de tiempo
    scatter3(posiciones(:, 1), posiciones(:, 2), posiciones(:, 3), 'filled');
    xlim([0 1]); ylim([0 1]); zlim([0 1]); % Ajusta los límites de los ejes
    xlabel('X'); ylabel('Y'); zlabel('Z'); % Etiquetas de los ejes
    title(sprintf('Simulación de enjambre de drones (tiempo = %.1f s)', t));
    drawnow; % Actualiza la gráfica
end
