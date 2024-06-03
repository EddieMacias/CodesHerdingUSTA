function [bestSolution, bestFitness] = BorderCollieOptimization(populationSize, dimension, maxIterations, lowerBound, upperBound, fitnessFunction)

% Initialize population
population = lowerBound + (upperBound - lowerBound) .* rand(populationSize, dimension);
velocity = zeros(populationSize, dimension);
acceleration = rand(populationSize, dimension);
time = rand(populationSize, 1);
velocityPrev = 0;

% Initialize plot
figure;
hold on;
xlabel('Iteration');
ylabel('Best Fitness');
title('Border Collie Optimization');

for t = 1:maxIterations
    % Evaluate fitness
    fitness = fitnessFunction(population);
    
    % Update eyeing status
    if t > 1 && bestFitness(t) < bestFitness(t-1)
        k = k + 1;
    else
        k = 0;
    end
    
    if k == 5
        eyeing = 1;
        k = 0;
    else
        eyeing = 0;
    end
    
    % Identify lead, left, and right dogs
    [~, leadDogIndex] = min(fitness);
    remainingDogs = setdiff(1:populationSize, leadDogIndex);
    if rand < 0.5
        leftDogIndex = remainingDogs(1);
        rightDogIndex = remainingDogs(2);
    else
        leftDogIndex = remainingDogs(2);
        rightDogIndex = remainingDogs(1);
    end
    
    % Update velocity and position of dogs
    velocity(leadDogIndex,:) = sqrt(velocity(leadDogIndex,:).^2 + 2 .* acceleration(leadDogIndex,:) .* population(leadDogIndex,:));
    velocity(rightDogIndex,:) = sqrt(velocity(rightDogIndex,:).^2 + 2 .* acceleration(rightDogIndex,:) .* population(rightDogIndex,:));
    velocity(leftDogIndex,:) = sqrt(velocity(leftDogIndex,:).^2 + 2 .* acceleration(leftDogIndex,:) .* population(leftDogIndex,:));
    
    % Update velocity and position of sheep
    for i = 1:populationSize
        if i ~= leadDogIndex && i ~= leftDogIndex && i ~= rightDogIndex
            if eyeing == 1
                velocity(i,:) = sqrt(velocity(leftDogIndex,:).^2 - 2 .* acceleration(leftDogIndex,:) .* population(leftDogIndex,:));
            else
                Dg = (fitness(leadDogIndex) - fitness(i)) - ((fitness(leftDogIndex) + fitness(rightDogIndex)) / 2 - fitness(i));
                if Dg > 0
                    velocity(i,:) = sqrt(velocity(leadDogIndex,:).^2 + 2 .* acceleration(leadDogIndex,:) .* population(i,:));
                else
                    velocityLeft = sqrt((velocity(leftDogIndex,:) .* tan(rand*pi/2)).^2 + 2 .* acceleration(leftDogIndex,:) .* population(leftDogIndex,:));
                    velocityRight = sqrt((velocity(rightDogIndex,:) .* tan(rand*pi/2)).^2 + 2 .* acceleration(rightDogIndex,:) .* population(rightDogIndex,:));
                    velocity(i,:) = (velocityLeft + velocityRight) / 2;
                end
            end
        end
    end
    
    % Update acceleration and time
    acceleration = (velocity - velocityPrev) ./ time;
    time = mean((velocity - velocityPrev) ./ acceleration, 2);
    
    % Update population
    population(leadDogIndex,:) = velocity(leadDogIndex,:) .* time(leadDogIndex) + 0.5 .* acceleration(leadDogIndex,:) .* time(leadDogIndex)^2;
    population(leftDogIndex,:) = velocity(leftDogIndex,:) .* time(leftDogIndex) + 0.5 .* acceleration(leftDogIndex,:) .* time(leftDogIndex)^2;
    population(rightDogIndex,:) = velocity(rightDogIndex,:) .* time(rightDogIndex) + 0.5 .* acceleration(rightDogIndex,:) .* time(rightDogIndex)^2;
    
    for i = 1:populationSize
        if i ~= leadDogIndex && i ~= leftDogIndex && i ~= rightDogIndex
            if eyeing == 1
                population(i,:) = velocity(i,:) .* time(i) - 0.5 .* acceleration(i,:) .* time(i)^2;
            else
                population(i,:) = velocity(i,:) .* time(i) + 0.5 .* acceleration(i,:) .* time(i)^2;
            end
        end
    end
    
    % Store best solution and fitness
    [bestFitness(t), bestIndex] = min(fitness);
    bestSolution(t,:) = population(bestIndex,:);
    
    % Plot current best fitness
    plot(t, bestFitness(t), 'ro');
    drawnow;
    
    % Update previous velocity
    velocityPrev = velocity;
end

end