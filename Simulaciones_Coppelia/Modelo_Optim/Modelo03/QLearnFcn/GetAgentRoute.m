function [Ruta_pastor , cnt] = GetAgentRoute(estado,num_acciones,Q,num_filas,num_columnas,max_recompensa)
    Ruta = zeros(1,num_filas*num_filas);
    cnt = 1;
    while estado ~= max_recompensa
        accion           = seleccionar_accion(Q,estado, 0, num_acciones);
        siguiente_estado = obtener_siguiente_estado(estado, accion, num_filas, num_columnas);                     
        estado           = siguiente_estado;
        Ruta(cnt)        = estado;
        cnt              = cnt+1;
        
    end
    Ruta_pastor(1,1:cnt-1) =  Ruta(1,1:cnt-1);
    cnt = cnt-1;
end