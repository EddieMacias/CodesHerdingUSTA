%prueba del agente entrenado
estado =  searchCoordinateOnTable(shepherds(2,:),Q_board,steps_QBoard);
cnt = 1;
clc
while estado ~= max_recompensa
    accion = seleccionar_accion(estado, 0, num_acciones);
    siguiente_estado = obtener_siguiente_estado(estado, accion, num_filas, num_columnas);
    switch (accion)
        case (1) 
            act  = "Arriba";
        case (2)
            act  = "Abajo";
        case (3)
            act = "Izquierza";
        case (4)
            act = "Derecha";
        otherwise
            act = "nd";
    end                        
    estado = siguiente_estado;
    fprintf('Paso %d, Estado: %d / %d, Acción: %s, Siguiente Estado: %d\n', cnt, estado, max_recompensa ,act, siguiente_estado);
    Acciones_pastor_L(cnt) = estado;
    cnt = cnt+1;                        
    coord = [SearchIndexOnTable(Q_board,siguiente_estado) boidAlt];
    [res11] = sim.simxSetObjectPosition(clientID, target_handle11, -1, coord, sim.simx_opmode_blocking);
    dibujar_gridworld(estado, num_filas, num_columnas, R, max_recompensa);
    pause(0.1);
end