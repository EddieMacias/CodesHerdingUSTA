function TestAgent(estado, max_recompensa, Q, num_acciones, num_filas, num_columnas, R)
    cnt = 1;
    while estado ~= max_recompensa
        accion = seleccionar_accion(Q, estado, 0, num_acciones);
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
    
        fprintf('Paso %d, Estado: %d, Acción: %s, Siguiente Estado: %d\n', cnt, estado, act, siguiente_estado);
        estado = siguiente_estado;
        cnt = cnt+1;
        dibujar_gridworld(estado, num_filas, num_columnas, R, max_recompensa);
        pause(0.1);
    end
end