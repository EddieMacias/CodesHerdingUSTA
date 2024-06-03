% Definir parámetros
num_boids = 20;

range_x = [-2.25, 2.25];
range_y = [-2.25, 2.25];

obstacle_radius = 0.3;
num_iterations  = 300;

trj1=zeros(num_iterations,2);
trj2=zeros(num_iterations,2);
trj3=zeros(num_iterations,2);
trj4=zeros(num_iterations,2);
trj5=zeros(num_iterations,2);
trj6=zeros(num_iterations,2);

% Inicializar posiciones y velocidades de los boids
positions = rand(num_boids, 2) .* [(range_x(2)-range_x(1)), (range_y(2)-range_y(1))] + [range_x(1), range_y(1)];
velocities = rand(num_boids, 2) - 0.5;

leader = rand(1, 2) .* [(range_x(2)-range_x(1)), (range_y(2)-range_y(1))] + [range_x(1), range_y(1)];
leader_velocity = [1,1];

% Parámetros del algoritmo Boids
cohesion_factor = 0.02;
separation_factor = 0.05;
alignment_factor = 0.01;
obstacle_avoidance_factor = 0.1;

leader_avoidande_factor    = 0.2;
leader_separation_distance = 0.5;  
leader_vel_factor          = 0.08;


% Simulación

for t = 1:num_iterations
    % Calcular centro de masa
    center_of_mass = leader;

    trj1 (t,:)=positions(1,:);
    trj2 (t,:)=positions(2,:);
    trj3 (t,:)=positions(3,:);
    trj4 (t,:)=positions(4,:);
    trj6 (t,:)=leader;

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

        % Regla de separación de lider
        Leader_avoidance = zeros(1,2);
        for k = 1:size(leader, 1)
            dist_to_leader = norm(positions(i,:) - leader);
            if dist_to_leader < leader_separation_distance
                Leader_avoidance = Leader_avoidance + (positions(i,:) - leader) / dist_to_leader^2;
            end
        end
        Leader_avoidance = Leader_avoidance * leader_avoidande_factor;

        % Regla de alineación
        alignment = mean(velocities) * alignment_factor;                            
        
        % Actualizar velocidad
        velocities(i,:) = velocities(i,:) + cohesion + separation + alignment + Leader_avoidance;
        
        % Limitar velocidad máxima
        max_speed = 0.1;
        speed = norm(velocities(i,:));
        if speed > max_speed
            velocities(i,:) = velocities(i,:) * max_speed / speed;
        end
        
        % Actualizar posición boids
        positions(i,:) = positions(i,:) + velocities(i,:);
        
        % Limitar posición dentro del rango
        positions(i,1) = min(max(positions(i,1), range_x(1)), range_x(2));
        positions(i,2) = min(max(positions(i,2), range_y(1)), range_y(2));
    end

    leader = leader + (leader_velocity * leader_vel_factor);
    if(leader(1) < range_x(1))
        leader_velocity = RotateLeaderPosition([1 0], "L");
    elseif leader(1) > range_x(2)
        leader_velocity = RotateLeaderPosition([1 0], "R");
    elseif leader(2) < range_y(1)
        leader_velocity = RotateLeaderPosition([1 0], "D");
    elseif leader(2) > range_y(2)
        leader_velocity = RotateLeaderPosition([1 0], "U");
    end

    % Visualización (opcional)
    scatter(positions(:,1), positions(:,2),100, "magenta",'filled','Marker', 'hexagram');
    hold on;
    scatter(leader(1), leader(2),200 ,'c', 'filled');
    plot(trj6(1:t,1),trj6(1:t,2));
    xlim(range_x);
    ylim(range_y);
    grid on
    grid minor
    hold off;
    title('Prueba algoritmo Boids W leader')
    legend('boids','Leader','Location','NorthEastOutside','Orientation','vertical')
    drawnow;
end
