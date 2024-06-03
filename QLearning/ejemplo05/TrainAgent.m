function [Q, training_time] = TrainAgent(num_episodios, num_estados, max_recompensa, Q, epsilon, num_acciones, num_filas, num_columnas, R, alpha, gamma, training_time)
    % Entrenamiento del agente utilizando Q-Learning
    contador_estado = 0;
    for episodio = 1:num_episodios
        tic;
        estado = randi(num_estados);
        while estado ~= max_recompensa
            accion = seleccionar_accion(Q,estado, epsilon, num_acciones);
            siguiente_estado = obtener_siguiente_estado(estado, accion, num_filas, num_columnas);
    
            % evitar saturacion tabla Q
            if estado == siguiente_estado
                contador_estado = contador_estado+1;
                if contador_estado > 20000
                    Q = rand(num_estados, num_acciones); 
                    contador_estado = 0;
                end
            end 
    
            recompensa = R(estado, accion);
            Q = actualizar_Q(Q,estado, accion, siguiente_estado, recompensa, alpha, gamma);
            estado = siguiente_estado;
        end
        training_time(episodio) = toc;
    end
end