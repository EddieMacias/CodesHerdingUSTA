clc

num_boids = 4;

range_x = [-2.5, 2.5];
range_y = [-2.5, 2.5];

trees = [1.65,  1.60; 
         1.95, -1.55];

positions = [-0.5 -0.5; 
              0.5 -0.5; 
              0.5  0.5; 
             -0.5  0.5];

leader = [0 0];

shepherds = [-2.0  -2.3;        %up
             -1.0  -2.3;        %left
             0.0   -2.3;        %down
             1.0   -2.3];       %right

boidAlt  = 0.51;

velocities = rand(num_boids, 2) - 0.5;

num_iterations              = 300;
cohesion_factor             = 0.02;
separation_factor           = 0.05;
alignment_factor            = 0.01;
obstacle_avoidance_factor   = 0.3;
shepherds_avoidance_factor  = 0.4;
shepherd_approach_distance  = 0.5;
separation_radius           = 0.1;
obstacle_radius             = 0.4;

leader_avoidande_factor    = 0.2;
leader_separation_distance = 0.5;  
leader_vel_factor          = 0.04;
leader_obstatcle_factor    = 0.1; 
leader_velocity            = rand(1, 2) - 0.5;

trajectory01 = zeros(num_iterations,3);
trajectory02 = zeros(num_iterations,3);
trajectory03 = zeros(num_iterations,3);
trajectory04 = zeros(num_iterations,3);
trajectory05 = zeros(num_iterations,3);

%Array para verificar trayectorias pastores
trajectory06 = zeros(num_iterations,3);
trajectory07 = zeros(num_iterations,3);
trajectory09 = zeros(num_iterations,3);
trajectory10 = zeros(num_iterations,3);

%Array para vcerificar targets
targets_trj1 = zeros(num_iterations,2);
targets_trj2 = zeros(num_iterations,2);
targets_trj3 = zeros(num_iterations,2);
targets_trj4 = zeros(num_iterations,2);

% tiempo de desarrollo
running_time = zeros(num_iterations,1);

velocity_L = [0, 0];
velocity_R = [0, 0];
velocity_U = [0, 0];
velocity_D = [0, 0];

% Conectar a CoppeliaSim
sim = remApi('remoteApi');
sim.simxFinish(-1);
clientID = sim.simxStart('127.0.0.1',19999,true,true,5000,5);

