% Función para seleccionar una acción basada en la política epsilon-greedy
function accion = seleccionar_accion(estado, epsilon, num_acciones, Q)
global Q_pastores;
    if rand() < epsilon
        accion = randi(num_acciones);
    else
        [~, accion] = max(Q(estado, :));
    end
end
