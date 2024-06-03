 %
 % @brief Modelo de Reynolds para creacion de un enjambre basado en 
 %        algoritmo Boids
 %

close all;   

% Dimensiones de la ventana
WINDOW_WIDTH  = 1366;
WINDOW_HEIGHT = 766;

% numero maximo de iteraciones
max_iter = 300;

% Número de boids
num_boids = 4;

% Crea los boids con posiciones y velocidades aleatorias
positions = rand(num_boids, 2) .* [WINDOW_WIDTH, WINDOW_HEIGHT];
velocities = rand(num_boids, 2) .* 2 - 1;  % Velocidades en el rango [-1, 1]

% Crea el líder con posición en el centro y velocidad cero
%leader_position = [WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2];
leader_position = [200 , 200];

% parametro velocidad inicial lider
leader_velocity = [0, 0];

% Parámetros para las reglas de separación, alineación y cohesión entre
% enjambre
separation_radius = 100;
alignment_radius  = 115;
cohesion_radius   = 40;

% Parámetros para Pastores
Herding_positions = [200, 600; 700,550; 1200,200];                          %Posiciones Iniciales de los pastores
Herding_radii     = [80; 80; 80];

% Parámetros para la fuerza de evasión de obstáculos
obstacle_positions  = [150, 300; 450, 450; 600, 100];                        % Posiciones de los obstáculos
obstacle_radii      = [20; 30; 20];                                          % Radios de los obstáculos
obstacle_avoidance_strength = 0.6;

% generando los obstaculos para los boids
obstacle_positions = vertcat(obstacle_positions,Herding_positions);
obstacle_radii = vertcat(obstacle_radii,Herding_radii);   

% Parámetro para la fuerza de seguimiento del líder
follow_leader_strength = 0.1;

% Parámetro para la velocidad del líder
leader_strength = 2;

%vector de evasion del lider
Leader_avoidance_vector = [0 0];
Leader_obstacle_avoidance_strength = 0.03;

% Parámetro para la distancia mínima que los boids deben mantener del líder
min_distance_to_leader = 140;

% Vector para simulacion 3D
X = zeros(num_boids+4,2);
X(1:num_boids,:) = positions;
X(num_boids+1,:) = leader_position;
X(num_boids+2 : length(X),:) = Herding_positions;

% Tiempo de actualización
dt = 2.5;

% Crea una nueva figura con elementos 3D
scene=figure;                                                               % new figure
tam = [100 100 WINDOW_WIDTH WINDOW_HEIGHT];
set(scene,'position',[tam(1) tam(2) tam(3) tam(4)]);                        % position and size figure in the screen
axis equal;                                                                 % Set axis aspect ratios
axis([0 WINDOW_WIDTH 0 WINDOW_HEIGHT -5 200]);                              % Set axis limits 
Az = 135;
El = 30;
view([Az El]); 
grid on;  
grid minor;                                                                 % Display axes grid lines
xlabel('X')
ylabel('Y')
zlabel('Z')
SwarmFcn;                                                                   % Parameters of robot
M1=swarmPlot(X,obstacle_positions);                                         % Plot robot in initial position hx,hy and phi orientation
camlight('rigth');

iter = 0;

while true
    % Borra grafico de los voids         
    delete(M1);  

    % Calcula la regla de separación, alineación y cohesión para cada boid
    for i = 1:num_boids

        separation = [0, 0];
        separation_count = 0;

        alignment = [0, 0];
        alignment_count = 0;

        cohesion = [0, 0];
        cohesion_count = 0;

        for j = 1:num_boids
            if i ~= j

                distance = norm(positions(i, :) - positions(j, :));

                % Regla de cohesión
                if distance < cohesion_radius
                    cohesion = cohesion + positions(j, :);
                    cohesion_count = cohesion_count + 1;
                end

                % Regla de alineación
                if distance < alignment_radius
                    alignment = alignment + velocities(j, :);
                    alignment_count = alignment_count + 1;
                end

                % Regla de separación
                if distance < separation_radius
                    diff = positions(i, :) - positions(j, :);
                    separation = separation + diff / norm(diff);
                    separation_count = separation_count + 1;
                end

            end
        end

        % Aplica las reglas para calcular la nueva velocidad
        if separation_count > 0
            separation = separation / separation_count;
        end

        if alignment_count > 0
            alignment = alignment / alignment_count;
        end

        if cohesion_count > 0
            cohesion = (cohesion / cohesion_count - positions(i, :)) / cohesion_radius;
        end

        % Aplica la fuerza de evasión de obstáculos
        avoidance_force = [0, 0];
        for k = 1:length(obstacle_positions)
            diff = positions(i, :) - obstacle_positions(k, :);
            distance_to_obstacle = norm(diff) - obstacle_radii(k);
            if distance_to_obstacle < separation_radius
                avoidance_force = avoidance_force + diff / norm(diff) * (separation_radius - distance_to_obstacle);
            end
        end
        avoidance_force = avoidance_force * obstacle_avoidance_strength;

        % Aplica la fuerza de seguimiento del líder
        follow_leader = (leader_position - positions(i, :)) * follow_leader_strength;

        % Calcula la fuerza para mantener distancia del líder
        diff_to_leader = positions(i, :) - leader_position;
        distance_to_leader = norm(diff_to_leader);
        if distance_to_leader < min_distance_to_leader
            repulsion_from_leader = diff_to_leader / distance_to_leader * (min_distance_to_leader - distance_to_leader);
            velocities(i, :) = velocities(i, :) + repulsion_from_leader;
        end

        % Velocidad final
        velocities(i, :) = velocities(i, :) + separation + alignment + cohesion + avoidance_force + follow_leader;

        % Limita la velocidad para evitar movimientos demasiado rápidos
        max_speed = 2;
        speed = norm(velocities(i, :));
        if speed > max_speed
            velocities(i, :) = velocities(i, :) / speed * max_speed;
        end

        % Actualiza la posición del boid
        positions(i, :) = positions(i, :) + velocities(i, :) * dt;
        
    end

    % Actualiza la Velocidad del lider posición del líder 
    leader_velocity = [1,1] * leader_strength;

    
    % Evasion de obstaculos del lider
    for i = 1:length(obstacle_positions)
        obstacle = obstacle_positions(i, :);
        distance_leader_to_obstacles = norm(leader_position-obstacle);

        if distance_leader_to_obstacles < separation_radius + 10
            angulo_rotacion = pi/4;
            Leader_avoidance_vector = RotateBoidPosition(leader_position, angulo_rotacion);
        end

         %evasion de obscaculos de lider con limites de ventana
         if leader_position(2)<separation_radius || leader_position(2)>WINDOW_HEIGHT-separation_radius
                angulo_rotacion = -pi/2;
                Leader_avoidance_vector = RotateBoidPosition(leader_position, angulo_rotacion);
         end

        if leader_position(1)<separation_radius || leader_position(1)>WINDOW_WIDTH-separation_radius
                angulo_rotacion = pi;
                Leader_avoidance_vector = RotateBoidPosition(leader_position, angulo_rotacion);
         end


    end
    
    % Actualiza la posición del líder 
    leader_position = leader_position + ...
                      Leader_avoidance_vector*Leader_obstacle_avoidance_strength +...
                      leader_velocity * dt;

    % graficas 3D
    X(1:num_boids,:)             = positions;
    X(num_boids+1,:)             = leader_position;
    X(num_boids+2 : length(X),:) = Herding_positions;

    M1 = swarmPlot(X,obstacle_positions);
    pause(0.1);
    iter = iter +1;

    if iter > max_iter
        break;
    end

end