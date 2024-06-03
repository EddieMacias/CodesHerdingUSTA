% Parámetros iniciales
n = 100; % número de individuos
d = 2; % dimensiones (2D)
max_iterations = 1000;
radius = 1;

% Inicialización de posiciones, velocidades, aceleraciones y tiempos
positions = rand(n, d) * 5 - 2.5; % posiciones iniciales aleatorias en [-2.5, 2.5]
velocities = zeros(n, d); % velocidades iniciales
accelerations = rand(n, d); % aceleraciones iniciales aleatorias
times = rand(n, 1); % tiempos iniciales aleatorios

% Configuración de la figura para animación
figure;
hold on;
theta = linspace(0, 2*pi, 100);
x = cos(theta);
y = sin(theta);
plot(x, y, 'r--'); % circunferencia de radio 1
scatter_plot = scatter(positions(:, 1), positions(:, 2), 'b'); % posiciones de los individuos
title('Optimización BCO');
xlabel('X');
ylabel('Y');
axis equal;
axis([-2.5 2.5 -2.5 2.5]);

% Ejecución del algoritmo BCO
for t = 1:max_iterations
    % Calcular fitness de cada individuo (distancia al origen)
    fitness = sqrt(sum(positions.^2, 2));
    
    % Ordenar individuos por fitness
    [~, idx] = sort(fitness);
    positions = positions(idx, :);
    velocities = velocities(idx, :);
    accelerations = accelerations(idx, :);
    times = times(idx, :);
    
    % Designar los perros (3 mejores individuos)
    lead_dog = positions(1, :);
    left_dog = positions(2, :);
    right_dog = positions(3, :);
    
    % Actualizar velocidades, aceleraciones y posiciones de los perros
    velocities(1, :) = sqrt(velocities(1, :).^2 + 2 * accelerations(1, :) .* positions(1, :));
    velocities(2, :) = sqrt(velocities(2, :).^2 + 2 * accelerations(2, :) .* positions(2, :));
    velocities(3, :) = sqrt(velocities(3, :).^2 + 2 * accelerations(3, :) .* positions(3, :));
    
    accelerations(1, :) = (velocities(1, :) - velocities(1, :)) ./ times(1);
    accelerations(2, :) = (velocities(2, :) - velocities(2, :)) ./ times(2);
    accelerations(3, :) = (velocities(3, :) - velocities(3, :)) ./ times(3);
    
    positions(1, :) = velocities(1, :) .* times(1) + 0.5 * accelerations(1, :) .* times(1).^2;
    positions(2, :) = velocities(2, :) .* times(2) + 0.5 * accelerations(2, :) .* times(2).^2;
    positions(3, :) = velocities(3, :) .* times(3) + 0.5 * accelerations(3, :) .* times(3).^2;
    
    % Mantener a los perros fuera del círculo de radio 1
    for i = 1:3
        if norm(positions(i, :)) < radius
            direction = positions(i, :) / norm(positions(i, :));
            positions(i, :) = direction * (radius + 0.1 + rand); % Colocar fuera del radio 1
        end
    end
    
    % Actualizar posiciones, velocidades y aceleraciones de las ovejas
    for i = 4:n
        velocities(i, :) = sqrt(velocities(i, :).^2 + 2 * accelerations(i, :) .* positions(i, :));
        accelerations(i, :) = (velocities(i, :) - velocities(i, :)) ./ times(i);
        positions(i, :) = velocities(i, :) .* times(i) + 0.5 * accelerations(i, :) .* times(i).^2;
    end
    
    % Restringir las posiciones a una circunferencia de radio 1
    for i = 1:n
        if norm(positions(i, :)) > radius
            positions(i, :) = positions(i, :) / norm(positions(i, :)) * radius;
        end
    end
    
    % Actualizar la visualización
    drawnow;
end

hold off;
