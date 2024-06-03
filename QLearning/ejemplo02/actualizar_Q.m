% Función para actualizar la tabla Q
function actualizar_Q(estado, accion, siguiente_estado, recompensa, alpha, gamma)
    global Q;
    Q(estado, accion) = Q(estado, accion) + alpha * (recompensa + gamma * max(Q(siguiente_estado, :)) - Q(estado, accion));
end
