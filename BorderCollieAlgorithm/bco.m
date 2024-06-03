% Implementación del algoritmo BCO con 10 ovejas y 3 pastores

% Definir la función de aptitud (distancia euclidiana al objetivo)
fitnessFunction = @(x) sqrt(sum((x - target).^2));

% Definir los parámetros del algoritmo
numSheep = 10;
numDogs = 3;
dimension = 2;
maxIterations = 100;
lowerBound = -10;
upperBound = 10;

% Definir la posición objetivo
target = [5, 5];

% Inicializar las posiciones de las ovejas y los perros
sheep = lowerBound + (upperBound - lowerBound) .* rand(numSheep, dimension);
dogs = lowerBound + (upperBound - lowerBound) .* rand(numDogs, dimension);

% Inicializar las velocidades, aceleraciones y tiempos
velocity = zeros(numSheep + numDogs, dimension);
acceleration = rand(numSheep + numDogs, dimension);
time = rand(numSheep + numDogs, 1);

% Inicializar los ángulos de acecho para los perros izquierdo y derecho
theta1 = deg2rad(1);
theta2 = deg2rad(179);

% Inicializar el contador de iteraciones
iteration = 1;

% Bucle principal del algoritmo BCO
while iteration <= maxIterations
    % Calcular la aptitud de las ovejas y los perros
    sheepFitness = arrayfun(fitnessFunction, sheep);
    dogsFitness = arrayfun(fitnessFunction, dogs);
    
    % Encontrar el perro líder, izquierdo y derecho
    [~, leaderIndex] = min(dogsFitness);
    remainingDogs = setdiff(1:numDogs, leaderIndex);
    
    % Verificar si hay suficientes perros restantes
    if length(remainingDogs) >= 2
        leftIndex = remainingDogs(1);
        rightIndex = remainingDogs(2);
    else
        % Si no hay suficientes perros restantes, seleccionar el perro líder como izquierdo y derecho
        leftIndex = leaderIndex;
        rightIndex = leaderIndex;
    end
    
    % Actualizar las velocidades de los perros
    velocity(numSheep+leaderIndex, :) = sqrt(velocity(numSheep+leaderIndex, :).^2 + 2 .* acceleration(numSheep+leaderIndex, :) .* dogs(leaderIndex, :));
    velocity(numSheep+leftIndex, :) = sqrt(velocity(numSheep+leftIndex, :).^2 + 2 .* acceleration(numSheep+leftIndex, :) .* dogs(leftIndex, :));
    velocity(numSheep+rightIndex, :) = sqrt(velocity(numSheep+rightIndex, :).^2 + 2 .* acceleration(numSheep+rightIndex, :) .* dogs(rightIndex, :));
    
    % Actualizar las velocidades de las ovejas
    for i = 1:numSheep
        Dg = sheepFitness(i) - mean([dogsFitness(leftIndex), dogsFitness(rightIndex)]);
        
        if Dg > 0
            % Técnica de reunión (gathering)
            velocity(i, :) = sqrt(velocity(numSheep+leaderIndex, :).^2 + 2 .* acceleration(numSheep+leaderIndex, :) .* sheep(i, :));
        else
            % Técnica de acecho (stalking)
            vLeft = sqrt((velocity(numSheep+leftIndex, :) .* tan(theta1)).^2 + 2 .* acceleration(numSheep+leftIndex, :) .* dogs(leftIndex, :));
            vRight = sqrt((velocity(numSheep+rightIndex, :) .* tan(theta2)).^2 + 2 .* acceleration(numSheep+rightIndex, :) .* dogs(rightIndex, :));
            velocity(i, :) = (vLeft + vRight) / 2;
        end
    end
    
    % Actualizar las aceleraciones y los tiempos
    acceleration = (velocity - velocityPrev) ./ time;
    time = mean((velocity - velocityPrev) ./ acceleration, 2);
    
    % Actualizar las posiciones de los perros
    dogs(leaderIndex, :) = velocity(numSheep+leaderIndex, :) .* time(numSheep+leaderIndex) + 0.5 .* acceleration(numSheep+leaderIndex, :) .* time(numSheep+leaderIndex).^2;
    dogs(leftIndex, :) = velocity(numSheep+leftIndex, :) .* time(numSheep+leftIndex) + 0.5 .* acceleration(numSheep+leftIndex, :) .* time(numSheep+leftIndex).^2;
    dogs(rightIndex, :) = velocity(numSheep+rightIndex, :) .* time(numSheep+rightIndex) + 0.5 .* acceleration(numSheep+rightIndex, :) .* time(numSheep+rightIndex).^2;
    
    % Actualizar las posiciones de las ovejas
    sheep = sheep + velocity(1:numSheep, :) .* time(1:numSheep) + 0.5 .* acceleration(1:numSheep, :) .* time(1:numSheep).^2;
    
    % Incrementar el contador de iteraciones
    iteration = iteration + 1;
    
    % Guardar las velocidades anteriores
    velocityPrev = velocity;
end

% Graficar las posiciones finales de las ovejas, los perros y el objetivo
figure;
plot(sheep(:, 1), sheep(:, 2), 'bo', 'MarkerSize', 10);
hold on;
plot(dogs(:, 1), dogs(:, 2), 'rs', 'MarkerSize', 12, 'LineWidth', 2);
plot(target(1), target(2), 'k*', 'MarkerSize', 15, 'LineWidth', 2);
xlabel('Eje X');
ylabel('Eje Y');
title('Posiciones finales de las ovejas y los perros');
legend('Ovejas', 'Perros', 'Objetivo');
grid on;