% Verificar la conexión
if (clientID > -1)
    disp('Conectado a CoppeliaSim');
    
    % Obtener el handle del target del cuadricóptero
    [res1, target_handle1]   = sim.simxGetObjectHandle(clientID, 'Quadcopter_target',   sim.simx_opmode_blocking);
    [res2, target_handle2]   = sim.simxGetObjectHandle(clientID, 'Quadcopter_target#0', sim.simx_opmode_blocking);
    [res3, target_handle3]   = sim.simxGetObjectHandle(clientID, 'Quadcopter_target#1', sim.simx_opmode_blocking);
    [res4, target_handle4]   = sim.simxGetObjectHandle(clientID, 'Quadcopter_target#2', sim.simx_opmode_blocking);

    [res5, target_handle5]   = sim.simxGetObjectHandle(clientID, 'Quadcopter_target#3', sim.simx_opmode_blocking);

    [res7, target_handle7]   = sim.simxGetObjectHandle(clientID, 'Quadcopter_target#4', sim.simx_opmode_blocking);
    [res8, target_handle8]   = sim.simxGetObjectHandle(clientID, 'Quadcopter_target#5', sim.simx_opmode_blocking);
    [res9, target_handle9]   = sim.simxGetObjectHandle(clientID, 'Quadcopter_target#6', sim.simx_opmode_blocking);
    [res10, target_handle10] = sim.simxGetObjectHandle(clientID, 'Quadcopter_target#7', sim.simx_opmode_blocking);

    if (res1  == sim.simx_return_ok && ...
        res2  == sim.simx_return_ok && ...
        res3  == sim.simx_return_ok && ...
        res4  == sim.simx_return_ok && ...
        res5  == sim.simx_return_ok && ...
        res7  == sim.simx_return_ok && ...
        res8  == sim.simx_return_ok && ...
        res9  == sim.simx_return_ok && ...
        res10 == sim.simx_return_ok )

        disp('Handle del target obtenido correctamente');

       for t = 1:num_iterations
           tic;


           % conexion Enjambre 01
        
            %algoritmo Boid
            center_of_mass = leader;
            obstacles   = trees;
            obstacles_U = [trees; shepherds(2,:);shepherds(3,:);shepherds(4,:);positions;leader];
            obstacles_D = [trees; shepherds(1,:);shepherds(2,:);shepherds(4,:);positions;leader];
            obstacles_L = [trees; shepherds(1,:);shepherds(3,:);shepherds(4,:);positions;leader];
            obstacles_R = [trees; shepherds(1,:);shepherds(2,:);shepherds(3,:);positions;leader];

            trajectory01 (t,:) = [positions(1,:), boidAlt];
            trajectory02 (t,:) = [positions(2,:), boidAlt];
            trajectory03 (t,:) = [positions(3,:), boidAlt];
            trajectory04 (t,:) = [positions(4,:), boidAlt];

            trajectory05 (t,:) = [leader, boidAlt];

            trajectory06 (t,:) = [shepherds(1,:), boidAlt];
            trajectory07 (t,:) = [shepherds(2,:), boidAlt];
            trajectory09 (t,:) = [shepherds(3,:), boidAlt];
            trajectory10 (t,:) = [shepherds(4,:), boidAlt];

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
                    velocities(i,:) = velocities(i,:) + cohesion + separation + alignment + avoidance + shepherds_avoidance + Leader_avoidance;
                    
                    % Limitar velocidad máxima
                    max_speed = 0.05;
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

             % Evitar obstáculos Lider
            Leader_avoidance = zeros(1,2);
            for k = 1:size(obstacles, 1)
                dist_to_obstacle = norm(leader - obstacles(k,:));
                if dist_to_obstacle < obstacle_radius+0.1
                    Leader_avoidance = Leader_avoidance + (leader - obstacles(k,:)) / dist_to_obstacle^2;
                end
            end                    
            Leader_avoidance = Leader_avoidance * leader_obstatcle_factor;


            % Evitar Pastores LIDER
            Leader_shepherds_avoidance = zeros(1,2);
            for k = 1:size(shepherds, 1)
                dist_to_shepherds = norm(leader - shepherds(k,:));
                if dist_to_shepherds < shepherd_approach_distance
                    Leader_shepherds_avoidance = Leader_shepherds_avoidance + (leader - shepherds(k,:)) / dist_to_shepherds^2;
                end
            end
            Leader_shepherds_avoidance = Leader_shepherds_avoidance * shepherds_avoidance_factor;

            leader_velocity = leader_velocity + Leader_avoidance + Leader_shepherds_avoidance;

            % Limitar velocidad máxima
            max_speed_leader = leader_vel_factor;
            speed_leader = norm(leader_velocity);
            if speed_leader > max_speed_leader
                leader_velocity = leader_velocity * max_speed_leader / speed_leader;
            end

            leader = leader + leader_velocity;
            
            if(leader(1) < range_x(1))
                leader_velocity = RotateLeaderPosition([1 0], "L");
            elseif leader(1) > range_x(2)
                leader_velocity = RotateLeaderPosition([1 0], "R");
            elseif leader(2) < range_y(1)
                leader_velocity = RotateLeaderPosition([1 0], "D");
            elseif leader(2) > range_y(2)
                leader_velocity = RotateLeaderPosition([1 0], "U");
            end

            % calcular posiciones de referencia para pastores
            % shepherds_refs = [positions; leader];
            % X_pos = sort(shepherds_refs(:,1));
            % Y_pos = sort(shepherds_refs(:,2));       
            % R_pos  = X_pos(length(X_pos));
            % L_pos  = X_pos(1);
            % U_pos  = Y_pos(length(Y_pos));
            % D_pos  = Y_pos(1);
            % pos = find(shepherds_refs(:,1)==R_pos);
            % target_R = [shepherds_refs(pos(1),1)+ 0.5, shepherds_refs(pos(1),2)];
            % pos = find(shepherds_refs(:,1)==L_pos);
            % target_L = [shepherds_refs(pos(1),1)- 0.5, shepherds_refs(pos(1),2)];
            % pos = find(shepherds_refs(:,2)==U_pos);         
            % target_U = [shepherds_refs(pos(1),1), shepherds_refs(pos(1),2)+0.5];
            % pos = find(shepherds_refs(:,2)==D_pos);         
            % target_D = [shepherds_refs(pos(1),1), shepherds_refs(pos(1),2)-0.5];
            % Target = [target_R ; target_L; target_U ;target_D]  ;
            shepherds_refs = [positions; leader];
            [target_R, target_L, target_D, target_U] = getTarget(shepherds_refs, [0,0]);
            Target = [target_R ; target_L; target_D; target_U]; 

            targets_trj1(t,:) = target_U;
            targets_trj2(t,:) = target_L;
            targets_trj3(t,:) = target_D;
            targets_trj4(t,:) = target_R;


            %pastor posicion Superior
            pastor_U    = shepherds(1,:);
            cohesion_U  = (target_U - pastor_U) * cohesion_factor;
            alignment_U = mean(velocity_U) * alignment_factor;

            avoidance_U = zeros(1,2); 
            for k = 1:size(obstacles_U, 1)
                dist_to_obstacle = norm(pastor_U - obstacles_U(k,:));
                if dist_to_obstacle < obstacle_radius
                    avoidance_U = avoidance_U + (pastor_U - obstacles_U(k,:)) / dist_to_obstacle^2;
                end
            end
            avoidance_U = avoidance_U * obstacle_avoidance_factor;

            velocity_U = velocity_U + cohesion_U + alignment_U + avoidance_U;
            max_speed_U = 0.07;
            speed_U = norm(velocity_U);
            if speed_U > max_speed_U
                velocity_U = velocity_U * max_speed_U / speed_U;
            end

            pastor_U = pastor_U + velocity_U;
            dist_to_target = norm(pastor_U - target_U);
            if dist_to_target < separation_radius
                pastor_U = target_U;
                velocity_U = [0,0];
            end
            shepherds(1,:) = pastor_U;


            %pastor posicion Izquierda
            pastor_L = shepherds(2,:);
            cohesion_L = (target_L - pastor_L) * cohesion_factor;
            alignment_L = mean(velocity_L) * alignment_factor;

            avoidance_L = zeros(1,2); 
            for k = 1:size(obstacles_L, 1)
                dist_to_obstacle = norm(pastor_L - obstacles_L(k,:));
                if dist_to_obstacle < obstacle_radius
                    avoidance_L = avoidance_L + (pastor_L - obstacles_L(k,:)) / dist_to_obstacle^2;
                end
            end
            avoidance_L = avoidance_L * obstacle_avoidance_factor;

            velocity_L = velocity_L + cohesion_L + alignment_L + avoidance_L;
            max_speed_L = 0.07;
            speed_L = norm(velocity_L);
            if speed_L > max_speed_L
                velocity_L = velocity_L * max_speed_L / speed_L;
            end

            pastor_L = pastor_L + velocity_L;
            dist_to_target = norm(pastor_L - target_L);
            if dist_to_target < separation_radius
                pastor_L = target_L;
                velocity_L = [0,0];
            end
            shepherds(2,:) = pastor_L;

            %pastor posicion Derecha
            pastor_R = shepherds(4,:);
            cohesion_R = (target_R - pastor_R) * cohesion_factor;
            alignment_R = mean(velocity_R) * alignment_factor;

            avoidance_R = zeros(1,2); 
            for k = 1:size(obstacles_R, 1)
                dist_to_obstacle = norm(pastor_R - obstacles_R(k,:));
                if dist_to_obstacle < obstacle_radius
                    avoidance_R = avoidance_R + (pastor_R - obstacles_R(k,:)) / dist_to_obstacle^2;
                end
            end
            avoidance_R = avoidance_R * obstacle_avoidance_factor;

            velocity_R = velocity_R + cohesion_R + alignment_R + avoidance_R;
            max_speed_R = 0.07;
            speed_R = norm(velocity_R);
            if speed_R > max_speed_R
                velocity_R = velocity_R * max_speed_R / speed_R;
            end

            pastor_R = pastor_R + velocity_R;
            dist_to_target = norm(pastor_R - target_R);
            if dist_to_target < separation_radius
                pastor_R = target_R;
                velocity_R = [0,0];
            end
            shepherds(4,:) = pastor_R;

             %pastor posicion Inferior
            pastor_D = shepherds(3,:);
            cohesion_D = (target_D - pastor_D) * cohesion_factor;
            alignment_D = mean(velocity_D) * alignment_factor;

            avoidance_D = zeros(1,2); 
            for k = 1:size(obstacles_D, 1)
                dist_to_obstacle = norm(pastor_D - obstacles_D(k,:));
                if dist_to_obstacle < obstacle_radius
                    avoidance_D = avoidance_D + (pastor_D - obstacles_D(k,:)) / dist_to_obstacle^2;
                end
            end
            avoidance_D = avoidance_D * obstacle_avoidance_factor;

            velocity_D = velocity_D + cohesion_D + alignment_D + avoidance_D;
            max_speed_D = 0.07;
            speed_D = norm(velocity_D);
            if speed_D > max_speed_D
                velocity_D = velocity_D * max_speed_D / speed_D;
            end

            pastor_D = pastor_D + velocity_D;
            dist_to_target = norm(pastor_D - target_D);
            if dist_to_target < separation_radius
                pastor_D = target_D;
                velocity_D = [0,0];
            end
            shepherds(3,:) = pastor_D;

            target_pos  = [positions(1,1), positions(1,2), boidAlt];
            target_pos1 = [positions(2,1), positions(2,2), boidAlt];
            target_pos2 = [positions(3,1), positions(3,2), boidAlt];
            target_pos3 = [positions(4,1), positions(4,2), boidAlt];
            target_pos4 = [leader(1), leader(2), boidAlt];

            target_pos6 = [shepherds(1,1), shepherds(1,2), boidAlt];
            target_pos7 = [shepherds(2,1), shepherds(2,2), boidAlt];
            target_pos8 = [shepherds(3,1), shepherds(3,2), boidAlt];
            target_pos9 = [shepherds(4,1), shepherds(4,2), boidAlt];

            [res1]  = sim.simxSetObjectPosition(clientID, target_handle1,  -1, target_pos, sim.simx_opmode_blocking);
            [res2]  = sim.simxSetObjectPosition(clientID, target_handle2,  -1, target_pos1, sim.simx_opmode_blocking);
            [res3]  = sim.simxSetObjectPosition(clientID, target_handle3,  -1, target_pos2, sim.simx_opmode_blocking);
            [res4]  = sim.simxSetObjectPosition(clientID, target_handle4,  -1, target_pos3, sim.simx_opmode_blocking);

            [res5]  = sim.simxSetObjectPosition(clientID, target_handle5,  -1, target_pos4, sim.simx_opmode_blocking);

            [res7]  = sim.simxSetObjectPosition(clientID, target_handle7,  -1, target_pos6, sim.simx_opmode_blocking);
            [res8]  = sim.simxSetObjectPosition(clientID, target_handle8,  -1, target_pos7, sim.simx_opmode_blocking);
            [res9]  = sim.simxSetObjectPosition(clientID, target_handle9,  -1, target_pos8, sim.simx_opmode_blocking);
            [res10] = sim.simxSetObjectPosition(clientID, target_handle10, -1, target_pos9, sim.simx_opmode_blocking);
            
            running_time(t) = toc;

            % scatter(positions(:,1), positions(:,2), 'filled');
            % hold on;
            % scatter(trees(:,1), trees(:,2), 'red', 'filled');
            % scatter(center_of_mass(1),center_of_mass(2),'green','filled')
            % scatter(Target(:,1),Target(:,2),'c','filled')
            % scatter(shepherds(:,1), shepherds(:,2),'magenta','filled')
            % rectangle('Position', [-1, -1, 2, 2], 'EdgeColor', 'blue');
            % grid on
            % grid minor
            % xlim(range_x);
            % ylim(range_y);
            % hold off;
            % drawnow;

            
            if (res1 == sim.simx_return_ok && ...
                res2 == sim.simx_return_ok && ...
                res3 == sim.simx_return_ok && ...
                res4 == sim.simx_return_ok && ...
                res5 == sim.simx_return_ok )
                
                %disp('Posición del target establecida correctamente');
                
                % Esperar un tiempo para que el cuadricóptero alcance el target
                pause(0.1);
                
                %disp('El cuadricóptero ha alcanzado el target');
            else
                disp('Error al establecer la posición del target');
            end
       end
        
    else
        disp('Error al obtener el handle del target');
    end
    
    % Detener la simulación y cerrar la conexión con coppelia
    sim.simxStopSimulation(clientID, sim.simx_opmode_blocking);
    sim.simxFinish(clientID);
    sim.delete();
    
    disp('Simulación detenida y conexión cerrada');
    
else
    disp('Error al conectar con CoppeliaSim');
end

close all;
plotTajectories
checkROI
checkShepherds
runningTime