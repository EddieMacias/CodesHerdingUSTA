% Definir parámetros
num_boids = 5;

range_x = [-2.25, 2.25];
range_y = [-2.25, 2.25];
obstacles = [1.65, 1.6; 
            1.95, -1.55];



shepherds_avoidance_factor  = 0.4;
shepherd_approach_distance  = 0.5;
separation_radius           = 0.1;

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


% Parámetros del algoritmo Boids
cohesion_factor = 0.02;
separation_factor = 0.05;
alignment_factor = 0.01;
obstacle_avoidance_factor = 0.1;

% Simulación

for t = 1:num_iterations
    % Calcular centro de masa
    center_of_mass = mean(positions);

    trj1 (t,:)=positions(1,:);
    trj2 (t,:)=positions(2,:);
    trj3 (t,:)=positions(3,:);
    trj4 (t,:)=positions(4,:);
    trj5 (t,:)=positions(5,:);

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

    X_pos = sort(positions(:,1));
    L_pos  = X_pos(1);
    pos = find(positions(:,1)==L_pos);
    target_L = [positions(pos(1),1)-0.5, positions(pos(1),2)];

    
    % Visualización (opcional)
    scatter(positions(:,1), positions(:,2),100, "magenta",'filled');
     hold on;
    % scatter(obstacles(:,1), obstacles(:,2),200 ,'r', 'filled');
    % scatter(shepherds(:,1), shepherds(:,2),200 ,'blue', 'filled');
    plot(trj1(1:t,1),trj1(1:t,2));
    plot(trj2(1:t,1),trj2(1:t,2));
    plot(trj3(1:t,1),trj3(1:t,2));
    plot(trj4(1:t,1),trj4(1:t,2));
    plot(trj5(1:t,1),trj5(1:t,2));
    xlim(range_x);
    ylim(range_y);
    grid on
    grid minor
    hold off;
    title('Prueba algoritmo Boids')
    % legend('boids','obstacles','Location','NorthEastOutside','Orientation','vertical')
    drawnow;
end
