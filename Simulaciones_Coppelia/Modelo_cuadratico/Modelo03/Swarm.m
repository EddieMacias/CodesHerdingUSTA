clc
close all
% configurar espacio de trabajo
addpath('CoppeliaFcn\')
addpath('QLearnFcn\')
addpath('Gridworld\')
addpath('AuxFcn\')

%Definciones
%numero de Eploradores en el terreno
num_boids = 5;

% punto de interes 
poi = [0,0];

%tamaño del tablero
range_x = [-2.5, 2.5];
range_y = [-2.5, 2.5];

%posiciones de obstaculos
trees = [1.65,  1.60; 
         1.95, -1.55];

%posiciones iniciales de exploradores
positions = [-0.5 -0.5; 
              0.5 -0.5; 
              0.0  0.0; 
             -0.5  0.5; 
              0.5  0.5];

%posiciones inciales de los Pastores
shepherds = [-2.0  -2.3;       %up
             -1.0  -2.3;       %left
              0.0  -2.3;       %down
              1.0  -2.3];      %right

%altura de trabajo en m
boidAlt  = 0.51;

%velocidad inicial de los exploradores
velocities = rand(num_boids, 2) - 0.5;

%velocidad inicial de los pastores
velocity_L = [0, 0];
velocity_R = [0, 0];
velocity_U = [0, 0];
velocity_D = [0, 0];

%factores para leyes de reynolds
num_iterations              = 300;
cohesion_factor             = 0.02;
separation_factor           = 0.05;
alignment_factor            = 0.01;
obstacle_avoidance_factor   = 0.3;
shepherds_avoidance_factor  = 0.4;
shepherd_approach_distance  = 0.5;
separation_radius           = 0.1;
obstacle_radius             = 0.3;

%Array para verificar trayectorias Ovejas
trajectory01 = zeros(num_iterations,3);
trajectory02 = zeros(num_iterations,3);
trajectory03 = zeros(num_iterations,3);
trajectory04 = zeros(num_iterations,3);
trajectory05 = zeros(num_iterations,3);

%Array para verificar trayectorias Ovejas
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


% Parametros para Q_Learning
tam_tablero_Q           = 20;
num_filas               = tam_tablero_Q+1;
num_columnas            = tam_tablero_Q+1;
num_estados             = num_filas * num_columnas;
num_acciones            = 4;
gamma                   = 0.9;
alpha                   = 0.8;
epsilon                 = 0.1;
factor_entrenamiento    = 2;
num_episodios           = num_estados*tam_tablero_Q*factor_entrenamiento;
training_time           = zeros(num_episodios,1);
steps_QBoard            = 5/tam_tablero_Q;
Q_board                 = createBoardTable(2.5,steps_QBoard);

% Inicializar la tabla Q con valores aleatorios
Q_L  = rand(num_estados, num_acciones);
Q_U = rand(num_estados, num_acciones);
Q_D  = rand(num_estados, num_acciones);
Q_R = rand(num_estados, num_acciones);

%Array para verificar trayectorias pastores
Acciones_pastor_L = zeros(num_estados,1);
Acciones_pastor_U = zeros(num_estados,1);
Acciones_pastor_R = zeros(num_estados,1);
Acciones_pastor_D = zeros(num_estados,1);

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
    [res6, target_handle6]   = sim.simxGetObjectHandle(clientID, 'MassCenter',          sim.simx_opmode_blocking);
    [res7, target_handle7]   = sim.simxGetObjectHandle(clientID, 'Quadcopter_target#4', sim.simx_opmode_blocking);
    [res8, target_handle8]   = sim.simxGetObjectHandle(clientID, 'Quadcopter_target#5', sim.simx_opmode_blocking);
    [res9, target_handle9]   = sim.simxGetObjectHandle(clientID, 'Quadcopter_target#6', sim.simx_opmode_blocking);
    [res10, target_handle10] = sim.simxGetObjectHandle(clientID, 'Quadcopter_target#7', sim.simx_opmode_blocking);

    if (res1  == sim.simx_return_ok && ...
        res2  == sim.simx_return_ok && ...
        res3  == sim.simx_return_ok && ...
        res4  == sim.simx_return_ok && ...
        res5  == sim.simx_return_ok && ...
        res6  == sim.simx_return_ok && ...
        res7  == sim.simx_return_ok && ...
        res8  == sim.simx_return_ok && ...
        res9  == sim.simx_return_ok && ...
        res10 == sim.simx_return_ok  )
        disp('Handle del target obtenido correctamente');

       for t = 1:num_iterations
           tic

           % conexion Enjambre 01        
            %algoritmo Boid
            center_of_mass = mean(positions);
            obstacles   = trees;
            obstacles_U = [trees; shepherds(2,:);shepherds(3,:);shepherds(4,:);positions];
            obstacles_D = [trees; shepherds(1,:);shepherds(2,:);shepherds(4,:);positions];
            obstacles_L = [trees; shepherds(1,:);shepherds(3,:);shepherds(4,:);positions];
            obstacles_R = [trees; shepherds(1,:);shepherds(2,:);shepherds(3,:);positions];

            trajectory01 (t,:) = [positions(1,:), boidAlt];
            trajectory02 (t,:) = [positions(2,:), boidAlt];
            trajectory03 (t,:) = [positions(3,:), boidAlt];
            trajectory04 (t,:) = [positions(4,:), boidAlt];
            trajectory05 (t,:) = [positions(5,:), boidAlt];

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
                    velocities(i,:) = velocities(i,:) + cohesion + separation + alignment + avoidance + shepherds_avoidance;
                    
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
               
                    % % calcular posiciones de referencia para pastores
                    % X_pos = sort(positions(:,1));
                    % Y_pos = sort(positions(:,2));       
                    % R_pos  = X_pos(length(X_pos));
                    % L_pos  = X_pos(1);
                    % U_pos  = Y_pos(length(Y_pos));
                    % D_pos  = Y_pos(1);
                    % 
                    % tolerance = 0.5+steps_QBoard;
                    % 
                    % pos = find(positions(:,1)==R_pos);
                    % target_R = [positions(pos(1),1)+tolerance, positions(pos(1),2)];
                    % 
                    % pos = find(positions(:,1)==L_pos);
                    % target_L = [positions(pos(1),1)-tolerance, positions(pos(1),2)];
                    % 
                    % pos = find(positions(:,2)==U_pos);   
                    % target_U = [positions(pos(1),1), positions(pos(1),2)+tolerance ];   
                    % 
                    % pos = find(positions(:,2)==D_pos);   
                    % target_D = [positions(pos(1),1), positions(pos(1),2)-tolerance];
                    % 
                    % Target = [target_R ; target_L; target_U ;target_D];   
           
                end

                target_pos  = [positions(1,1), positions(1,2), boidAlt];
                target_pos1 = [positions(2,1), positions(2,2), boidAlt];
                target_pos2 = [positions(3,1), positions(3,2), boidAlt];
                target_pos3 = [positions(4,1), positions(4,2), boidAlt];
                target_pos4 = [positions(5,1), positions(5,2), boidAlt];
                [res1]  = sim.simxSetObjectPosition(clientID, target_handle1,  -1, target_pos, sim.simx_opmode_blocking);
                [res2]  = sim.simxSetObjectPosition(clientID, target_handle2,  -1, target_pos1, sim.simx_opmode_blocking);
                [res3]  = sim.simxSetObjectPosition(clientID, target_handle3,  -1, target_pos2, sim.simx_opmode_blocking);
                [res4]  = sim.simxSetObjectPosition(clientID, target_handle4,  -1, target_pos3, sim.simx_opmode_blocking);
                [res5]  = sim.simxSetObjectPosition(clientID, target_handle5,  -1, target_pos4, sim.simx_opmode_blocking);

                target_pos5 = [center_of_mass(1), center_of_mass(2), boidAlt];
                [res6]  = sim.simxSetObjectPosition(clientID, target_handle6,  -1, target_pos5, sim.simx_opmode_blocking);


            % -------------------------------------------------------------------------------------------------------
            % Targets
            [target_R, target_L, target_D, target_U] = getTarget(positions, poi);
            Target = [target_R ; target_L; target_D; target_U]; 

            targets_trj1(t,:) = target_U;
            targets_trj2(t,:) = target_L;
            targets_trj3(t,:) = target_D;
            targets_trj4(t,:) = target_R;


            % -------------------------------------------------------------------------------------------------------
            % Q-LEarning E-geedy policy target_U
            % Definir la matriz de castigos
            num_castigos_U        = length(obstacles_U);
            posiciones_castigos_U = zeros(1,num_castigos_U);

            for castigo=1:num_castigos_U
                coordinate = [obstacles_U(castigo,1),obstacles_U(castigo,2)];
                posiciones_castigos_U(castigo) = searchCoordinateOnTable(coordinate,Q_board,steps_QBoard); 
            end
            pos_Agent_U = searchCoordinateOnTable(shepherds(1,:),Q_board,steps_QBoard);

            max_recompensa_U      = searchCoordinateOnTable(target_U,Q_board,steps_QBoard);

            [R_U, max_recompensa_U]= GenerarMatrizR(posiciones_castigos_U,...
                                                    max_recompensa_U,...
                                                    num_filas,...
                                                    num_estados, ...
                                                    num_acciones, ...
                                                    pos_Agent_U);

            % Entrenamiento del agente utilizando Q-Learning
            % politica epsilon-greedy 
            %Q_U = rand(num_estados, num_acciones);
            [Q_U, training_time_U] = TrainAgent(num_episodios, ...
                                              num_estados, ...
                                              max_recompensa_U, ...
                                              Q_U, ...
                                              epsilon, ...
                                              num_acciones, ...
                                              num_filas, ...
                                              num_columnas, ...
                                              R_U, ...
                                              alpha, ...
                                              gamma);

            %Actuaciones del agente entrenado con limitacion de Movimientos
            estado =  searchCoordinateOnTable(shepherds(1,:),Q_board,steps_QBoard);
            [Acciones_pastor_U , cnt] = GetAgentRoute(estado,num_acciones,Q_U,num_filas,num_columnas,max_recompensa_U);

            if cnt > 1   
                for acciones=1:2 
                    accion = Acciones_pastor_U(acciones);
                    xycoord = SearchIndexOnTable(Q_board,accion);
                    coord = [xycoord boidAlt];
                    [res11] = sim.simxSetObjectPosition(clientID, target_handle7, -1, coord, sim.simx_opmode_blocking);
                    shepherds(1,:) = xycoord;
                end
            end

            % ------------------------------------------------------------------------------------------------------------------------
            % Q-LEarning E-geedy policy Target_L
            num_castigos_L        = length(obstacles_L);
            posiciones_castigos_L = zeros(1,num_castigos_L);

            for castigo=1:num_castigos_L
                coordinate = [obstacles_L(castigo,1),obstacles_L(castigo,2)];
                posiciones_castigos_L(castigo) = searchCoordinateOnTable(coordinate,Q_board,steps_QBoard); 
            end
            pos_Agent_L = searchCoordinateOnTable(shepherds(2,:),Q_board,steps_QBoard);

            max_recompensa_L = searchCoordinateOnTable(target_L, ...
                                                       Q_board, ...
                                                       steps_QBoard);

            [R_L, max_recompensa_L]  = GenerarMatrizR(posiciones_castigos_L,...
                                                      max_recompensa_L,...
                                                      num_filas,...
                                                      num_estados, ...
                                                      num_acciones, ...
                                                      pos_Agent_L);

            % Entrenamiento del agente utilizando Q-Learning
            % politica epsilon-greedy
            %act  = searchCoordinateOnTable(shepherds(2,:),Q_board,steps_QBoard); % evitar entrenamiento mientras estoy en la posision deseada
            %Q_L = rand(num_estados, num_acciones);
            [Q_L, training_time_L] = TrainAgent(num_episodios, ...
                                                num_estados, ...
                                                max_recompensa_L, ...
                                                Q_L, ...
                                                epsilon, ...
                                                num_acciones, ...
                                                num_filas, ...
                                                num_columnas, ...
                                                R_L, ...
                                                alpha, ...
                                                gamma);

            %Actuaciones del agente entrenado con limitacion de Movimientos
            estado                    =  searchCoordinateOnTable(shepherds(2,:),Q_board,steps_QBoard);
            [Acciones_pastor_L , cnt] = GetAgentRoute(estado,num_acciones,Q_L,num_filas,num_columnas,max_recompensa_L);

            if cnt > 1   
                for acciones=1:2 
                    accion = Acciones_pastor_L(acciones);
                    xycoord = SearchIndexOnTable(Q_board,accion);
                    coord = [xycoord boidAlt];
                    [res11] = sim.simxSetObjectPosition(clientID, target_handle8, -1, coord, sim.simx_opmode_blocking);
                    shepherds(2,:) = xycoord;
                end
            end
             
            % ------------------------------------------------------------------------------------------------------------------------
            % Q-LEarning E-geedy policy Target_D
            num_castigos_D        = length(obstacles_D);
            posiciones_castigos_D = zeros(1,num_castigos_D);

            for castigo=1:num_castigos_D
                coordinate = [obstacles_D(castigo,1),obstacles_D(castigo,2)];
                posiciones_castigos_D(castigo) = searchCoordinateOnTable(coordinate,Q_board,steps_QBoard); 
            end
            pos_Agent_D = searchCoordinateOnTable(shepherds(3,:),Q_board,steps_QBoard);

            max_recompensa_D = searchCoordinateOnTable(target_D, ...
                                                       Q_board, ...
                                                       steps_QBoard);

           [R_D, max_recompensa_D]  = GenerarMatrizR(posiciones_castigos_D,...
                                                     max_recompensa_D,...
                                                     num_filas,...
                                                     num_estados, ...
                                                     num_acciones, ...
                                                     pos_Agent_D);

            % Entrenamiento del agente utilizando Q-Learning
            % politica epsilon-greedy
            %act  = searchCoordinateOnTable(shepherds(3,:),Q_board,steps_QBoard); % evitar entrenamiento mientras estoy en la posision deseada
            %Q_D = rand(num_estados, num_acciones);
            [Q_D, training_time_D] = TrainAgent(num_episodios, ...
                                                num_estados, ...
                                                max_recompensa_D, ...
                                                Q_D, ...
                                                epsilon, ...
                                                num_acciones, ...
                                                num_filas, ...
                                                num_columnas, ...
                                                R_D, ...
                                                alpha, ...
                                                gamma);

            %Actuaciones del agente entrenado con limitacion de Movimientos
            estado                    =  searchCoordinateOnTable(shepherds(3,:),Q_board,steps_QBoard);
            [Acciones_pastor_D , cnt] = GetAgentRoute(estado,num_acciones,Q_D,num_filas,num_columnas,max_recompensa_D);

            if cnt > 1   
                for acciones=1:2 
                    accion = Acciones_pastor_D(acciones);
                    xycoord = SearchIndexOnTable(Q_board,accion);
                    coord = [xycoord boidAlt];
                    [res11] = sim.simxSetObjectPosition(clientID, target_handle9, -1, coord, sim.simx_opmode_blocking);
                    shepherds(3,:) = xycoord;
                end
            end
             
            % ------------------------------------------------------------------------------------------------------------------------
            % Q-LEarning E-geedy policy Target_R
            num_castigos_R        = length(obstacles_R);
            posiciones_castigos_R = zeros(1,num_castigos_R);

            for castigo=1:num_castigos_R
                coordinate = [obstacles_R(castigo,1),obstacles_R(castigo,2)];
                posiciones_castigos_R(castigo) = searchCoordinateOnTable(coordinate,Q_board,steps_QBoard); 
            end
            pos_Agent_R = searchCoordinateOnTable(shepherds(4,:),Q_board,steps_QBoard);

            max_recompensa_R = searchCoordinateOnTable(target_R, ...
                                                       Q_board, ...
                                                       steps_QBoard);

            [R_R, max_recompensa_R]  = GenerarMatrizR(posiciones_castigos_R,...
                                                      max_recompensa_R,...
                                                      num_filas,...
                                                      num_estados, ...
                                                      num_acciones, ...
                                                      pos_Agent_R);

            % Entrenamiento del agente utilizando Q-Learning
            % politica epsilon-greedy
            %act  = searchCoordinateOnTable(shepherds(4,:),Q_board,steps_QBoard); % evitar entrenamiento mientras estoy en la posision deseada
            %Q_R = rand(num_estados, num_acciones);
            [Q_R, training_time_R] = TrainAgent(num_episodios, ...
                                                num_estados, ...
                                                max_recompensa_R, ...
                                                Q_R, ...
                                                epsilon, ...
                                                num_acciones, ...
                                                num_filas, ...
                                                num_columnas, ...
                                                R_R, ...
                                                alpha, ...
                                                gamma);

            %Actuaciones del agente entrenado con limitacion de Movimientos
            estado                    =  searchCoordinateOnTable(shepherds(4,:),Q_board,steps_QBoard);
            [Acciones_pastor_R , cnt] = GetAgentRoute(estado,num_acciones,Q_R,num_filas,num_columnas,max_recompensa_R);

            if cnt > 1   
                for acciones=1:2 
                    accion = Acciones_pastor_R(acciones);
                    xycoord = SearchIndexOnTable(Q_board,accion);
                    coord = [xycoord boidAlt];
                    [res11] = sim.simxSetObjectPosition(clientID, target_handle10, -1, coord, sim.simx_opmode_blocking);
                    shepherds(4,:) = xycoord;
                end
            end
             
            % ------------------------------------------------------------------------------------------------------------------------
              
            target_pos6 = [shepherds(1,1), shepherds(1,2), boidAlt];
            target_pos7 = [shepherds(2,1), shepherds(2,2), boidAlt];
            target_pos8 = [shepherds(3,1), shepherds(3,2), boidAlt];
            target_pos9 = [shepherds(4,1), shepherds(4,2), boidAlt];
            [res7]  = sim.simxSetObjectPosition(clientID, target_handle7,  -1, target_pos6, sim.simx_opmode_blocking);
            [res8]  = sim.simxSetObjectPosition(clientID, target_handle8,  -1, target_pos7, sim.simx_opmode_blocking);
            [res9]  = sim.simxSetObjectPosition(clientID, target_handle9,  -1, target_pos8, sim.simx_opmode_blocking);
            [res10] = sim.simxSetObjectPosition(clientID, target_handle10, -1, target_pos9, sim.simx_opmode_blocking);
            
            running_time(t) = toc + sum(training_time_R) + sum(training_time_L) + sum(training_time_U) + sum(training_time_D);
            
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
                res5 == sim.simx_return_ok && ...
                res6 == sim.simx_return_ok)
                
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