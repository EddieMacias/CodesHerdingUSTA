% Función para actualizar la tabla Q
function Q_Act = actualizar_Q(Q,estado, accion, siguiente_estado, recompensa, alpha, gamma)
    Q(estado, accion) = Q(estado, accion) + alpha * (recompensa + gamma * max(Q(siguiente_estado, :)) - Q(estado, accion));
    Q_Act = Q;
end
