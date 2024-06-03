% Función para seleccionar una acción basada en la política epsilon-greedy
function accion = seleccionar_accion(estado, Q, epsilon, num_acciones)
    if rand() < epsilon
        accion = randi(num_acciones);
    else
        [~, accion] = max(Q(estado, :));
    end
end 