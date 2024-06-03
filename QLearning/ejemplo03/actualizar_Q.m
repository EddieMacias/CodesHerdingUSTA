% Función para actualizar la tabla Q de un pastor
function actualizar_Q(estado, accion, siguiente_estado, recompensa, alpha, gamma, id_pastor)
    global Q_pastores;
    Q_pastores{id_pastor}(estado, accion) =  Q_pastores{id_pastor}(estado, accion) + alpha * ...
                                                       (recompensa + gamma * max(Q_pastores{id_pastor}(siguiente_estado, :)) - ...
                                                        Q_pastores{id_pastor}(estado, accion));
end
