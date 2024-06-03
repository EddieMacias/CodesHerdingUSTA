% Q-LEarning E-geedy policy Target_L
% Definir la matriz de castigos
R_L = -1 * ones(num_estados, num_acciones);                % Costo de movimiento de -1 para cada acción

% Generar posiciones castigos
num_castigos_L        = length(obstacles_L);
posiciones_castigos_L   = zeros(1,num_castigos_L);

for castigo=1:num_castigos_L
    coordinate                   = [obstacles_L(castigo,1), obstacles_L(castigo,2)];
    posiciones_castigos_L(castigo) = searchCoordinateOnTable(coordinate,Q_board,steps_QBoard); 
    R_L(posiciones_castigos_L(castigo), :) = -100;          % Asignar un castigo de -100 a las posiciones seleccionadas
end

% Generar posiciones castigos en contornos de ovejas y obstaculos
castigos_auxiliares = zeros(num_estados,9);

for castigo_aux=1:length(posiciones_castigos_U)
    dat = posiciones_castigos_L(castigo_aux);

    if dat < num_filas +1                                            %primera Columna 

        castigos_auxiliares(castigo_aux,:) =  [dat,            dat,                dat   ...
                                               dat-1,          dat,                dat+1 ...
                                               dat+num_filas, (dat+num_filas)+1 , (dat+num_filas)-1];

    elseif dat >num_filas*20-1                                       %ultima Columna                                      
        castigos_auxiliares(castigo_aux,:) =  [dat,            dat,                dat   ...
                                               dat-1,          dat,                dat+1 ...
                                               dat-num_filas, (dat-num_filas)+1 , (dat-num_filas)-1];

    elseif mod(dat,num_filas) == 0                                   %ultima fila      
        castigos_auxiliares(castigo_aux,:) =  [dat,            dat,                dat           ...
                                               dat-num_filas,  dat,                dat+num_filas ...
                                               dat-1,         (dat-num_filas)-1 , (dat+num_filas)-1];

    elseif mod(dat-1,num_filas) == 0                                 %primera fila     
        castigos_auxiliares(castigo_aux,:) =  [dat,            dat,                dat           ...
                                               dat-num_filas,  dat,                dat+num_filas ...
                                               dat+1,         (dat-num_filas)+1,  (dat+num_filas)+1];

    else                                                             %valores internos 
        castigos_auxiliares(castigo_aux,:) = [(dat-num_filas)-1,    dat-1,         (dat+num_filas)-1 ...
                                               dat-num_filas,       dat,            dat+num_filas ...
                                              (dat-num_filas)+1,    dat+1,         (dat+num_filas)+1]; 
    end
end

for filas=1:length(posiciones_castigos_L)
    for columnas=1:9
        value = castigos_auxiliares(filas,columnas);
        R_L(value,:) = -100;
    end
end

% Generar Recompensa para pastor L
max_recompensa_L = searchCoordinateOnTable(target_L,Q_board,steps_QBoard);
R_L(max_recompensa_L, :) = 100;                                             % Recompensa positiva en el estado objetivo
           
% Entrenamiento del agente utilizando Q-Learning
% politica epsilon-greedy
act = searchCoordinateOnTable(shepherds(2,:),Q_board,steps_QBoard);         % evitar entrenamiento mientras estoy en la posision deseada
if act ~= max_recompensa_L                
    for episodio = 1:num_episodios
        estado = randi(num_estados);
         contador_estado = 0;
        while estado ~= max_recompensa_L
            accion = seleccionar_accion(estado, epsilon, num_acciones);
            siguiente_estado = obtener_siguiente_estado(estado, accion, num_filas, num_columnas);

            if estado == siguiente_estado
                contador_estado = contador_estado+1;
            end

            if contador_estado > 20000
                Q_L = rand(num_estados, num_acciones); % evitar saturacion tabla Q
                contador_estado = 0;
            end

            recompensa = R_L(estado, accion);
            actualizar_Q(estado, accion, siguiente_estado, recompensa, alpha, gamma);
            estado = siguiente_estado; 
        end
    end 
end

%extraer ruta de Agente L entrenado
estado =  searchCoordinateOnTable(shepherds(2,:),Q_board,steps_QBoard);
cnt = 1;
while estado ~= max_recompensa_L
    accion = seleccionar_accion(estado, 0, num_acciones);
    siguiente_estado = obtener_siguiente_estado(estado, accion, num_filas, num_columnas);                      
    estado = siguiente_estado;
    Acciones_pastor_L(cnt) = estado;
    cnt = cnt+1;                        
end

if cnt >2
    for acciones=1:2 
        accion = Acciones_pastor_L(acciones);
        xycoord = SearchIndexOnTable(Q_board,accion);
        coord = [xycoord boidAlt];
        [res11] = sim.simxSetObjectPosition(clientID, target_handle8, -1, coord, sim.simx_opmode_blocking);
        shepherds(2,:) = xycoord;
    end
end