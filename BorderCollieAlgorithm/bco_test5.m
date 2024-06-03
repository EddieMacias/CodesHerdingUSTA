% Parámetros de inicialización
n = 50; % número total de individuos
d = 2; % dimensiones (x, y)
max_iters = 1000;
radius = 1;

% Inicialización de la población
Popt = rand(n, d) * 2 - 1; % posiciones aleatorias entre -1 y 1
Vt = zeros(n, d); % velocidad inicial
Acct = rand(n, d); % aceleración inicial
Timet = rand(n, 1); % tiempo inicial
k = 0;

for t = 1:max_iters
    Eyeing = 0;
    % Calcular aptitud (distancia al origen)
    fitt = sum(Popt.^2, 2);
    
    % Verificar mejora de aptitud
    if t > 1 && min(fitt) < min(fitt_prev)
        k = k + 1;
    else
        k = 0;
    end
    
    if k == 5
        Eyeing = 1;
        k = 0;
    end
    
    % Identificar perros (3 mejores individuos)
    [sorted_fitt, indices] = sort(fitt);
    LeadDog = Popt(indices(1), :);
    RightDog = Popt(indices(2), :);
    LeftDog = Popt(indices(3), :);
    Sheep = Popt(indices(4:end), :);
    
    % Actualizar velocidad de los perros
    Vt(indices(1), :) = rand(1, d) .* (LeadDog - Popt(indices(1), :));
    Vt(indices(2), :) = rand(1, d) .* (RightDog - Popt(indices(2), :));
    Vt(indices(3), :) = rand(1, d) .* (LeftDog - Popt(indices(3), :));
    
    % Actualizar posición de los perros
    Popt(indices(1), :) = Popt(indices(1), :) + Vt(indices(1), :);
    Popt(indices(2), :) = Popt(indices(2), :) + Vt(indices(2), :);
    Popt(indices(3), :) = Popt(indices(3), :) + Vt(indices(3), :);
    
    % Actualizar velocidad de las ovejas
    for i = 4:n
        if Eyeing == 1
            Vt(indices(i), :) = rand(1, d) .* (LeadDog - Popt(indices(i), :));
        else
            Vt(indices(i), :) = rand(1, d) .* (mean(Popt(indices(1:3), :)) - Popt(indices(i), :));
        end
    end
    
    % Actualizar posición de las ovejas
    for i = 4:n
        Popt(indices(i), :) = Popt(indices(i), :) + Vt(indices(i), :);
    end
    
    % Restringir posiciones a un círculo de radio 1
    dist = sqrt(sum(Popt.^2, 2));
    outside = dist > radius;
    Popt(outside, :) = Popt(outside, :) ./ dist(outside);
    
    % Guardar aptitud previa
    fitt_prev = fitt;
    
    % Verificar condición de término
    if all(dist <= radius)
        break;
    end
% Visualización del resultado
figure;
plot(Popt(:, 1), Popt(:, 2), 'bo'); % Ovejas
hold on;
plot(Popt(indices(1:3), 1), Popt(indices(1:3), 2), 'ro'); % Perros
viscircles([0 0], radius, 'LineStyle', '--'); % Circunferencia de radio 1
axis equal;
title('Optimización de Border Collie');
xlabel('x');
ylabel('y');
legend('Ovejas', 'Perros', 'Circunferencia de radio 1');
drawnow;



end


