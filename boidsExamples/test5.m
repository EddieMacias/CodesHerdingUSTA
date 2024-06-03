%% con optimizacion de distancias
tic

% Definir parámetros
num_boids = 5;

range_x = [-2.25, 2.25];
range_y = [-2.25, 2.25];
obstacles = [1.65, 1.6; 
            1.95, -1.55];


obstacle_radius = 0.3;
num_iterations = 300;

trj1=zeros(num_iterations,2);
trj2=zeros(num_iterations,2);
trj3=zeros(num_iterations,2);
trj4=zeros(num_iterations,2);
trj5=zeros(num_iterations,2);

% Inicializar posiciones y velocidades de los boids
positions = rand(num_boids, 2) .* [(range_x(2)-range_x(1)), (range_y(2)-range_y(1))] + [range_x(1), range_y(1)];
velocities = rand(num_boids, 2) - 0.5;
shepherds = rand(1, 2) .* [(range_x(2)-range_x(1)), (range_y(2)-range_y(1))] + [range_x(1), range_y(1)];
velocity_S = rand(1, 2) - 0.5;

% Parámetros del algoritmo Boids sheep
cohesion_factor   = 0.02;
separation_factor = 0.05;
alignment_factor  = 0.01;
obstacle_avoidance_factor = 0.1;

% Parámetros del algoritmo Boids shepperd
shepherds_avoidance_factor  = 0.7;
shepherd_approach_distance  = 0.5;
separation_radius           = 0.05;



% Simulación
for t = 1:num_iterations
    % Calcular centro de masa
    center_of_mass = mean(positions);

    trj1 (t,:)=positions(1,:);
    trj2 (t,:)=positions(2,:);
    trj3 (t,:)=positions(3,:);
    trj4 (t,:)=positions(4,:);
    trj5 (t,:)=positions(5,:);
    trj6 (t,:)=shepherds;

    % Calcular dirección de movimiento para cada boid
    for i = 1:num_boids
        % Regla de cohesión
        cohesion = (center_of_mass - positions(i,:)) * cohesion_factor;
        
        % Regla de separación
        separation = zeros(1,2);
        for j = 1:num_boids
            if i ~= j
                dist = norm(positions(i,:) - positions(j,:));
                if dist < 0.1 % Evitar división por cero
                    separation = separation + rand(1,2); % Aplicar un pequeño alejamiento aleatorio
                elseif dist < 0.5
                    separation = separation - (positions(j,:) - positions(i,:)) / dist^2;
                end
            end
        end
        separation = separation * separation_factor;
        
        % Regla de alineación
        alignment = mean(velocities) * alignment_factor;
        
        % Evitar obstáculos
        avoidance = zeros(1,2);
        for k = 1:size(obstacles, 1)
            dist_to_obstacle = norm(positions(i,:) - obstacles(k,:));
            if dist_to_obstacle < obstacle_radius
                avoidance = avoidance + (positions(i,:) - obstacles(k,:)) / dist_to_obstacle^2;
            end
        end
        avoidance = avoidance * obstacle_avoidance_factor;

	    % Evitar Pastores
        shepherds_avoidance = zeros(1,2);
        for k = 1:size(shepherds, 1)
            dist_to_shepherds = norm(positions(i,:) - shepherds(k,:));
            if dist_to_shepherds < shepherd_approach_distance
                shepherds_avoidance = shepherds_avoidance + (positions(i,:) - shepherds(k,:)) / dist_to_shepherds^2;
            end
        end
        shepherds_avoidance = shepherds_avoidance * shepherds_avoidance_factor;
                    
        
        % Actualizar velocidad
        velocities(i,:) = velocities(i,:) + cohesion + separation + alignment + avoidance+shepherds_avoidance;
        
        % Limitar velocidad máxima
        max_speed = 0.1;
        speed = norm(velocities(i,:));
        if speed > max_speed
            velocities(i,:) = velocities(i,:) * max_speed / speed;
        end
        
        % Actualizar posición
        positions(i,:) = positions(i,:) + velocities(i,:);
        
        % Limitar posición dentro del rango
        positions(i,1) = min(max(positions(i,1), range_x(1)), range_x(2));
        positions(i,2) = min(max(positions(i,2), range_y(1)), range_y(2));
    end

    %optimization Problem
    %optim problem
    target_L = setOptimTarget(positions,'D',shepherds,0.2);
    obstacles_L = obstacles;

    
    % Movimientos Pastor
    pastor_L = shepherds;
    cohesion_L = (target_L - pastor_L) * cohesion_factor;
    alignment_L = mean(velocity_S) * alignment_factor;

    avoidance_L = zeros(1,2); 
    for k = 1:size(obstacles_L, 1)
        dist_to_obstacle = norm(pastor_L - obstacles_L(k,:));
        if dist_to_obstacle < obstacle_radius
            avoidance_L = avoidance_L + (pastor_L - obstacles_L(k,:)) / dist_to_obstacle^2;
        end
    end
    avoidance_L = avoidance_L * obstacle_avoidance_factor;

    velocity_S = velocity_S + cohesion_L + alignment_L + avoidance_L;
    max_speed_L = 0.07;
    speed_L = norm(velocity_S);
    if speed_L > max_speed_L
        velocity_S = velocity_S * max_speed_L / speed_L;
    end

    pastor_L = pastor_L + velocity_S;
    dist_to_target = norm(pastor_L - target_L);
    if dist_to_target < separation_radius
        pastor_L = target_L;
        velocity_S = [0,0];
    end
    shepherds = pastor_L;

    toc

    % Visualización (opcional)
    scatter(positions(:,1), positions(:,2),100, "magenta",'filled','Marker', 'hexagram');
    hold on;
    scatter(obstacles(:,1), obstacles(:,2),200 ,'r', 'filled');
    scatter(shepherds(:,1), shepherds(:,2),200 ,'blue', 'filled');
    scatter(target_L(1), target_L(2),'cyan','filled')
    plot(trj6(1:t,1),trj6(1:t,2));
    xlim(range_x);
    ylim(range_y);
    grid on
    grid minor
    hold off;
    title('Prueba algoritmo Boids con Pastores +  Optimdistance + obstaculos')
    legend('boids','obstaculos','pastor', 'target','Location','NorthEastOutside','Orientation','vertical')
    drawnow;
end
